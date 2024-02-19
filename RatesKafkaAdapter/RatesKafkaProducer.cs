using Confluent.Kafka;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using RatesModels;

namespace RatesKafkaAdapter;

public class RatesKafkaProducer : KafkaService, IRatesKafkaProducer
{
    private readonly string _brokerList = "localhost:9092";
    private readonly string _topicName = "quickstart-events";

    private readonly IProducer<string, string> _producer;

    public RatesKafkaProducer(ILogger<KafkaService> logger) : base(logger)
    {
        var config = new ProducerConfig { BootstrapServers = _brokerList };
        _producer = new ProducerBuilder<string, string>(config).Build();
        Console.WriteLine($"{_producer.Name} producing on {_topicName}.");
    }

    public async Task SendRate(RateListItemDto rate, CancellationToken ct = default)
    {
        try
        {
            var value = JsonConvert.SerializeObject(rate);
            var message = new Message<string, string> { Value = value };
            await _producer.ProduceAsync(_topicName, message, ct);
           
        }
        catch (Exception e)
        {
            Logger.LogError(e, "Cannot send rate");
        }
    }
} 