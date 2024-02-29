using Microsoft.Extensions.Logging;
using Vasiliev.Idp.Dto;

namespace Vasiliev.Idp.Command;

public class CommandService : ICommandService
{
    protected CommandService(ILogger<CommandService> logger)
    {
        Logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }

    protected ILogger<CommandService> Logger { get; }
    public async Task SaveRate(RateDataDto rateData)
    {
        await Task.Yield();
    }
}