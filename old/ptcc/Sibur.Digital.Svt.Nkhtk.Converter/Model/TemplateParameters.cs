namespace Sibur.Digital.Svt.Nkhtk.Converter.Model;

/// <summary>
/// Параметры исходного шаблона
/// </summary>
public class TemplateParameters
{
    /// <summary>
    /// Идентификатор вкладки (страницы) excel исходного шаблона
    /// </summary>
    public int TemplateWorksheetId { get; set; }

    /// <summary>
    /// Порядковый номер (индекс) конвертируемой страницы загруженого excel файла
    /// </summary>
    public int ExcelWorksheetIndex { set; get; }

    /// <summary>
    /// Имя выбранной вкладки (страницы) excel исходного шаблона
    /// </summary>
    public string? TemplateWorksheetName { get; set; }

    /// <summary>
    /// Идентификатор шаблона-источника, к которому принадлежит вкладка
    /// </summary>
    public int TemplateId { get; set; }

    /// <summary>
    /// Идентификатор типа шаблона-источника, к которому принадлежит вкладка
    /// </summary>
    public int TemplateTypeId { get; set; }

    /// <summary>
    /// Дата начала действия ставки
    /// </summary>
    public DateTime StartDate { get; set; }

    /// <summary>
    /// Дата окончания действия ставки
    /// </summary>
    public DateTime EndDate { get; set; }

    /// <summary>
    /// Текущая дата
    /// </summary>
    public DateTime CurrencyRateMonth { get; set; }

    /// <summary>
    /// Текущая дата
    /// </summary>
    public DateTime CurrencyDate { get; set; }
    
    /// <summary>
    /// Эффективная загрузка
    /// </summary>
    public decimal? EffectiveLoadOfTransportType { get; set; }

    /// <summary>
    /// Эффективная загрузка первого плеча
    /// </summary>
    public decimal? Leg1_EffectiveLoad { get; set; }

    /// <summary>
    /// Эффективная загрузка второго плеча
    /// </summary>
    public decimal? Leg2_EffectiveLoad { get; set; }

    /// <summary>
    /// Группа продуктов
    /// </summary>
    public string? ProductGroup { get; set; }

    /// <summary>
    /// Общая валюта затрат
    /// </summary>
    public string? GeneralCurrency { get; set; }

    /// <summary>
    /// Общая валюта затрат первого плеча
    /// </summary>
    public string? Leg1_BaseCurrency { get; set; }

    /// <summary>
    /// Общая валюта затрат второго плеча
    /// </summary>
    public string? Leg2_BaseCurrency { get; set; }

    /// <summary>
    /// Валюта-эталон
    /// </summary>
    public string? CurrencyStandard { get; set; }

    /// <summary>
    /// Продукт
    /// </summary>
    public string? Product { get; set; }

    /// <summary>
    /// Базис поставки
    /// </summary>
    public string? Basis { get; set; }
}