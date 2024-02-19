using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace Sibur.Digital.Svt.Infrastructure.Models;

#pragma warning disable CS8618
/// <summary>
/// Правило преобразования исходного шаблона excel файла с данными (в текущей реализации шаблона НХТК)
/// </summary>
public class RuleDto
{
    /// <summary>
    /// Уникальный идентификатор правила
    /// </summary>
    [JsonProperty("ruleId", Required = Required.Always)]
    public int RuleId { get; set; }

    /// <summary>
    /// Номер строки в матрице соответсвия,  реализуемую правилом правила
    /// </summary>
    [JsonProperty("matrixId")]
    public int MatrixId { get; set; }

    /// <summary>
    /// Идентификатор вкладки, к которой принадлежит правило
    /// </summary>
    [JsonProperty("worksheetId", Required = Required.Always)]
    public int WorksheetId { get; set; }

    /// <summary>
    /// Категория правила: применяется ли правило к excel файлу, листу, колонке, ячейке и т.д.
    /// </summary>
    [JsonProperty("ruleKind", Required = Required.Always)]
    [JsonConverter(typeof(StringEnumConverter))]
    public RuleKind RuleKind { get; set; }

    /// <summary>
    /// Тип данных, обрабатываемый правилом.
    /// </summary>
    [JsonProperty("ruleDataType", Required = Required.Always)]
    [JsonConverter(typeof(StringEnumConverter))]
    public RuleType RuleDataType { get; set; }

    /// <summary>
    /// Бинарный оператор для правила.
    /// Первый операнд - значение, хранящееся в шаблоне назначения (в данной реализанции - СВТ)
    /// в колонке <see cref="DestinationColumn" /> как результат выполнения предыдущего правила.
    /// Второй операнд - результат данного правила. Применяется только к числовым значениям
    /// </summary>
    [JsonProperty("ruleOperator", Required = Required.Always)]
    [JsonConverter(typeof(StringEnumConverter))]
    public RuleOperator RuleOperator { get; set; }

    /// <summary>
    /// Является ли правило обязательным.
    /// </summary>
    [JsonProperty("mandatory", Required = Required.Always)]
    public bool Mandatory { get; set; }

    /// <summary>
    /// Англоязычное человеко-читаемое уникальное имя,
    /// соответсвующее столбцу в шаблоне назначения (в данной реализации - СВТ)
    /// </summary>
    [JsonProperty("destinationColumn", Required = Required.Always)]
    public string DestinationColumn { get; set; }

    /// <summary>
    /// Русскоязычное описание  правила
    /// </summary>
    [JsonProperty("description")]
    public string Description { get; set; }

    /// <summary>
    /// Идентификаторы листов шаблона-источника, для которых используется правило
    /// </summary>
    [JsonProperty("sourceWorksheets")]
    public List<int> SourceWorksheets { get; set; }

    /// <summary>
    /// Имена сущностей (столбца или ячейки) шаблона-источника
    /// </summary>
    [JsonProperty("sourceEntity")]
    public RuleEntityDto SourceEntity { get; set; } = new();

    /// <summary>
    /// В случае установки этого флага отсутсвие значения в словаре для правила считается ошибкой
    /// </summary>
    [JsonProperty("treatMissingDictionaryValueAsError")]
    public bool TreatMissingDictionaryValueAsError { get; set; }

    /// <summary>
    /// Словарь соответсвия между значениями исходного шаблона и шаблона назначения, принадлежащие данному правилу
    /// </summary>
    [JsonProperty("dictionary")]
    public RuleDictionaryDto Dictionary { get; set; } = new();

    /// <summary>
    /// Порядок, в котором правило будет выполняться
    /// </summary>
    [JsonProperty("order", Required = Required.Always)]
    public int Order { get; set; }

    public override string ToString()
        => $"({RuleId}) Destination: '{DestinationColumn}' Description: '{Description}'";
}