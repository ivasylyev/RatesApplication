using System;
using System.Net.Http;
using System.Threading.Tasks;
using FluentAssertions;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.Extensions.Logging;
using Moq;
using Newtonsoft.Json;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Infrastructure.Tests;
using Sibur.Digital.Svt.Nkhtk.Converter.DataProviders;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;
using Xunit;
using HealthCheckService = Sibur.Digital.Svt.Nkhtk.Converter.Services.HealthCheckService;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Tests.Services;

public class HealthCheckServiceTests
{
    [Fact(DisplayName = "Can create HealthCheckService instance.")]
    [Trait("Category", "Unit")]
    public void Can_Create_Instance()
    {
        // Arrange
        var provider = Mock.Of<IApiDataProvider>();
        var options = ConfigurationHelper.Options;
        var logger = Mock.Of<ILogger<HealthCheckService>>();

        // Act
        var exception = Record.Exception(() => new HealthCheckService(provider, options, logger));

        // Assert
        exception.Should().BeNull();
    }

    [Fact(DisplayName = "Verify Health status within HealthCheckService.CheckHealthAsync")]
    [Trait("Category", "Integration")]
    public async Task Verify_Health_Check_Status()
    {
        // Arrange
        var loggerMock = new Mock<ILogger<HealthCheckService>>();
        var expectedResult = new SiburHealthCheckResult(HealthStatus.Unhealthy, "Description", "msg", "trace");
        var responseMessage = new HttpResponseMessage { Content = new StringContent(JsonConvert.SerializeObject(expectedResult)) };

        var httpClient = new Mock<IHttpDecorator>(MockBehavior.Strict);
        httpClient.Setup(c => c.GetAsync(It.Is<Uri>(s => s.AbsoluteUri == "http://localhost/hc?")))
            .Returns(() => Task.FromResult(responseMessage));
        httpClient.Setup(c => c.Dispose());

        using var provider = new ApiDataProvider(httpClient.Object, ConfigurationHelper.Options);
        var healthCheck = new HealthCheckService(provider, ConfigurationHelper.Options, loggerMock.Object);
        var context = new HealthCheckContext();

        // Act
        var health = await healthCheck.CheckHealthAsync(context)
            .ConfigureAwait(false);
        // Assert
        health.Status.Should().Be(HealthStatus.Unhealthy);
        loggerMock.Verify(LogLevel.Error, "Health Check Error");
    }
}