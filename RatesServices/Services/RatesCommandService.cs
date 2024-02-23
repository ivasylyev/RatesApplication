using Microsoft.Extensions.Logging;
using RatesServices.Models;

namespace RatesServices.Services;

public class RatesCommandService : Service, IRatesCommandService
{
    public RatesCommandService(ILogger<Service> logger) : base(logger)
    {

    }
    public async Task SaveRate(Rate rate)
    {
        await Task.Yield();
    }
}