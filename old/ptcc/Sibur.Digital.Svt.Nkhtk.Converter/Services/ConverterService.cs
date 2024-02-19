using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;
using Sibur.Digital.Svt.Nkhtk.Converter.Model;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Services;

public class ConverterService : IConverterService
{
    private readonly ILogger<IConverterService> _logger;
    private readonly IRuleService _ruleService;
    private readonly IExcelDecorator _sourceExcel;
    private readonly ISvtTemplateService _svtTemplateService;
    private readonly IExcelDecorator _targetExcel;
    private readonly ITransformerService _transformerService;

    public ConverterService(IExcelDecorator sourceExcel,
        IExcelDecorator targetExcel,
        ISvtTemplateService svtTemplateService,
        ITransformerService transformerService,
        IRuleService ruleService,
        ILogger<IConverterService> logger)
    {
        _sourceExcel = sourceExcel ?? throw new ArgumentNullException(nameof(sourceExcel));
        _targetExcel = targetExcel ?? throw new ArgumentNullException(nameof(targetExcel));

        _svtTemplateService = svtTemplateService ?? throw new ArgumentNullException(nameof(svtTemplateService));
        _transformerService = transformerService ?? throw new ArgumentNullException(nameof(transformerService));
        _ruleService = ruleService ?? throw new ArgumentNullException(nameof(ruleService));
        _logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }

    /// <inheritdoc />
    public List<string> GetWorksheetNames(IFormFile file)
    {
        using var sourceStream = file.OpenReadStream();
        _logger.LogInformation("Загружаем эксель с шаблоном");
        _sourceExcel.LoadSimple(sourceStream);

        _logger.LogInformation("Получаем список вкладок");
        var names = _sourceExcel.GetWorksheetNames();

        _logger.LogInformation("Cписок вкладок: {names}", string.Join(",", names));
        return names;
    }

    /// <inheritdoc />
    public async Task<Stream> ConvertFileAsync(TemplateParameters parameters, Stream sourceStream)
    {
        _logger.LogInformation("Получаем список правил для шаблона ({tId}) и вкладки шаблона ({wsId}) '{wsName}' для конвертации вкладки файла c с номером '{exId}'",
            parameters.TemplateId, parameters.TemplateWorksheetId, parameters.TemplateWorksheetName, parameters.ExcelWorksheetIndex);
        var rules = await _ruleService.GetRulesAsync(parameters.TemplateWorksheetId);
        _logger.LogInformation("Получен список из {cnt} правил для вкладки ({wsId})'{wsName}': {rules}",
            rules.Count, parameters.TemplateWorksheetId, parameters.TemplateWorksheetName, string.Join(", ", rules.Select(r => r.RuleId)));

        _logger.LogInformation("Загружаем вкладку с номером {exId} исходного эксель файла для конвертации по шаблону {tId} по правилам вкладки {wsId}",
            parameters.ExcelWorksheetIndex, parameters.TemplateId, parameters.TemplateWorksheetId);

        //устанавливаем активной страницу с данным именем
        //устанавливаем имя колонки из первого правила для понимания, где в экселе находятся заголовки
        var firstRule = rules.FirstOrDefault(r => r.Mandatory && r.RuleKind != RuleKind.SourceSheetDeleteRows && r.SourceEntity.RuleEntityItems.Any());
        if (firstRule is null)
        {
            throw new InvalidOperationException(
                $"Для вкладки ({parameters.TemplateWorksheetId}) {parameters.TemplateWorksheetName} Отсутствуют правила с маппингом сущностей из исходного шаблона.");
        }

        _sourceExcel.Load(sourceStream, parameters.ExcelWorksheetIndex, firstRule.SourceEntity.GetItemNames());

        _logger.LogInformation("Загружаем вкладку с номером {worksheetIndex} из эксель файла с шаблоном СВТ", _svtTemplateService.ExcelWorksheetIndex);
        var targetStream = _svtTemplateService.GetTemplateFileStream((TemplateType)parameters.TemplateTypeId);
        _targetExcel.Load(targetStream, _svtTemplateService.ExcelWorksheetIndex, _svtTemplateService.FirstColumnName);

        _logger.LogInformation("Создаем преобразователи для списка из {cnt} правил для конвертации по шаблону {tId} с вкладкой {wsId}",
            rules.Count, parameters.TemplateId, parameters.TemplateWorksheetId);
        var transformers = _transformerService.GetTransformers(parameters, rules);

        _logger.LogInformation("Заполняем шаблон СВТ по правилам исходного шаблона {tId} с вкладкой {wsId}",
            parameters.TemplateId, parameters.TemplateWorksheetId);

        foreach (var transformer in transformers)
        {
            transformer.Apply(_sourceExcel, _targetExcel);
        }

        _logger.LogInformation("Cохраняем в поток заполненный шаблон СВТ по правилам исходного шаблона {tId} с вкладкой {wsId}",
            parameters.TemplateId, parameters.TemplateWorksheetId);
        var resultStream = _targetExcel.Save();
        return resultStream;
    }
}