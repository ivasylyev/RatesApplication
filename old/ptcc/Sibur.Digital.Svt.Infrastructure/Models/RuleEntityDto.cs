using Newtonsoft.Json;

namespace Sibur.Digital.Svt.Infrastructure.Models;

#pragma warning disable CS8618
/// <summary>
/// Коллекция сущностей (столбцов или ячеек) шаблона-источника НХТК
/// </summary>
public class RuleEntityDto
{
    public RuleEntityDto()
    {
    }

    public RuleEntityDto(IEnumerable<string> entityNames)
    {
        RuleEntityItems.AddRange(entityNames.Select(n => new RuleEntityItemDto { RuleEntityItemName = n }));
    }

    /// <summary>
    /// Уникальный идентификатор
    /// </summary>
    [JsonProperty("ruleEntityId")]
    public int? RuleEntityId { get; set; }

    /// <summary>
    /// Имя словаря
    /// </summary>
    [JsonProperty("ruleEntityName")]
    public string? RuleEntityName { get; set; }

    /// <summary>
    /// Русскоязычное описание  словаря
    /// </summary>
    [JsonProperty("ruleEntityDescription")]
    public string? RuleEntityDescription { get; set; }

    /// <summary>
    /// Имена сущностей (столбца или ячейки) шаблона-источника
    /// </summary>
    [JsonProperty("ruleEntityItems")]
    public List<RuleEntityItemDto> RuleEntityItems { get; set; } = new();

    public string[] GetItemNames()
        => RuleEntityItems.Select(i => i.RuleEntityItemName).ToArray();

    public override string ToString()
        => $"{RuleEntityId}: {RuleEntityName} Items: {RuleEntityItems.Count} ({RuleEntityDescription})";
}