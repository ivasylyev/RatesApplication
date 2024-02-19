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
public class WorksheetController : ControllerBase
{
    private readonly IWorksheetRepository _repository;

    public WorksheetController(IWorksheetRepository repository)
    {
        _repository = repository;
    }


    /// <summary>
    /// Возвращает описание страницы (вкладки) excel по идентификатору
    /// </summary>
    /// <param name="worksheetId">Идентификатор страницы (вкладки) excel</param>
    /// <returns>Описание страницы (вкладки) excel </returns>
    [HttpGet]
    public async Task<WorksheetDto> Get(int worksheetId)
        => await _repository.GetWorksheetAsync(worksheetId)
            .ConfigureAwait(false);
}