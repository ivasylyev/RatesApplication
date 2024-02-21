namespace RatesModels;

public class Rate
{
    public long RateId { get; set; }

    public DateOnly StartDate { get; set; }

    public DateOnly EndDate { get; set; }

    public LocationNode? NodeFrom { get; set; }

    public LocationNode? NodeTo { get; set; }

    public decimal Value { get; set; }

    public bool IsDeflated { get; set; }
}