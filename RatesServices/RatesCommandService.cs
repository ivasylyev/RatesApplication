using Microsoft.Extensions.Logging;
using RatesModels;


namespace RatesServices;

public class RatesCommandService : Service, IRatesCommandService
{
    public RatesCommandService(ILogger<Service> logger) : base(logger)
    {

    }
    public async Task SaveRate(RateListItemDto rate)
    {
        await Task.Yield();
    }
}