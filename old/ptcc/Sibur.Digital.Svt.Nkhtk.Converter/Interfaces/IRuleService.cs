using Sibur.Digital.Svt.Infrastructure.Models;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;

/// <summary>
/// Сервис, получающий правила конвертации из исходного шаблона в СВТ
/// </summary>
public interface IRuleService
{
    /// <summary>
    /// Возвращает список бизнес-правил конвертации данной вкладки данного исходного шаблона в шаблон СВТ
    /// </summary>
    /// <param name="worksheetId">Идетнификатор вкладки (страницы) excel иисходного шаблона</param>
    /// <returns></returns>
    Task<List<RuleDto>> GetRulesAsync(int worksheetId);
}