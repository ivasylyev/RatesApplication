using Vasiliev.Idp.Orchestrator.Models;

namespace Vasiliev.Idp.Orchestrator.Services;

public interface IQueryService
{
    IAsyncEnumerable<Rate> GetRatesAsync(int take = int.MaxValue, int skip = 0);
    Task<int> GetRateCountAsync();
}