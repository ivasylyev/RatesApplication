using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Infrastructure.Utils;
using Sibur.Digital.Svt.Nkhtk.Converter.DataProviders;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;
using Sibur.Digital.Svt.Nkhtk.Converter.Model;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Transformers;

/// <summary>
/// Преобразователь одного элемента исходного шаблона в шаблон СВТ, действующий на основании бизнес-правла
/// копирования в каждую строчку колонки шаблона СВТ одного и то же значения.
/// В зависимости от типа бизнес-правила значение берется из ячейки по вертикали снизу
/// под ячейкой с заголовком или горизонтаи сбоку ячейки с заголовком
/// </summary>
public sealed class CellCopyTransformer : Transformer
{
    public CellCopyTransformer(RuleDto rule, ILogger logger) : base(rule, logger)
    {
        if (rule.RuleKind != RuleKind.HorizontalCellCopy && rule.RuleKind != RuleKind.VerticalCellCopy)
        {
            throw new ArgumentException(
                $"Тип правила {nameof(rule)}.{nameof(rule.RuleKind)} должен быть или {RuleKind.HorizontalCellCopy} или {RuleKind.VerticalCellCopy} для правила {Rule.RuleId}");
        }

        if (rule.SourceEntity is null || rule.SourceEntity.RuleEntityItems is null || !rule.SourceEntity.RuleEntityItems.Any())
        {
            throw new ArgumentException($"Имена сущностей отсутствуют для правила {Rule.RuleId}");
        }
    }

    /// <summary>
    /// Копирует значение из исходного шаблона в столбец шаблона СВТ.
    /// В заисимости от типа бизнес-правила копируемое значение берется из ячейки по вертикали снизу
    /// под ячейкой с заголовком или горизонтаи сбоку ячейки с заголовком
    /// </summary>
    /// <param name="source">Исходный шаблон</param>
    /// <param name="target">Шаблон СВТ</param>
    public override void Apply(IExcelDecorator source, IExcelDecorator target)
    {
        source.ThrowIfNull(nameof(source));
        target.ThrowIfNull(nameof(target));

        Logger.LogDebug("Запуск трансформации {t} для правила ({id}): '{desc}'",
            GetType().Name, Rule.RuleId, Rule.Description);
        var orientation = GetCellOrientation();

        string? sourceValue;
        try
        {
            sourceValue = source.GetCellValue(orientation, Rule.SourceEntity.GetItemNames());
        }
        catch (ExcelColumnNotFoundException)
        {
            if (Rule.Mandatory)
            {
                throw;
            }

            Logger.LogWarning("Необязательное правило {Id} не было применено. ", Rule.RuleId);
            return;
        }

        var valuesCount = target.ColumnValuesCount();
        var targetValues = MultiplyValue(sourceValue, valuesCount);

        target.SetColumnValues(Rule.RuleDataType, Rule.DestinationColumn, targetValues);

        Logger.LogDebug("Закончена трансформация {t} для правила ({id}). Значение '{src}' было скопировано {cnt} раз в колонку {col}",
            GetType().Name, Rule.RuleId, sourceValue, valuesCount, Rule.DestinationColumn);
    }

    private CellValueOrientation GetCellOrientation() =>
        Rule.RuleKind switch
        {
            RuleKind.HorizontalCellCopy => CellValueOrientation.Horizontal,
            RuleKind.VerticalCellCopy => CellValueOrientation.Vertical,
            _ => throw new NotSupportedException($"{nameof(Rule.RuleKind)}={Rule.RuleKind} is not supported")
        };
}