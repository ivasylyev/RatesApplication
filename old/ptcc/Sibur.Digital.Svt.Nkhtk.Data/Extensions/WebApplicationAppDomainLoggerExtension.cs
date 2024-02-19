using Sibur.Digital.Svt.Infrastructure.Utils;

namespace Sibur.Digital.Svt.Nkhtk.Data.Extensions;

/// <summary>
/// Расширение для Логгера загружаемых в домен сборок
/// </summary>
public static class WebApplicationAppDomainLoggerExtension
{
    /// <summary>
    /// Запуск логирования загруженных в app domain библиотек
    /// </summary>
    /// <param name="app"></param>
    /// <exception cref="ArgumentNullException"></exception>
    public static void StartAppDomainLogger(this WebApplication app)
    {
        app.ThrowIfNull(nameof(app));
        
        if (app.Services.GetService(typeof(AppDomainAssemblyLogger)) is AppDomainAssemblyLogger domainLogger)
        {
            domainLogger.StartLog();
        }
    }
}