namespace Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;

/// <summary>
/// Провайдер данных использщующий API сервиса данных
/// </summary>
public interface IApiDataProvider
{
    /// <summary>
    /// Выполняет асинхронный GET запрос к API сервиса данных
    /// </summary>
    /// <typeparam name="T">Тип результата запроса</typeparam>
    /// <param name="apiControllerAction">Имя, или путь к действию определенного контроллера</param>
    /// <param name="parameters">Параметры GET запроса</param>
    /// <returns></returns>
    public Task<T> GetAsync<T>(string apiControllerAction, IDictionary<string, string>? parameters = null);
}