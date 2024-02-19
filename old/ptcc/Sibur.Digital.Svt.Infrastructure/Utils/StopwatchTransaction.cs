using System.Diagnostics;
using Microsoft.Extensions.Logging;

namespace Sibur.Digital.Svt.Infrastructure.Utils;

/// <summary>
/// Логирует время своего существования.
/// Используется, чтобы засекать выполнения операций, выполняемых внутри контектса данной транзакции
/// </summary>
/// <example>
/// using (new StopwatchTransaction(_logger, "log message message"))
/// {
/// // do something useful;
/// }
/// </example>
public class StopwatchTransaction : IDisposable
{
    private readonly ILogger _logger;
    private readonly string _message;
    private readonly Stopwatch _stopwatch;
    private bool _disposed;

    /// <summary>
    /// Создает экземпляр <see cref="StopwatchTransaction" /> и засекает время создания
    /// </summary>
    /// <param name="logger">Логер</param>
    /// <param name="message">Логируемое сообщение</param>
    /// <exception cref="ArgumentNullException">Если logger равен null</exception>
    public StopwatchTransaction(ILogger logger, string message)
    {
        _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        _message = message;

        (_stopwatch = new Stopwatch()).Start();
    }

    /// <summary>
    /// Очищает экземпляр <see cref="StopwatchTransaction" /> и выводит в лог время его жизни
    /// </summary>
    public void Dispose()
    {
        Dispose(true);
        GC.SuppressFinalize(this);
    }

    protected virtual void Dispose(bool disposing)
    {
        if (_disposed)
        {
            return;
        }

        if (disposing)
        {
            _stopwatch.Stop();
            _logger.LogDebug("{Msg}, Elapsed: {Timespan:g}", _message, _stopwatch.Elapsed);
        }

        _disposed = true;
    }
}