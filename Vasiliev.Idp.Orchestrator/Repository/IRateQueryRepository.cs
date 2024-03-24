using Vasiliev.Idp.Orchestrator.Models;

namespace Vasiliev.Idp.Orchestrator.Repository;

public interface IRateQueryRepository
{
    IAsyncEnumerable<Rate> GetRatesAsync(int take = int.MaxValue, int skip = 0);
    Task<int> GetRatesCountAsync();
    Task<int> GetNonDeflatedRatesCountAsync();
}