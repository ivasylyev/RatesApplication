namespace Vasiliev.Idp.Orchestrator.Config;

public class KafkaOptions
{
    public const string Kafka = "Kafka";

    public int CoolDownIntervalSec { get; set; }
    public string? BrokerList { get; set; }

    public string? RatesCalcTopicName { get; set; }
    public int RatesCalcPartitionCount { get; set; }

}