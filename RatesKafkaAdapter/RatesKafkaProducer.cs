using Confluent.Kafka;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using RatesModels;

namespace RatesKafkaAdapter;

public class RatesKafkaProducer : KafkaService, IRatesKafkaProducer
{
    private readonly int _coolDownIntervalSec = 10;
    private readonly string _brokerList = "localhost:9092";
    private readonly string _topicName = "quickstart-events";

    private readonly IProducer<Null, string> _producer;

    public RatesKafkaProducer(ILogger<KafkaService> logger) : base(logger)
    {
        var config = new ProducerConfig { BootstrapServers = _brokerList };
        _producer = new ProducerBuilder<Null, string>(config).Build();
        Logger.LogInformation($"{_producer.Name} producing on {_topicName}.");
    }


    public void SendRates(IEnumerable<RateListItemDto> rates, CancellationToken ct = default)
    {
        try
        {
            foreach (var rate in rates)
            {
                if (ct.IsCancellationRequested)
                    break;
                var value = JsonConvert.SerializeObject(rate);
                var message = new Message<Null, string> { Value = value };
                _producer.Produce(_topicName, message, DeliveryHandler);
            }

            _producer.Flush(TimeSpan.FromSeconds(_coolDownIntervalSec));
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