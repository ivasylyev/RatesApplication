using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Infrastructure.Utils;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;
using Sibur.Digital.Svt.Nkhtk.Converter.Model;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Transformers;

/// <summary>
/// Преобразователь одного элемента исходного шаблона в шаблон СВТ, действующий на основании бизнес-правла
/// копирования в шаблон СВТ ряда констант.
/// Для каждой константы создается копия ВСЕХ существующих данных в других колонках.
/// Например, если а шаблоне СВТ было 3 строки с данными, а ряд констант состоит из двух значений,
/// после применения правила в шаблоне СВТ будет 6 строк с данными, по 3 для каждого значения из ряда констант
/// </summary>
public sealed class SheetMultiplierTransformer : Transformer
{
    public SheetMultiplierTransformer(RuleDto rule, ILogger logger) : base(rule, logger)
    {
        if (rule.RuleKind != RuleKind.SheetMultiplier)
        {
            throw new ArgumentException($"{nameof(rule)}.{nameof(rule.RuleKind)} is not {RuleKind.SheetMultiplier}");
        }

        if (!rule.Dictionary.RuleDictionaryItems.Any())
        {
            throw new ArgumentException($"{nameof(rule)}.{nameof(rule.Dictionary)} is empty. Rule: {rule}");
        }
    }

    /// <summary>
    /// Преобразователь копирует в колонку шаблона СВТ ряд констант,
    /// для каждой константы создавая копию ВСЕХ существующих данных в других колонках.
    /// Например, если а шаблоне СВТ было 3 строки с данными, а ряд констант состоит из двух значений,
    /// после применения правила в шаблоне СВТ будет 6 строк с данными, по 3 для каждого значения из ряда констант
    /// </summary>
    /// <param name="source"></param>
    /// <param name="target"></param>
    public override void Apply(IExcelDecorator source, IExcelDecorator target)
    {
        source.ThrowIfNull(nameof(source));
        target.ThrowIfNull(nameof(target));
        Logger.LogDebug("Запуск трансформации {t} для правила ({id}): '{desc}'",
            GetType().Name, Rule.RuleId, Rule.Description);

        // Получаем количество строк со значениями в экселе (то есть количество строк от заголовка до последней строки эеселя)
        var valuesCount = target.ColumnValuesCount();

        // Копируем все строки со значениями и вставляем их столько раз, сколько имеется маппингов
        // то есть все значения всех колнок будут несколько раз повторяться по циклу
        target.MultiplyAllColumnsValues(Rule.Dictionary.RuleDictionaryItems.Count, Rule.DestinationColumn);

        // Получаем список констант для изменяемой колонки
        var constantValues = GetMultipliedConstantValue(valuesCount);

        target.SetColumnValues(Rule.RuleDataType, Rule.DestinationColumn, constantValues);

        Logger.LogDebug("Закончена трансформация {t} для правила ({id}). Исходные значения были скопированы {cnt} раз в колонку {col}.",
            GetType().Name, Rule.RuleId, Rule.Dictionary.RuleDictionaryItems.Count, Rule.DestinationColumn);
    }

    private ColumnValues GetMultipliedConstantValue(int valuesCount)
    {
        var constantValues = new ColumnValues();

        foreach (var mapping in Rule.Dictionary.RuleDictionaryItems)
        {
            constantValues.AddRange(MultiplyValue(mapping.DestinationValue, valuesCount));
        }

        return constantValues;
    }
}