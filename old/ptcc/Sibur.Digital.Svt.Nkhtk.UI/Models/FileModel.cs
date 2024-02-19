using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Components.Forms;
using Microsoft.Extensions.Options;
using Microsoft.JSInterop;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Infrastructure.Utils;
using Sibur.Digital.Svt.Nkhtk.UI.Config;
using Sibur.Digital.Svt.Nkhtk.UI.Services;

namespace Sibur.Digital.Svt.Nkhtk.UI.Models;

public abstract class FileModel
{
    protected const string DateFormat = "yyyy-MM-dd";

    private static readonly SvtSelectListItem ItemLoading = new(0, "Загрузка...");
    private static readonly SvtSelectListItem ItemNotLoaded = new(0, "Список не загружен");
    private DateTime? _endDate;
    private int _excelWorksheetIndex;
    private DateTime? _startDate;
    private int _templateId;
    private int _templateWorksheetId;

    protected FileModel(IOptions<UiOptions> options,
        ConverterService converterService, TemplateService templateService, WorksheetService worksheetService,
        ILogger<FileModel> logger)
    {
        Options = options ?? throw new ArgumentNullException(nameof(options));
        ConverterService = converterService ?? throw new ArgumentNullException(nameof(converterService));
        TemplateService = templateService ?? throw new ArgumentNullException(nameof(templateService));
        WorksheetService = worksheetService ?? throw new ArgumentNullException(nameof(worksheetService));
        Logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }


    /// <summary>
    /// Идентификатор шаблона-источника, к которому принадлежит вкладка
    /// </summary>
    [Required]
    [Range(1, int.MaxValue)]
    public int TemplateId
    {
        set
        {
            _templateId = value;
            ClearInfoAndError();
            LoadWorksheets();
        }
        get => _templateId;
    }

    /// <summary>
    /// Идентификатор вкладки (страницы) исходного шаблона
    /// </summary>
    [Required]
    [Range(1, int.MaxValue)]
    public int TemplateWorksheetId
    {
        get => _templateWorksheetId;
        set
        {
            _templateWorksheetId = value;
            ClearInfoAndError();
        }
    }

    /// <summary>
    /// Порядковый номер (индекс) конвертируемой страницы загруженого excel файла
    /// </summary>
    [Required]
    [Range(1, int.MaxValue)]
    public int ExcelWorksheetIndex
    {
        get => _excelWorksheetIndex;
        set
        {
            _excelWorksheetIndex = value;
            ClearInfoAndError();
        }
    }


    /// <summary>
    /// Дата начала действия ставки
    /// </summary>
    [Required]
    public DateTime? StartDate
    {
        get => _startDate;
        set
        {
            _startDate = value;
            ClearInfoAndError();
        }
    }

    /// <summary>
    /// Дата окончания действия ставки
    /// </summary>
    [Required]
    public DateTime? EndDate
    {
        get => _endDate;
        set
        {
            _endDate = value;
            ClearInfoAndError();
        }
    }

    [Required]
    public StreamModel? ExcelStream { get; set; }

    public int MaxFileSize
        => 1024 * 1024 * Options.Value.MaxFileSizeMb;

    public bool Loading { get; set; }

    public bool Submitted { get; set; }
    public InfoModel? Info { get; private set; }

    private List<TemplateDto> Templates { get; set; } = new();
    public List<SvtSelectListItem> TemplateItems { get; private set; } = new() { ItemLoading };

    public List<SvtSelectListItem> TemplateWorksheetItems { get; } = new();
    public List<SvtSelectListItem> ExcelWorksheetNames { get; private set; } = new() { ItemNotLoaded };

    protected ILogger<FileModel> Logger { get; set; }

    protected TemplateService TemplateService { get; set; }

    protected WorksheetService WorksheetService { get; set; }

    protected ConverterService ConverterService { get; set; }

    protected IOptions<UiOptions> Options { get; set; }

    public bool FileExceededMaxSize(long size)
        => size >= MaxFileSize;

    public void SetInfo(string text)
        => Info = new InfoModel(text);

    public void SetError(string text)
        => Info = new InfoModel(text, InfoType.Error);

    public void ClearInfoAndError()
        => Info = null;

    public virtual string GetUrlParameters()
    {
        if (!StartDate.HasValue)
        {
            throw new InvalidOperationException($"{nameof(StartDate)} is not set");
        }

        if (!EndDate.HasValue)
        {
            throw new InvalidOperationException($"{nameof(EndDate)} is not set");
        }

        return
            $"templateWorksheetId={TemplateWorksheetId}&excelWorksheetIndex={ExcelWorksheetIndex}&startDate={StartDate.Value.ToString(DateFormat)}&endDate={EndDate.Value.ToString(DateFormat)}";
    }


