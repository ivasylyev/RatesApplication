using Dapper;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Sibur.Digital.Svt.Nkhtk.Data.Interfaces;

namespace Sibur.Digital.Svt.Nkhtk.Data.Services;

/// <inheritdoc />
public class HealthCheckService : IHealthCheck
{
    private readonly ILogger<HealthCheckService> _logger;
    private readonly IDataProvider _provider;

    public HealthCheckService(IDataProvider provider, ILogger<HealthCheckService> logger)
    {
        _provider = provider;
        _logger = logger;
    }

    /// <inheritdoc />
    public async Task<HealthCheckResult> CheckHealthAsync(HealthCheckContext context, CancellationToken cancellationToken = default)
    {
        try
        {
            using var con = _provider.CreateConnection();
            await con.ExecuteAsync("SELECT 1")
                .ConfigureAwait(false);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Health Check Error");

            return HealthCheckResult.Unhealthy(exception: ex);
        }

        return HealthCheckResult.Healthy();
    }
}