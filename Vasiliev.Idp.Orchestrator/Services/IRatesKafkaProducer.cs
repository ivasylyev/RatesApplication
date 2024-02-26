using Vasiliev.Idp.Dto;

namespace Vasiliev.Idp.Orchestrator.Services;

public interface IRatesKafkaProducer
{
    void SendRates(IEnumerable<RateDto> rate, CancellationToken ct);
}