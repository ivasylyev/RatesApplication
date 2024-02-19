#pragma warning disable CS8618
namespace Sibur.Digital.Svt.Nkhtk.Converter.Config;

public class ApiOptions
{
    /// <summary>
    /// Название секции в конфиге
    /// </summary>
    public const string Api = "Api";

    /// <summary>
    /// Базовый URL для API подключаемого сервиса
    /// </summary>
    public string BaseUrl { get; set; }

    /// <summary>
    /// Имя Action проверки здоровья подключаемого сервиса
    /// </summary>
    public string GetHealthCheckAction { get; set; }

    /// <summary>
    /// Имя Action получения описания исходных шаблонов
    /// </summary>
    public string GetTemplatesAction { get; set; }

    /// <summary>
    /// Имя Action получения описания страниц (вкладок) исходных шаблонов
    /// </summary>
    public string GetWorksheetAction { get; set; }

    /// <summary>
    /// Имя Action получения правил для страницы шаблона
    /// </summary>
    public string GetRulesAction { get; set; }
}