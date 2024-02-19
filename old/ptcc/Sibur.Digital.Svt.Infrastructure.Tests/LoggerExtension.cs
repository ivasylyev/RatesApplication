using System;
using Microsoft.Extensions.Logging;
using Moq;

namespace Sibur.Digital.Svt.Infrastructure.Tests;

public static class LoggerExtension
{
    /// <summary>
    /// Проверяет вызов обобщенного логера с данными параметрами
    /// </summary>
    /// <typeparam name="T">Параметр-тип обобщения</typeparam>
    /// <param name="loggerMock">логер</param>
    /// <param name="logLevel">уровень логированя, которому должен соответсвовать проверямый вызов</param>
    /// <param name="message">сообщение, которое должно содержаться в совершаемом вызове</param>
    public static void Verify<T>(this Mock<ILogger<T>> loggerMock, LogLevel logLevel, string message) =>
        loggerMock.Verify(x => x.Log(
            It.Is<LogLevel>(l => l == logLevel),
            It.IsAny<EventId>(),
            It.Is<It.IsAnyType>((o, t) => (o.ToString() ?? string.Empty).Contains(message)),
            It.IsAny<Exception?>(),
            (Func<It.IsAnyType, Exception?, string>)It.IsAny<object>()));
}