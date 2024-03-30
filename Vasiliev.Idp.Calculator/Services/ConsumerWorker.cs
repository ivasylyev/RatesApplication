using Confluent.Kafka;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Vasiliev.Idp.Calculator.Config;

namespace Vasiliev.Idp.Calculator.Services;

public sealed class ConsumerWorker : BackgroundService
{
    private IConsumer<Null, string> Consumer { get; }
    private ILogger<ConsumerWorker> Logger { get; }
    private KafkaOptions Options { get; }

    private IMessageProcessor Processor { get; }

    public ConsumerWorker(IMessageProcessor processor, IOptions<KafkaOptions> options, ILogger<ConsumerWorker> logger)
    {
        Processor = processor ?? throw new ArgumentNullException(nameof(processor));
        Options = options.Value ?? throw new ArgumentNullException(nameof(options), $"{nameof(options)} doesn't have Value");
        Logger = logger ?? throw new ArgumentNullException(nameof(logger));

        var config = new ConsumerConfig
        {
            GroupId = Options.GroupId,
            BootstrapServers = Options.BrokerList,
            AutoOffsetReset = AutoOffsetReset.Earliest
        };

        Consumer = new ConsumerBuilder<Null, string>(config).Build();
    }

    protected override async Task ExecuteAsync(CancellationToken ct)
        => await Task.Run(() => StartConsumerLoop(ct), ct);
    

    private void StartConsumerLoop(CancellationToken ct)
    {
        TopicAssignOrSubscribe();

        while (!ct.IsCancellationRequested)
        {
            try
            {
                var consumeResult = Consumer.Consume(ct);

                if (consumeResult != null)
                {
                    Logger.LogTrace($"{consumeResult.Message?.Key}: {consumeResult.Message?.Value}");

                    Processor.Process(consumeResult.Message?.Value, ct);
                }
            }
            catch (OperationCanceledException)
            {
                Logger.LogInformation("Consuming operation is cancelled");
                break;
            }
            catch (ConsumeException e)
            {
                Logger.LogError($"Consume error: {e.Error.Reason}");
                if (e.Error.IsFatal)
                {
                    Logger.LogCritical(e, "Fatal error.");
                    break;
                }
            }
            catch (Exception e)
            {
                Logger.LogCritical(e, "Unexpected error.");
                break;
            }
        }
    }

    /// <summary>
    /// Assign to the partition specified in the environment variable "RATES_CALCULATION_PARTITION"
    /// Subscribe to the whole topi if the variable is not set
    /// </summary>
    private void TopicAssignOrSubscribe()
    {
        CheckConfig(nameof(Options.EnvironmentPartitionName), Options.EnvironmentPartitionName);
        CheckConfig(nameof(Options.RatesCalcTopicName), Options.RatesCalcTopicName);

        var environmentPartition = Environment.GetEnvironmentVariable(Options.EnvironmentPartitionName);
        var topicName = Options.RatesCalcTopicName;
        if (int.TryParse(environmentPartition, out int partition))
        {
            Consumer.Assign(new TopicPartition(topicName, partition));
            Logger.LogInformation($"Assigned to topic {topicName} partition {partition}");
        }
        else
        {
            Consumer.Subscribe(topicName);
            Logger.LogInformation($"Subscribed to topic {topicName}");
        }
    }


    private void CheckConfig(string paramName, string paramValue)
    {
        if (string.IsNullOrEmpty(paramValue))
        {
            throw new InvalidOperationException($"Config parameter {paramName} is not set");
        }
    }

    public override void Dispose()
    {
        Consumer.Close(); // Commit offsets and leave the group cleanly.
        Consumer.Dispose();

        base.Dispose();
    }
}