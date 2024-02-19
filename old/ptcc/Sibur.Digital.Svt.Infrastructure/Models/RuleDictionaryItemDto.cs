using Newtonsoft.Json;

namespace Sibur.Digital.Svt.Infrastructure.Models;

#pragma warning disable CS8618
/// <summary>
/// Элемент словаря соответсвия между значениями источника и назначения (в данной реализации -  НХТК и СВТ)
/// </summary>
public class RuleDictionaryItemDto
{
    /// <summary>
    /// Создает элемент словаря соответсвия между значениями источника и назначения (в данной реализации -  НХТК и СВТ)
    /// </summary>
    /// <param name="sourceValue">Значение источника</param>
    /// <param name="destinationValue">Значение назначения (СВТ)</param>
    public RuleDictionaryItemDto(string sourceValue, string destinationValue)
    {
        SourceValue = sourceValue;
        DestinationValue = destinationValue;
    }

    /// <summary>
    /// Создает элемент словаря соответсвия между значениями источника и назначения (в данной реализации -  НХТК и СВТ)
    /// Значение источника остается пустое, то есть, значение назначения - константа, не зависящая от значений источника
    /// </summary>
    /// <param name="destinationValue">Значение СВТ</param>
    public RuleDictionaryItemDto(string destinationValue)
    {
        DestinationValue = destinationValue;
    }

    /// <summary>
    /// Создает элемент словаря соответсвия между значениями источника и назначения (в данной реализации -  НХТК и СВТ)
    /// Конструктор по умолчанию для десериализации из JSON
    /// </summary>
    [JsonConstructor]
    private RuleDictionaryItemDto()
    {
    }

    /// <summary>
    /// Уникальный идентификатор элемента
    /// </summary>
    [JsonProperty("ruleDictionaryItemId", Required = Required.Always)]
    public int RuleDictionaryItemId { get; set; }

    /// <summary>
    /// Значение в системе назначени (СВТ)
    /// </summary>
    [JsonProperty("destinationValue", Required = Required.Always)]
    public string DestinationValue { get; set; }

    /// <summary>
    /// Значение в системе источника.
    /// Если оно пустое, значит, значение берется не из системы источника,
    /// а либо от пользователя (дата начала или окончания), либо значение является константой (Валюта)
    /// </summary>
    [JsonProperty("sourceValue")]
    public string? SourceValue { get; set; }

    public override string ToString()
        => $"{SourceValue ?? "[NULL]"} => {DestinationValue}";
}