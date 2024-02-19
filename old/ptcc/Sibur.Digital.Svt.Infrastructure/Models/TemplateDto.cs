using Newtonsoft.Json;

namespace Sibur.Digital.Svt.Infrastructure.Models;

#pragma warning disable CS8618
/// <summary>
/// Исходный шаблон excel файла с данными ставок
/// </summary>
public class TemplateDto
{
    /// <summary>
    /// Уникальный идентификатор шаблона
    /// </summary>
    [JsonProperty("templateId", Required = Required.Always)]
    public int TemplateId { get; set; }

    /// <summary>
    /// Имя шаблона на английском языке
    /// </summary>
    [JsonProperty("templateEnglishName", Required = Required.Always)]
    public string TemplateEnglishName { get; set; }

    /// <summary>
    /// Имя шаблона на русском языке
    /// </summary>
    [JsonProperty("templateRussianName", Required = Required.Always)]
    public string TemplateRussianName { get; set; }

    /// <summary>
    /// Вкладки шаблона excel
    /// </summary>
    [JsonProperty("worksheets", Required = Required.Always)]
    public List<WorksheetDto> Worksheets { get; set; } = new();
}