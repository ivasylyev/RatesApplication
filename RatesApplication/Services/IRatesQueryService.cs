using RatesServices.Models;

namespace RatesServices.Services;

public interface IRatesQueryService
{
    IAsyncEnumerable<Rate> GetRatesAsync(int take = int.MaxValue, int skip = 0);
    Task<int> GetRateCountAsync();
}