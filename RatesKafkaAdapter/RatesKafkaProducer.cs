using Confluent.Kafka;
using Newtonsoft.Json;
using RatesModels;

namespace RatesKafkaAdapter;

public class RatesKafkaProducer : IRatesKafkaProducer
{
    private readonly string _brokerList = "brokerList";
    private readonly string _topicName = "My_Topic";

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
            // TODO: uncomment
            // await _producer.ProduceAsync(_topicName, new Message<string, string> { Value = value });
        }
        catch (Exception e)
        {
            Console.WriteLine($"error producing message: {e.Message}");
        }

        await Task.Yield();
    }
}