using Vasiliev.Idp.Dto;

namespace Vasiliev.Idp.Orchestrator.Services;

public interface IKafkaProducerService
{
    void SendRates(IEnumerable<RateDto> rate, CancellationToken ct);

    void SendCommand(RateCommandDto command, CancellationToken ct);
}