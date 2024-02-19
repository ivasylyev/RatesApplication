using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Transformers;

/// <summary>
/// Преобразователь одного элемента исходного шаблона в шаблон СВТ, действующий на основании бизнес-правла
/// копирования в каждую строчку колонки шаблона СВТ одной и той же константы,
/// заданной для текущей вкладки текущего исходного шаблона.
/// Количество копий констант зависит от количества заполненных строчек в исходном шаблоне
/// </summary>
public sealed class SourceSheetConstantTransformer : SheetConstantTransformer
{
    public SourceSheetConstantTransformer(RuleDto rule, ILogger logger) : base(rule, logger)
    {
        if (rule.RuleKind != RuleKind.SourceSheetConstant)
        {
            throw new ArgumentException(
                $"Тип правила {nameof(rule)}.{nameof(rule.RuleKind)} должен быть {RuleKind.SourceSheetConstant}");
        }
    }

    /// <inheritdoc />
    protected override int GetColumnValuesCount(IExcelDecorator source, IExcelDecorator target)
        => source.ColumnValuesCount();
}