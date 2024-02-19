using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using FluentAssertions;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Sibur.Digital.Svt.Infrastructure.Utils;
using Xunit;

namespace Sibur.Digital.Svt.Infrastructure.Tests.Utils;

public class HealthCheckResponseWriterTests
{
    [Theory(DisplayName = "HealthCheckResponseWriter can write a response.")]
    [Trait("Category", "Unit")]
    [InlineData(HealthStatus.Healthy)]
    [InlineData(HealthStatus.Unhealthy)]
    public async Task Write_Response(HealthStatus status)
    {
        // Arrange
        var entries = new Dictionary<string, HealthReportEntry>();
        var healthReport = new HealthReport(entries, status, TimeSpan.FromSeconds(1));
        var context = new DefaultHttpContext();

        // Act
        var exception = await Record.ExceptionAsync(async ()
                => await HealthCheckResponseWriter.WriteResponseAsync(context, healthReport)
                    .ConfigureAwait(false))
            .ConfigureAwait(false);

        // Assert
        exception.Should().BeNull();
        context.Response.ContentType.Should().BeEquivalentTo(HealthCheckResponseWriter.JsonContentType);
    }
}