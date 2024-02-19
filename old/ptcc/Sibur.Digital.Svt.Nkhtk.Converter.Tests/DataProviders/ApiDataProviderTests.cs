using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using FluentAssertions;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Moq;
using Newtonsoft.Json;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.Converter.DataProviders;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;
using Xunit;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Tests.DataProviders;

public class TemplateServiceTests
{
    [Fact(DisplayName = "Can create ApiDataProvider instance.")]
    [Trait("Category", "Unit")]
    public void Can_Create_Instance()
    {
        // Arrange
        var httpClient = Mock.Of<IHttpDecorator>(MockBehavior.Strict);
        var options = ConfigurationHelper.Options;

        // Act
        var exception = Record.Exception(() => new ApiDataProvider(httpClient, options));

        // Assert
        exception.Should().BeNull();
    }

    [Fact(DisplayName = "Can dispose ApiDataProvider instance.")]
    [Trait("Category", "Unit")]
    public void Can_Dispose_Instance()
    {
        // Arrange
        var httpClient = new Mock<IHttpDecorator>(MockBehavior.Strict);
        httpClient.Setup(c => c.Dispose());
        var options = ConfigurationHelper.Options;

        // Act
        var exception = Record.Exception(() =>
        {
            using (new ApiDataProvider(httpClient.Object, options))
            {
            }
        });

        // Assert
        exception.Should().BeNull();
    }

    [Fact(DisplayName = "ApiDataProvider.GetAsync can return a Healthy result")]
    [Trait("Category", "Unit")]
    public async Task Can_Return_Healthy_Result()
    {
        // Arrange
        var expectedResult = new SiburHealthCheckResult(HealthStatus.Unhealthy, "Description", "msg", "trace");

        var stringContent = new StringContent(JsonConvert.SerializeObject(expectedResult));
        var responseMessage = new HttpResponseMessage { Content = stringContent };

        var httpClient = new Mock<IHttpDecorator>();
        httpClient.Setup(c => c.GetAsync(It.Is<Uri>(s => s.AbsoluteUri == "http://localhost/Controller.Action?")))
            .Returns(() => Task.FromResult(responseMessage));

        var options = ConfigurationHelper.Options;
        var parameters = new Dictionary<string, string>();
        using var provider = new ApiDataProvider(httpClient.Object, options);

        // Act
        var result = await provider.GetAsync<SiburHealthCheckResult>("Controller.Action", parameters)
            .ConfigureAwait(false);

        // Assert
        result.Should().NotBeNull();

        result.Status.Should().Be(expectedResult.Status);
        result.Description.Should().Be(expectedResult.Description);
        result.ExceptionMessage.Should().Be(expectedResult.ExceptionMessage);
        result.ExceptionStackTrace.Should().Be(expectedResult.ExceptionStackTrace);
    }
}