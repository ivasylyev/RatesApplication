using RatesModels;

namespace RatesServices
{
    public interface IRatesQueryService
    {
        IAsyncEnumerable<RateListItemDto> GetRatesAsync(int take = int.MaxValue, int skip = 0);
    }
}