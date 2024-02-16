using RatesModels;

namespace RatesKafkaAdapter
{
    public interface IRatesKafkaProducer
    {
        Task SendRate(RateListItemDto rate);
    }
}