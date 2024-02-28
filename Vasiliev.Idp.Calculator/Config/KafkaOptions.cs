namespace Vasiliev.Idp.Calculator.Config;

public class KafkaOptions
{
    public const string Kafka = "Kafka";

    public string? BrokerList { get; set; }

    public string RatesCalcDataTopicName { get; set; } = default!;
    public string RatesCalcCommandTopicName { get; set; } = default!;

    public int RatesForCalculationPartition { get; set; }

}