using Microsoft.Extensions.Logging;
using RatesDto;

namespace Vasiliev.Idp.Command;

public class RatesCommandService : IRatesCommandService
{
    protected RatesCommandService(ILogger<RatesCommandService> logger)
    {
        Logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }

    protected ILogger<RatesCommandService> Logger { get; }
    public async Task SaveRate(RateDto rate)
    {
        await Task.Yield();
    }
}