using FluentAssertions;
using Microsoft.Extensions.Logging;
using Moq;
using Sibur.Digital.Svt.Infrastructure.Utils;
using Xunit;

namespace Sibur.Digital.Svt.Infrastructure.Tests.Utils;

public class StopwatchTransactionTests
{
    [Fact(DisplayName = "Can create StopwatchTransaction instance.")]
    [Trait("Category", "Unit")]
    public void Can_Create_Instance()
    {
        // Arrange
        var logger = Mock.Of<ILogger<StopwatchTransaction>>();

        // Act
        var exception = Record.Exception(() => new StopwatchTransaction(logger, "test"));

        // Assert
        exception.Should().BeNull();
    }

    [Fact(DisplayName = "StopwatchTransaction.Dispose can write a log message")]
    [Trait("Category", "Unit")]
    public void Writes_Log_Message()
    {
        // Arrange
        var loggerMock = new Mock<ILogger<StopwatchTransaction>>();

        // Act
        var exception = Record.Exception(() =>
        {
            using (new StopwatchTransaction(loggerMock.Object, "test"))
            {
            }
        });

        // Assert
        exception.Should().BeNull();
        loggerMock.Verify(LogLevel.Debug, "test");
    }
}