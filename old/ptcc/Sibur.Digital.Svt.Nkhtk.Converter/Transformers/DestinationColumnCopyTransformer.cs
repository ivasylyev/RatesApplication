using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Infrastructure.Utils;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;
using Sibur.Digital.Svt.Nkhtk.Converter.Model;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Transformers;

/// <summary>
/// Преобразователь колонки шаблона СВТ в другую колонку шаблона СВТ, действующий на основании бизнес-правла
/// </summary>
public sealed class DestinationColumnCopyTransformer : ColumnCopyTransformer
{
    public DestinationColumnCopyTransformer(RuleDto rule, ILogger logger) : base(rule, logger)
    {
        if (rule.RuleKind != RuleKind.DestinationColumnCopy)
        {
            throw new ArgumentException($"{nameof(rule)}.{nameof(rule.RuleKind)} is not {RuleKind.DestinationColumnCopy}");
        }
    }

    /// <inheritdoc />
    public override ColumnValues GetInitialValues(IExcelDecorator source, IExcelDecorator target)
    {
        target.ThrowIfNull(nameof(target));
        return target.GetColumnValues(Rule.SourceEntity.GetItemNames());
    }
}