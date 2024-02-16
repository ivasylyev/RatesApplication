using RatesModels;


namespace RatesServices;

public class RatesCommandService : IRatesCommandService
{
    public async Task SaveRate(RateListItemDto rate)
    {
        await Task.Yield();
    }
}