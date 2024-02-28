using Confluent.Kafka;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Vasiliev.Idp.Calculator.Config;

namespace Vasiliev.Idp.Calculator.Services;

public class ConsumerWorker : BackgroundService
{
    private readonly IConsumer<Null, string> _consumer;
    protected ILogger<ConsumerWorker> Logger { get; }
    protected KafkaOptions Options { get; }

    public ConsumerWorker(IOptions<KafkaOptions> options, ILogger<ConsumerWorker> logger)
    {
        Options = options.Value ?? throw new ArgumentNullException(nameof(options), $"{nameof(options)} doesn't have Value");
        Logger = logger ?? throw new ArgumentNullException(nameof(logger));

        var config = new ConsumerConfig
        {
            GroupId = "test-consumer-group4",
            BootstrapServers = Options.BrokerList,
            AutoOffsetReset = AutoOffsetReset.Earliest
        };

        _consumer = new ConsumerBuilder<Null, string>(config).Build();

    }

    protected override async Task ExecuteAsync(CancellationToken ct)
    {
        await Task.Run(() => StartConsumerLoop(ct), ct);
    }

    private void StartConsumerLoop(CancellationToken ct)
    {
         _consumer.Subscribe(Options.RatesCalcCommandTopicName);
             // _consumer.Assign(new TopicPartition(Options.RatesCalcDataTopicName, Options.RatesForCalculationPartition));

        while (!ct.IsCancellationRequested)
        {
            try
            {
                var consumeResult = _consumer.Consume(ct);
                

                Logger.LogTrace($"{consumeResult.Message.Key}: {consumeResult.Message.Value}");
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

    public override void Dispose()
    {
        _consumer.Close(); // Commit offsets and leave the group cleanly.
        _consumer.Dispose();

        base.Dispose();
    }
}