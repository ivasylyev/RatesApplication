using Vasiliev.Idp.Dto;

namespace Vasiliev.Idp.Orchestrator.Services;

public interface IKafkaProducer
{
    void SendRates(IEnumerable<RateDto> rate, CancellationToken ct);
}