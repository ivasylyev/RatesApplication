using Confluent.Kafka;
using Newtonsoft.Json;
using RatesModels;

namespace RatesKafkaAdapter;

public class RatesKafkaProducer : IRatesKafkaProducer
{
    private readonly string _brokerList = "localhost:9092";
    private readonly string _topicName = "quickstart-events";

    private readonly IProducer<string, string> _producer;

    public RatesKafkaProducer()
    {
        var config = new ProducerConfig { BootstrapServers = _brokerList };
        _producer = new ProducerBuilder<string, string>(config).Build();
        Console.WriteLine($"{_producer.Name} producing on {_topicName}. Enter first names, q to exit.");
    }

    public async Task SendRate(RateListItemDto rate)
    {
        try
        {
            var value = JsonConvert.SerializeObject(rate);
            await _producer.ProduceAsync(_topicName, new Message<string, string> { Value = value });
        }
        catch (Exception e)
        {
            Console.WriteLine($"error producing message: {e.Message}");
        }
    }
}