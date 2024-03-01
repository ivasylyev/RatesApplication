using Confluent.Kafka;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using Vasiliev.Idp.Calculator.Config;
using Vasiliev.Idp.Dto;

namespace Vasiliev.Idp.Calculator.Services;

public class ProducerService : IProducerService
{
    private const int BufferSize = 100;
    private readonly IProducer<Null, string> _producer;
    protected KafkaOptions Options { get; }
    protected ILogger<ProducerService> Logger { get; }

    public ProducerService(IOptions<KafkaOptions> options, ILogger<ProducerService> logger)
    {
        Options = options.Value ??
                  throw new ArgumentNullException(nameof(options), $"{nameof(options)} doesn't have Value");
        Logger = logger ?? throw new ArgumentNullException(nameof(logger));

        var config = new ProducerConfig { BootstrapServers = Options.BrokerList };
        _producer = new ProducerBuilder<Null, string>(config).Build();
        Logger.LogInformation(
            $"{_producer.Name} producing on {Options.RatesCallbackTopicName}");
    }

    public void SendRates(ICollection<RateDataDto> rates, CancellationToken ct)
    {
        try
        {
            Logger.LogDebug($"{_producer.Name} started producing {rates.Count} values to {Options.RatesCallbackTopicName}");

            int i = 0;
            var chunks = rates
                .GroupBy(_ => i++ / BufferSize);
            // .Select(g => g);

            foreach (var chunk in chunks)
            {
                Logger.LogTrace($"{_producer.Name} producing chunk of rates to {Options.RatesCallbackTopicName}");
                
                foreach (var rate in chunk)
                {
                    if (ct.IsCancellationRequested)
                        break;
                    var value = JsonConvert.SerializeObject(new RateMessageDto(rate));
                    var message = new Message<Null, string> { Value = value };
                    _producer.Produce(Options.RatesCallbackTopicName, message, DeliveryHandler);
                }

                _producer.Flush(TimeSpan.FromSeconds(Options.CoolDownIntervalSec));
            }
            Logger.LogDebug($"{_producer.Name} completed producing {rates.Count} values to {Options.RatesCallbackTopicName}");
        }
        catch (Exception e)
        {
            Logger.LogError(e, "Cannot send rate");
        }
    }


    private void DeliveryHandler(DeliveryReport<Null, string> r)
    {
        if (r.Error.IsError)
        {
            Logger.LogError($"Delivery Error: {r.Error.Reason}");
        }
        else
        {
            Logger.LogTrace($"Delivered message to {r.TopicPartitionOffset}");
        }
    }
}