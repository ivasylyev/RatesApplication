using Vasiliev.Idp.Dto;

namespace Vasiliev.Idp.Command.Repository;

public interface IRateRepository
{
    Task InsertOrUpdateRate(RateDataDto rate, CancellationToken ct);
    Task InsertOrUpdateRatesAsync(ICollection<RateDataDto> rates, CancellationToken ct);
}