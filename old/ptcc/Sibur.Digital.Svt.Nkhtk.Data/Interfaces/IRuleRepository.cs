using Sibur.Digital.Svt.Infrastructure.Models;

namespace Sibur.Digital.Svt.Nkhtk.Data.Interfaces;

/// <summary>
/// Репозиторий бизнес-правил для преобразования исходных шаблонов в СВТ
/// </summary>
public interface IRuleRepository
{
    /// <summary>
    /// Возвращает список бизнес-правил конвертации данной вкладки данного исходного шаблона в шаблон СВТ
    /// </summary>
    /// <param name="worksheetId">Идетнификатор вкладки (страницы) excel иисходного шаблона</param>
    /// <returns>Список бизнес-правил</returns>
    public Task<List<RuleDto>> GetRulesAsync(int worksheetId);
}