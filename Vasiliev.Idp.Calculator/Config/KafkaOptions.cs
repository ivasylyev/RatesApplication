namespace Vasiliev.Idp.Calculator.Config;

public class KafkaOptions
{
    public const string Kafka = "Kafka";

    public string BrokerList { get; set; } = default!;

    public string RatesCalcTopicName { get; set; } = default!;
 
    public int RatesForCalculationPartition { get; set; }

}