using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Transformers;

/// <summary>
/// Преобразователь одного элемента исходного шаблона в шаблон СВТ, действующий на основании бизнес-правла
/// копирования в каждую строчку колонки шаблона СВТ одной и той же константы,
/// заданной для текущей вкладки текущего исходного шаблона.
/// Количество копий констант зависит от количества уже заполненных строчек в шаблоне СВТ
/// </summary>
public sealed class DestinationSheetConstantTransformer : SheetConstantTransformer
{
    public DestinationSheetConstantTransformer(RuleDto rule, ILogger logger) : base(rule, logger)
    {
        if (rule.RuleKind != RuleKind.DestinationSheetConstant && rule.RuleKind != RuleKind.SheetParameter)
        {
            throw new ArgumentException(
                $"Тип правила {nameof(rule)}.{nameof(rule.RuleKind)} должен быть или {RuleKind.DestinationSheetConstant} или {RuleKind.SheetParameter} для правила {Rule.RuleId}");
        }

    }

    /// <inheritdoc />
    protected override int GetColumnValuesCount(IExcelDecorator source, IExcelDecorator target)
        => target.ColumnValuesCount();
}