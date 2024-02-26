using Vasiliev.Idp.Dto;

namespace RatesApplication.Services;

public interface IRatesKafkaProducer
{
    void SendRates(IEnumerable<RateDto> rate, CancellationToken ct);
}