using Newtonsoft.Json;

namespace Sibur.Digital.Svt.Infrastructure.Models;

/// <summary>
/// Элемент шаблона-источника (заголовок хранящийся в определенной ячейке)
/// </summary>
public class RuleEntityItemDto
{
    /// <summary>
    /// Уникальный идентификатор элемента
    /// </summary>
    [JsonProperty("ruleEntityItemId", Required = Required.Always)]
    public int RuleEntityItemId { get; set; }

    /// <summary>
    /// Имя элемента
    /// </summary>
    [JsonProperty("ruleEntityItemName", Required = Required.Always)]
    public string RuleEntityItemName { get; set; } = string.Empty;

    public override string ToString()
        => $"({RuleEntityItemId}) {RuleEntityItemName}";
}