namespace Sibur.Digital.Svt.Infrastructure.Models;

/// <summary>
/// Дополнительные служебные поля для правила преобразования исходного шаблона excel файла с данными (в текущей реализации шаблона НХТК)
/// </summary>
public class RuleExtensionDto
{
    /// <summary>
    /// Уникальный идентификатор правила
    /// </summary>
    public int RuleId { get; set; }
    /// <summary>
    /// Уникальный идентификатор сущности (столбец или ячейка) исходного шаблона
    /// </summary>
    public int? RuleEntityId { get; set; }

    /// <summary>
    /// Уникальный идентификатор сущности (столбец или ячейка) исходного шаблона
    /// </summary>
    public int? RuleDictionaryId { get; set; }
}