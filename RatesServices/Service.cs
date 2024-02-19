using Microsoft.Extensions.Logging;

namespace RatesServices;

public class Service
{
    protected Service(ILogger<Service> logger)
    {
        Logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }

    protected ILogger<Service> Logger { get; }
}