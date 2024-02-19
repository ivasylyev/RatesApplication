using Microsoft.AspNetCore.Mvc;
using Sibur.Digital.Svt.Infrastructure.Filters;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;
using Sibur.Digital.Svt.Nkhtk.Converter.Model;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Controllers;

/// <summary>
/// Контроллер для осуществления конвертации из исходного шаблона в шаблон назначения (СВТ)
/// </summary>
[Route("api/v1/[controller]/[action]")]
[ApiController]
[ServiceFilter(typeof(AuditFilter))]
[ServiceFilter(typeof(SvtExceptionFilterAttribute))]
public class ConverterController : ControllerBase
{
    private const string ContentType = "application/octet-stream";
    private readonly IConverterService _converterService;
    private readonly ILogger<ConverterController> _logger;
    private readonly IWorksheetService _worksheetService;

    public ConverterController(IConverterService converterService, IWorksheetService worksheetService, ILogger<ConverterController> logger)
    {
        _converterService = converterService ?? throw new ArgumentNullException(nameof(converterService));
        _worksheetService = worksheetService ?? throw new ArgumentNullException(nameof(worksheetService));
        _logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }


    /// <summary>
    /// Возвращает список вкладок excel файла
    /// </summary>
    /// <param name="file">excel файл исходного шаблона</param>
    /// <returns>Список вкладок</returns>
    [HttpPost]
    public IEnumerable<string> GetWorksheetNames([FromForm] IFormFile file)
        => _converterService.GetWorksheetNames(file);

    /// <summary>
    /// Конвертирует данные из исходного шаблона в шаблон назначения (СВТ)
    /// </summary>
    /// <param name="parameters">Параметры шаблона</param>
    /// <param name="file">excel файл исходного шаблона</param>
    /// <returns>Возвращает excel-файл шаблона СВТ. В случае ошибки возвращает <see cref="ObjectResult" /> с исключением</returns>
    [HttpPost]
    public async Task<IActionResult> ConvertFile([FromQuery] TemplateParameters parameters, [FromForm] IFormFile file)
    {
        try
        {
            parameters = await FillMissingData(parameters);

            var stream = await _converterService.ConvertFileAsync(parameters, file.OpenReadStream());

            var downloadName = $"СТВ_{parameters.TemplateWorksheetId}_{parameters.TemplateWorksheetName}.xlsx";
            return File(stream, ContentType, downloadName); // returns a FileStreamResult
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Cannot convert file");
            return Problem(ex.Message);
        }
    }

    private async Task<TemplateParameters> FillMissingData(TemplateParameters parameters)
    {
        var worksheetDto = await _worksheetService.GetWorksheetAsync(parameters.TemplateWorksheetId);
        parameters.TemplateWorksheetName = worksheetDto.WorksheetName;
        parameters.TemplateId = worksheetDto.TemplateId;
        parameters.TemplateTypeId = worksheetDto.TemplateTypeId;

        return parameters;
    }
}