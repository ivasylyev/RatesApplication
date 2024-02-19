using Newtonsoft.Json;

namespace Sibur.Digital.Svt.Infrastructure.Models;

#pragma warning disable CS8618
/// <summary>
/// Словарь соответсвия между значениями источника и назначения (в данной реализации -  НХТК и СВТ)
/// </summary>
public class RuleDictionaryDto
{
    public RuleDictionaryDto()
    {
    }

    public RuleDictionaryDto(IEnumerable<RuleDictionaryItemDto> items)
    {
        RuleDictionaryItems = new List<RuleDictionaryItemDto>(items);
    }

    /// <summary>
    /// Уникальный идентификатор
    /// </summary>
    [JsonProperty("ruleDictionaryId")]
    public int? RuleDictionaryId { get; set; }

    /// <summary>
    /// Имя словаря
    /// </summary>
    [JsonProperty("ruleDictionaryName")]
    public string? RuleDictionaryName { get; set; }

    /// <summary>
    /// Русскоязычное описание  словаря
    /// </summary>
    [JsonProperty("ruleDictionaryDescription")]
    public string? RuleDictionaryDescription { get; set; }

    /// <summary>
    /// Элементы словаря соответсвия между значениями исходного шаблона и шаблона назначения, принадлежащие данному правилу
    /// </summary>
    [JsonProperty("ruleDictionaryItems")]
    public List<RuleDictionaryItemDto> RuleDictionaryItems { get; set; } = new();


    public override string ToString()
        => $"{RuleDictionaryId}: {RuleDictionaryName} Items: {RuleDictionaryItems.Count} ({RuleDictionaryDescription})";
}