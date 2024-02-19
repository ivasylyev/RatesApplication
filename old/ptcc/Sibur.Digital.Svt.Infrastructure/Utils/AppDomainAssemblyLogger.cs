using System.Reflection;
using Microsoft.Extensions.Logging;

namespace Sibur.Digital.Svt.Infrastructure.Utils;

/// <summary>
/// Логгер загружаемых в домен сборок
/// </summary>
public class AppDomainAssemblyLogger
{
    private readonly ILogger<AppDomainAssemblyLogger> _logger;
    private bool _started;

    public AppDomainAssemblyLogger(ILogger<AppDomainAssemblyLogger> logger)
    {
        _logger = logger;
    }

    /// <summary>
    /// Выводит в лог сообщения о всех загруженных в домен сборках Сибура
    /// создает подписку на событие загрузки библиотеки в домен для последующего логирования факта загрузки
    /// </summary>
    public void StartLog()
    {
        if (!_started)
        {
            _started = true;
            var assemblies = AppDomain.CurrentDomain.GetAssemblies();
            foreach (var assembly in assemblies)
            {
                LogAssembly(assembly);
            }

            AppDomain.CurrentDomain.AssemblyLoad += CurrentDomain_AssemblyLoad;
        }
    }

    /// <summary>
    /// Обработчик события загрузки сборки в домен.
    /// Выводит в лог сообщение о загружаемой сборке
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="args"></param>
    private void CurrentDomain_AssemblyLoad(object? sender, AssemblyLoadEventArgs args)
    {
        if (sender is Assembly assembly)
        {
            LogAssembly(assembly);
        }
    }

    /// <summary>
    /// Выводит в лог сообщение о загружаемой сборке, если она является сборкой Сибура
    /// </summary>
    /// <param name="assembly"></param>
    private void LogAssembly(Assembly assembly)
    {
        if (assembly.FullName != null && assembly.FullName.Contains("Sibur", StringComparison.InvariantCultureIgnoreCase))
        {
            _logger.LogInformation("Loaded assembly: {Asm}", assembly.FullName);
        }
    }
}