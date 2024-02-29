using Confluent.Kafka;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using Vasiliev.Idp.Calculator.Config;
using Vasiliev.Idp.Dto;

namespace Vasiliev.Idp.Calculator.Services;

public sealed class ConsumerWorker : BackgroundService
{
    private  IConsumer<Null, string> Consumer { get; }
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
            GroupId = "test-consumer-group4",
            BootstrapServers = Options.BrokerList,
            AutoOffsetReset = AutoOffsetReset.Earliest
        };

        Consumer = new ConsumerBuilder<Null, string>(config).Build();

    }

    protected override async Task ExecuteAsync(CancellationToken ct)
    {
        await Task.Run(() => StartConsumerLoop(ct), ct);
    }

    private void StartConsumerLoop(CancellationToken ct)
    {

        Consumer.Assign(new TopicPartition(Options.RatesCalcTopicName, Options.RatesForCalculationPartition));

        while (!ct.IsCancellationRequested)
        {
            try
            {
                var consumeResult = Consumer.Consume(ct);

                if (consumeResult != null && !string.IsNullOrEmpty(consumeResult.Message?.Value))
                {
                    Logger.LogTrace($"{consumeResult.Message.Key}: {consumeResult.Message.Value}");
                    var message = JsonConvert.DeserializeObject<RateMessageDto>(consumeResult.Message.Value);
                    Processor.Process(message);
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

    public override void Dispose()
    {
        Consumer.Close(); // Commit offsets and leave the group cleanly.
        Consumer.Dispose();

        base.Dispose();
    }
}