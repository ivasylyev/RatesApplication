using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Infrastructure.Utils;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;
using Sibur.Digital.Svt.Nkhtk.Converter.Model;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Transformers;

/// <summary>
/// Преобразователь колонки исходного шаблона в колонку шаблона СВТ, действующий на основании бизнес-правла
/// </summary>
public sealed class SourceColumnCopyTransformer : ColumnCopyTransformer
{
    public SourceColumnCopyTransformer(RuleDto rule, ILogger logger) : base(rule, logger)
    {
        if (rule.RuleKind != RuleKind.SourceColumnCopy)
        {
            throw new ArgumentException($"{nameof(rule)}.{nameof(rule.RuleKind)} is not {RuleKind.SourceColumnCopy}");
        }
    }

    /// <inheritdoc />
    public override ColumnValues GetInitialValues(IExcelDecorator source, IExcelDecorator target)
    {
        source.ThrowIfNull(nameof(source));
        return source.GetColumnValues(Rule.SourceEntity.GetItemNames());
    }
}