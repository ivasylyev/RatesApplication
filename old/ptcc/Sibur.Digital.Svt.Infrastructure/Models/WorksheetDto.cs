using Newtonsoft.Json;

namespace Sibur.Digital.Svt.Infrastructure.Models;

#pragma warning disable CS8618
/// <summary>
/// Вкладка excel файла исходного шаблона с данными ставок
/// </summary>
public class WorksheetDto
{
    /// <summary>
    /// Уникальный идентификатор вкладки
    /// </summary>
    [JsonProperty("worksheetId", Required = Required.Always)]
    public int WorksheetId { get; set; }

    /// <summary>
    /// Идентификатор шаблона-источника, к которому принадлежит вкладка
    /// </summary>
    [JsonProperty("templateId", Required = Required.Always)]
    public int TemplateId { get; set; }

    /// <summary>
    /// Идентификатор типа шаблона-источника, к которому принадлежит вкладка
    /// </summary>
    [JsonProperty("templateTypeId", Required = Required.Always)]
    public int TemplateTypeId { get; set; }

    /// <summary>
    /// Имя шаблона-источника, к которому принадлежит вкладка на английском языке
    /// </summary>
    [JsonProperty("templateEnglishName", Required = Required.Always)]
    public string TemplateEnglishName { get; set; }

    /// <summary>
    /// Имя шаблона-источника, к которому принадлежит вкладка на русском языке
    /// </summary>
    [JsonProperty("templateRussianName", Required = Required.Always)]
    public string TemplateRussianName { get; set; }

    /// <summary>
    /// Имя вкладки шаблона
    /// </summary>
    [JsonProperty("worksheetName", Required = Required.Always)]
    public string WorksheetName { get; set; }
}