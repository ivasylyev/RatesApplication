using Vasiliev.Idp.Dto;

namespace Vasiliev.Idp.Calculator.Repository;

public class RateRepository : IRateRepository
{
    private const int YearsToDeflate = 2;
    private const decimal ValueCoefficient = 1.1m;
    private Dictionary<string, RateDataDto> Rates { get; } = new();

    public void Reset()
    {
        Rates.Clear();
    }
    public ICollection<RateDataDto> GetRates() 
        => Rates.Values;

    public void AddRate(RateDataDto rate)
    {
        foreach (var r in DeflateRate(rate))
        {
            var key = $"{r.NodeToId}_{r.NodeFromId}_{r.ProductGroupId}_{r.StartDate}_{r.EndDate}";

            if (r.IsDeflated && Rates.TryGetValue(key, out var existingRate) && !existingRate.IsDeflated)
                return;
            Rates[key] = r;
        }
    }


    private IEnumerable<RateDataDto> DeflateRate(RateDataDto rate)
    {
        yield return rate;

        for (var year = 1; year <= YearsToDeflate; year++)
            yield return new RateDataDto
            {
                IsDeflated = true,
                StartDate = rate.StartDate.AddYears(year),
                EndDate = rate.StartDate.AddYears(year),
                NodeFromId = rate.NodeFromId,
                NodeToId = rate.NodeToId,
                ProductGroupId = rate.ProductGroupId,
                Value = rate.Value * ValueCoefficient
            };
    }
}