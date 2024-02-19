using Microsoft.AspNetCore.Mvc;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.Data.Interfaces;

namespace Sibur.Digital.Svt.Nkhtk.Data.Controllers;

/// <summary>
/// Контроллер для преобразования шаблона excel файла с данными исходного шаблона в шаблон СВТ
/// </summary>
[Route("api/v1/[controller]/[action]")]
[ApiController]
public class RuleController : ControllerBase
{
    private readonly IRuleRepository _repository;

    public RuleController(IRuleRepository repository)
    {
        _repository = repository;
    }

    /// <summary>
    /// Возвращает бизнес-правила, применимые к конкретной вкладке шаблону
    /// </summary>
    /// <param name="worksheetId">Идетнификатор вкладки (страницы) excel иисходного шаблона</param>
    /// <returns>Список бизнес-правил</returns>
    [HttpGet]
    public async Task<List<RuleDto>> GetByWorksheet(int worksheetId)
        => await _repository.GetRulesAsync(worksheetId)
            .ConfigureAwait(false);
}