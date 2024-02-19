using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Infrastructure.Utils;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;
using Sibur.Digital.Svt.Nkhtk.Converter.Model;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Transformers;

/// <summary>
/// Преобразователь колонки исходного шаблона в колонку шаблона СВТ, действующий на основании бизнес-правла
/// </summary>
public sealed class SourceColumnCopyDictionaryOnlyTransformer : ColumnCopyTransformer
{
    public SourceColumnCopyDictionaryOnlyTransformer(RuleDto rule, ILogger logger) : base(rule, logger)
    {
        if (rule.RuleKind != RuleKind.SourceColumnCopyDictionaryOnly)
        {
            throw new ArgumentException($"{nameof(rule)}.{nameof(rule.RuleKind)} is not {RuleKind.SourceColumnCopyDictionaryOnly}");
        }
    }

    /// <inheritdoc />
    public override ColumnValues GetInitialValues(IExcelDecorator source, IExcelDecorator target)
    {
        source.ThrowIfNull(nameof(source));
        return source.GetColumnValues(Rule.SourceEntity.GetItemNames());
    }

    /// <summary>
    /// Маппинг между значениями исходного шаблона и СВТ.
    /// В случае наличия значения в словаре возвращается значение из словаря по данному ключу,
    /// в случае отсутствия - пустое значение
    /// </summary>
    /// <param name="source">Значение исходного шаблона</param>
    /// <param name="treatMissingValueAsError">Флаг, трактовать ли отсутсвие значения в словаре, как ошибку для данного типа правила игнорируется</param>
    /// <returns>значение для шаблона СВТ</returns>
    protected override ColumnValue MapInitialValue(ColumnValue source, bool treatMissingValueAsError)
    {
        var key = source.ValueToString();
        return key != null && Dictionary.TryGetValue(key, out var value)
            ? new ColumnValue(value)
            : new ColumnValue();
    }
}