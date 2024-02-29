﻿namespace Vasiliev.Idp.Calculator.Config;

public class KafkaOptions
{
    public const string Kafka = "Kafka";

    public string? BrokerList { get; set; }

    public string? RatesCalcTopicName { get; set; }
 
    public int RatesForCalculationPartition { get; set; }

}