using Confluent.Kafka;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using Vasiliev.Idp.Dto;
using Vasiliev.Idp.Orchestrator.Config;

namespace Vasiliev.Idp.Orchestrator.Services;

public class KafkaProducerService : IKafkaProducerService
{
    private readonly IProducer<Null, string> _producer;
    protected KafkaOptions Options { get; }
    protected ILogger<KafkaProducerService> Logger { get; }
    public KafkaProducerService(IOptions<KafkaOptions> options, ILogger<KafkaProducerService> logger) 
    {
        Options = options.Value ?? throw new ArgumentNullException(nameof(options), $"{nameof(options)} doesn't have Value");
        Logger = logger ?? throw new ArgumentNullException(nameof(logger));

        var config = new ProducerConfig { BootstrapServers = Options.BrokerList };
        _producer = new ProducerBuilder<Null, string>(config).Build();
        Logger.LogInformation($"{_producer.Name} producing on {Options.RatesForCalculationTopicName}.");
    }

    public void SendRates(IEnumerable<RateDto> rates, CancellationToken ct)
    {
        try
        {
            foreach (var rate in rates)
            {
                if (ct.IsCancellationRequested)
                    break;
                var value = JsonConvert.SerializeObject(rate);
                var message = new Message<Null, string> { Value = value };
                _producer.Produce(Options.RatesForCalculationTopicName, message, DeliveryHandler);
            }

            _producer.Flush(TimeSpan.FromSeconds(Options.CoolDownIntervalSec));
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