    /// <summary>
    /// Очистка сохраненного в модели excel файла
    /// </summary>
    /// <returns></returns>
    public void ClearFileAsync()
    {
        ExcelStream = null;
        ExcelWorksheetNames = new List<SvtSelectListItem> { ItemNotLoaded };
        ExcelWorksheetIndex = 0;
    }

    /// <summary>
    /// Загрузка excel файла, загрузка его вкладок, сохранение файла в модели
    /// </summary>
    /// <param name="file">Загружаемый файл</param>
    /// <returns></returns>
    public async Task LoadFileAsync(IBrowserFile file)
    {
        try
        {
            Loading = true;
            file.ThrowIfNull(nameof(file));

            // нельзя хранить IBrowserFile, он может "проткхнуть" со временем. Лучше скопировать его в MemoryStream
            // так как пользователйей у конвертера - единицы, эт оне сильно нагрузит сервер.
            ExcelStream = await StreamModel.GetStreamFromFileAsync(file, MaxFileSize);

            var names = await ConverterService.GetWorksheetNamesAsync(ExcelStream)
                .ConfigureAwait(false);

            ExcelWorksheetNames.Clear();
            for (var i = 0; i < names.Count; i++)
            {
                ExcelWorksheetNames.Add(new SvtSelectListItem(i + 1, names[i]));
            }

            ExcelWorksheetIndex = ExcelWorksheetNames.FirstOrDefault()?.Value ?? 0;
        }
        catch (Exception ex)
        {
            Logger.LogError(ex, "Cannot load worksheet names from excel file");

            ExcelWorksheetNames = new List<SvtSelectListItem> { new(0, $"Ошибка: {ex.Message}") };
            ExcelWorksheetIndex = 0;
            throw;
        }
        finally
        {
            Loading = false;
        }
    }

    /// <summary>
    /// Конвертиреут загруженный excel файл
    /// </summary>
    /// <returns></returns>
    /// <exception cref="InvalidOperationException"></exception>
    public async Task<Tuple<DotNetStreamReference, string>> ConvertFileAsync()
    {
        try
        {
            Loading = true;

            if (ExcelStream is null)
            {
                throw new InvalidOperationException($"{nameof(ExcelStream)} must not be null");
            }

            var fileStream = await ConverterService.DownloadConvertedTemplateAsync(ExcelStream, GetUrlParameters())
                .ConfigureAwait(false);

            var streamRef = new DotNetStreamReference(fileStream);

            var fileName = await WorksheetService.GetFileNameAsync(TemplateWorksheetId);
            return new Tuple<DotNetStreamReference, string>(streamRef, fileName);
        }
        finally
        {
            Loading = false;
        }
    }

    /// <summary>
    /// Загружает шаблоны выбранного типа
    /// </summary>
    /// <param name="templateType">Тип шаблона (НХТК, ММ, Спецставки)</param>
    /// <returns></returns>
    public async Task LoadTemplates(TemplateType templateType)
    {
        try
        {
            Templates = await TemplateService.GetTemplatesAsync(templateType)
                .ConfigureAwait(false);

            TemplateItems = new List<SvtSelectListItem>(Templates.Select(t => new SvtSelectListItem(t.TemplateId, t.TemplateRussianName)));
        }
        catch (Exception ex)
        {
            Logger.LogError(ex, "Cannot load templates");
            TemplateItems = new List<SvtSelectListItem> { new(0, $"Ошибка: {ex.Message}") };
        }

        TemplateId = TemplateItems.FirstOrDefault()?.Value ?? 0;
    }

    private void LoadWorksheets()
    {
        try
        {
            TemplateWorksheetItems.Clear();
            TemplateDto? template = null;
            if (TemplateId > 0 && Templates.Any())
            {
                template = Templates.Find(t => t.TemplateId == TemplateId);
            }

            template ??= Templates.FirstOrDefault();
            if (template != null && template.Worksheets.Any())
            {
                TemplateWorksheetItems.AddRange(template.Worksheets
                    .Select(w => new SvtSelectListItem(w.WorksheetId, $"{template.TemplateRussianName}: {w.WorksheetName}")));
            }
        }
        catch (Exception ex)
        {
            Logger.LogError(ex, "Cannot load worksheets");
            TemplateItems = new List<SvtSelectListItem> { new(0, ex.Message) };
        }

        TemplateWorksheetId = TemplateWorksheetItems.FirstOrDefault()?.Value ?? 0;
    }
}