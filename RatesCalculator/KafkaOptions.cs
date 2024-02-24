namespace RatesCalculator;

public class KafkaOptions
{
    public const string Kafka = "Kafka";

    public string? BrokerList { get; set; }

    public string? RatesForCalculationTopicName { get; set; }

}