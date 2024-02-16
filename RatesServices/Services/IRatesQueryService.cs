using RatesModels;

namespace RatesServices.Services
{
    public interface IRatesQueryService
    {
        IAsyncEnumerable<RateListItemDto> GetRatesAsync(int take = int.MaxValue, int skip = 0);
        Task<int> GetRateCountAsync();
    }
}