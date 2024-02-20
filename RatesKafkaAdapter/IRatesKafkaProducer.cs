using RatesModels;

namespace RatesKafkaAdapter
{
    public interface IRatesKafkaProducer
    {
        void SendRates(IEnumerable<RateListItemDto> rate, CancellationToken ct);
    }
}