using Confluent.Kafka;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Vasiliev.Idp.Command.Config;

namespace Vasiliev.Idp.Command.Services;

public sealed class ConsumerWorker : BackgroundService
{
    private  IConsumer<Null, string> Consumer { get; }
    private ILogger<ConsumerWorker> Logger { get; }
    private KafkaOptions Options { get; }
    IMessageProcessor Processor { get; }



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
    {
        await Task.Run(() => StartConsumerLoop(ct), ct);
    }

    private void StartConsumerLoop(CancellationToken ct)
    {

        Consumer.Subscribe(Options.RatesCallbackTopicName);
        int i = 0;
        while (!ct.IsCancellationRequested)
        {
            try
            {
                var consumeResult = Consumer.Consume(ct);
                i++;
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

    public override void Dispose()
    {
        Consumer.Close(); // Commit offsets and leave the group cleanly.
        Consumer.Dispose();

        base.Dispose();
    }
}