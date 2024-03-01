using Vasiliev.Idp.Dto;

namespace Vasiliev.Idp.Calculator.Services;

public interface IProducerService
{
    void SendRates(ICollection<RateDataDto> rates, CancellationToken ct);
}