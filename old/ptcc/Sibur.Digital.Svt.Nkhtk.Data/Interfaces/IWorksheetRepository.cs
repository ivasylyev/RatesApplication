using Sibur.Digital.Svt.Infrastructure.Models;

namespace Sibur.Digital.Svt.Nkhtk.Data.Interfaces;

/// <summary>
/// Репозиторий страниц исходных шаблонов
/// </summary>
public interface IWorksheetRepository
{
    /// <summary>
    /// Возвращает описание страницы (вкладки) excel по идентификатору
    /// </summary>
    /// <param name="worksheetId">Идентификатор страницы (вкладки) excel</param>
    /// <returns>Описание страницы (вкладки) excel </returns>
    Task<WorksheetDto> GetWorksheetAsync(int worksheetId);
}