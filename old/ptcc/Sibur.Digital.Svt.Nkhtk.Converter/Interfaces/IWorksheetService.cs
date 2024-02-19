using Sibur.Digital.Svt.Infrastructure.Models;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;

/// <summary>
/// Сервис для работы со страницами шаблона
/// </summary>
public interface IWorksheetService
{
    /// <summary>
    /// Возвращает страницу (закладку) шаблона
    /// </summary>
    /// <param name="worksheetId">Идентификатор шаблона</param>
    /// <returns>Страница шаблона</returns>
    Task<WorksheetDto> GetWorksheetAsync(int worksheetId);
}