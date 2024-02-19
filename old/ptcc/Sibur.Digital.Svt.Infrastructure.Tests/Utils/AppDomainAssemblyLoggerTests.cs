using FluentAssertions;
using Microsoft.Extensions.Logging;
using Moq;
using Sibur.Digital.Svt.Infrastructure.Utils;
using Xunit;

namespace Sibur.Digital.Svt.Infrastructure.Tests.Utils;

public class AppDomainAssemblyLoggerTests
{
    [Fact(DisplayName = "AppDomainAssemblyLogger can log loaded assembly when starts.")]
    [Trait("Category", "Unit")]
    public void Log_Loaded_Assembly()
    {
        // Arrange
        var loggerMock = new Mock<ILogger<AppDomainAssemblyLogger>>();
        var assemblyLogger = new AppDomainAssemblyLogger(loggerMock.Object);

        // Act
        // Начинаем логирование загруженных в домен библиотек
        var exception = Record.Exception(() => assemblyLogger.StartLog());

        // Assert
        exception.Should().BeNull();
        // проверяем, что есть сообщение о факте загрузки
        loggerMock.Verify(LogLevel.Information, "Loaded assembly: Sibur.Digital.Svt.Infrastructure.Tests");
    }
}