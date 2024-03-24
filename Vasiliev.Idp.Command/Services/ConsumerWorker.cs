using Confluent.Kafka;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Vasiliev.Idp.Command.Config;
using Vasiliev.Idp.Dto;

namespace Vasiliev.Idp.Command.Services;

public sealed class ConsumerWorker : BackgroundService
{
    public ConsumerWorker(IMessageProcessor processor, IOptions<KafkaOptions> options, ILogger<ConsumerWorker> logger)
    {
        Processor = processor ?? throw new ArgumentNullException(nameof(processor));
        Options = options.Value ??
                  throw new ArgumentNullException(nameof(options), $"{nameof(options)} doesn't have Value");
        Logger = logger ?? throw new ArgumentNullException(nameof(logger));

        var config = new ConsumerConfig
        {
            GroupId = Options.GroupId,
            BootstrapServers = Options.BrokerList,
            AutoOffsetReset = AutoOffsetReset.Earliest
        };

        Consumer = new ConsumerBuilder<Null, string>(config).Build();
    }

    private IConsumer<Null, string> Consumer { get; }
    private ILogger<ConsumerWorker> Logger { get; }
    private KafkaOptions Options { get; }
    private IMessageProcessor Processor { get; }

    protected override async Task ExecuteAsync(CancellationToken ct)
    {
        var consumerTask = Task.Run(() => StartConsumerLoop(ct), ct);
        var processorTask = Task.Run(async () => await StartProcessorLoop(ct), ct);
        await Task.WhenAll(consumerTask, processorTask);
    }

    private void StartConsumerLoop(CancellationToken ct)
    {
        Consumer.Subscribe(Options.RatesCallbackTopicName);
        Logger.LogInformation("Consuming loop is started");

        while (!ct.IsCancellationRequested)
        {
            try
            {
                var consumeResult = Consumer.Consume(ct);
                if (consumeResult != null)
                {
                    Logger.LogTrace($"{consumeResult.Message?.Key}: {consumeResult.Message?.Value}");

                    Processor.Enqueue(consumeResult.Message?.Value, ct);
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
        Logger.LogInformation("Consuming loop is stopped");
    }

    private async Task StartProcessorLoop(CancellationToken ct)
    {
        Logger.LogInformation("Processing loop is started");
        while (!ct.IsCancellationRequested)
        {
            try
            {
                await Processor.ProcessMessageQueue(ct);
            }

            catch (Exception e)
            {
                Logger.LogError(e, "cannot process rates.");
            }
        }
        Logger.LogInformation("Processing loop is stopped");
    }

    public override void Dispose()
    {
        Consumer.Close(); // Commit offsets and leave the group cleanly.
        Consumer.Dispose();

        base.Dispose();
    }
}