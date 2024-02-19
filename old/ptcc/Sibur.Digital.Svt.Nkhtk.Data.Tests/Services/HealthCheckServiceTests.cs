using System.Threading.Tasks;
using FluentAssertions;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.Extensions.Logging;
using Moq;
using Sibur.Digital.Svt.Nkhtk.Data.DataProviders;
using Sibur.Digital.Svt.Nkhtk.Data.Interfaces;
using Xunit;
using HealthCheckService = Sibur.Digital.Svt.Nkhtk.Data.Services.HealthCheckService;

namespace Sibur.Digital.Svt.Nkhtk.Data.Tests.Services;

public class HealthCheckServiceTests
{
    [Fact(DisplayName = "Can create HealthCheckService.")]
    [Trait("Category", "Unit")]
    public void Can_Create_Instance()
    {
        // Arrange
        var provider = Mock.Of<IDataProvider>(MockBehavior.Strict);
        var logger = Mock.Of<ILogger<HealthCheckService>>(MockBehavior.Strict);

        // Act
        var exception = Record.Exception(() => new HealthCheckService(provider, logger));

        // Assert
        exception.Should().BeNull();
    }

    [Fact(DisplayName = "HealthCheckService.CheckHealthAsync returns Health status")]
    [Trait("Category", "Integration")]
    public async Task Returns_Check_Status()
    {
        // Arrange
        var logger = Mock.Of<ILogger<HealthCheckService>>(MockBehavior.Strict);
        var config = ConfigurationHelper.GetConfiguration(MockBehavior.Strict);
        var provider = new DapperDataProvider(config);
        var healthCheck = new HealthCheckService(provider, logger);
        var context = new HealthCheckContext();

        // Act
        var health = await healthCheck.CheckHealthAsync(context);

        // Assert
        health.Should().NotBeNull();
        health.Status.Should().Be(HealthStatus.Healthy);
    }
}