using System.Text.Json;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.Extensions.Options;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.Converter.Config;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Services;

/// <inheritdoc />
public class HealthCheckService : IHealthCheck
{
    private readonly string _getHealthCheckAction;
    private readonly ILogger<HealthCheckService> _logger;

    private readonly IApiDataProvider _provider;

    public HealthCheckService(IApiDataProvider provider, IOptions<ApiOptions> options, ILogger<HealthCheckService> logger)
    {
        _provider = provider;
        _getHealthCheckAction = options.Value?.GetHealthCheckAction ??
                                throw new ArgumentNullException(nameof(options), $"{nameof(options)} doesn't have parameter {nameof(ApiOptions.GetHealthCheckAction)} specified");
        _logger = logger;
    }

    /// <inheritdoc />
    public async Task<HealthCheckResult> CheckHealthAsync(HealthCheckContext context, CancellationToken cancellationToken = default)
    {
        try
        {
            var dataHealth = await _provider.GetAsync<SiburHealthCheckResult>(_getHealthCheckAction)
                .ConfigureAwait(false);

            if (dataHealth.Status != HealthStatus.Healthy)
            {
                var description = $"Not a healthy status result Data Service: '{JsonSerializer.Serialize(dataHealth)}'";
                _logger.LogError("Health Check Error: {Description}", description);

                return HealthCheckResult.Unhealthy(description);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Health Check Error");

            return HealthCheckResult.Unhealthy(exception: ex);
        }

        return HealthCheckResult.Healthy();
    }
}