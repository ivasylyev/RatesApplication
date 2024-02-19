using System.Data;

namespace Sibur.Digital.Svt.Nkhtk.Data.Interfaces;

/// <summary>
/// Провайдер данных для работы с БД
/// </summary>
public interface IDataProvider
{
    /// <summary>
    /// Возвращает подключение к БД
    /// </summary>
    /// <returns></returns>
    public IDbConnection CreateConnection();
}