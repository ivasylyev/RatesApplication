using Sibur.Digital.Svt.Infrastructure.Models;

namespace Sibur.Digital.Svt.Nkhtk.Data.Interfaces;

/// <summary>
/// Репозиторий исходных шаблонов
/// </summary>
public interface ITemplateRepository
{
    /// <summary>
    /// Возвращает список исходных шаблонов
    /// </summary>
    /// <param name="templateTypeId">Идентификатор типа шаблона</param>
    /// <returns>список исходных шаблонов</returns>
    Task<IEnumerable<TemplateDto>> GetTemplatesAsync(int templateTypeId);
}