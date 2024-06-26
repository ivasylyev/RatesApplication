﻿namespace Vasiliev.Idp.Orchestrator.Models;

public class Rate
{
    public long Id { get; set; }

    public DateOnly StartDate { get; set; }

    public DateOnly EndDate { get; set; }

    public LocationNode? NodeFrom { get; set; }

    public LocationNode? NodeTo { get; set; }

    public ProductGroup? ProductGroup { get; set; }
    public decimal Value { get; set; }

    public bool IsDeflated { get; set; }

    public override string ToString()
    {
        return $"{Id} {StartDate} {EndDate} {NodeFrom?.Code} {NodeTo?.Code} {ProductGroup?.Code} {Value}";
    }

}