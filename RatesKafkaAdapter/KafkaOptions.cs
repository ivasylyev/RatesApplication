namespace RatesKafkaAdapter;

public class KafkaOptions
{
    public const string Kafka = "Kafka";

    public int CoolDownIntervalSec { get; set; }
    public string? BrokerList { get; set; }

    public string? RatesOutTopicName { get; set; }

}