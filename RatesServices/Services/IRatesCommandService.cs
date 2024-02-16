using RatesModels;

namespace RatesServices.Services
{
    public interface IRatesCommandService
    {
        Task SendRate(RateListItemDto rate);
    }
}