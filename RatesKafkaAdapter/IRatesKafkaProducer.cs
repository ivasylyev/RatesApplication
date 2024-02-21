using RatesDto;
namespace RatesKafkaAdapter;

public interface IRatesKafkaProducer
{
    void SendRates(IEnumerable<RateDto> rate, CancellationToken ct);
}