namespace Vasiliev.Idp.Orchestrator.Config;

public class KafkaOptions
{
    public const string Kafka = "Kafka";

    public int CoolDownIntervalSec { get; set; }
    public string? BrokerList { get; set; }

    public string RatesCalcDataTopicName { get; set; } = default!;
    public string RatesCalcCommandTopicName { get; set; } = default!;

}