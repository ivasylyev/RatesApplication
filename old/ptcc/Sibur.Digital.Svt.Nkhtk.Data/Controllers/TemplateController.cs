using Microsoft.AspNetCore.Mvc;
using Sibur.Digital.Svt.Infrastructure.Filters;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.Data.Interfaces;

namespace Sibur.Digital.Svt.Nkhtk.Data.Controllers;

/// <summary>
/// Контроллер для работы с исходными шаблонами
/// </summary>
[ApiController]
[Route("api/v1/[controller]/[action]")]
[ServiceFilter(typeof(AuditFilter))]
[ServiceFilter(typeof(SvtExceptionFilterAttribute))]
public class TemplateController : ControllerBase
{
    private readonly ITemplateRepository _repository;

    public TemplateController(ITemplateRepository repository)
    {
        _repository = repository;
    }

    /// <summary>
    /// Возвращает список шаблонов
    /// </summary>
    /// <param name="templateTypeId">Идентификатор типа шаблона</param>
    /// <returns>Список шаблонов</returns>
    [HttpGet]
    public async Task<IEnumerable<TemplateDto>> Get(int templateTypeId)
        => await _repository.GetTemplatesAsync(templateTypeId)
            .ConfigureAwait(false);
}