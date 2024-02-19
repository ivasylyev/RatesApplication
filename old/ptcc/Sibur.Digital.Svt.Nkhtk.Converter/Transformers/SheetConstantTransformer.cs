using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Infrastructure.Utils;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;
using Sibur.Digital.Svt.Nkhtk.Converter.Model;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Transformers;

/// <summary>
/// Базовый преобразователь одного элемента исходного шаблона в шаблон СВТ, действующий на основании бизнес-правла
/// копирования в каждую строчку колонки шаблона СВТ одной и той же константы,
/// заданной для текущей вкладки текущего исходного шаблона
/// </summary>
public abstract class SheetConstantTransformer : Transformer
{
    protected SheetConstantTransformer(RuleDto rule, ILogger logger) : base(rule, logger)
    {
        if (!rule.Dictionary.RuleDictionaryItems.Any())
        {
            throw new ArgumentException($"Словарь {nameof(rule)}.{nameof(rule.Dictionary)} пустой для правила {rule}");
        }

        if (rule.Dictionary.RuleDictionaryItems.Count > 1)
        {
            throw new ArgumentException($"Словарь {nameof(rule)}.{nameof(rule.Dictionary)} имет более одного элемента для правила {rule}");
        }
    }

    /// <summary>
    /// Преобразователь копирует в каждую строчку колонки шаблона СВТ одну и ту же константу,
    /// единую для данной страницы исходного шаблона
    /// </summary>
    /// <param name="source">Исходный шаблон</param>
    /// <param name="target">Шаблон СВТ</param>
    public override void Apply(IExcelDecorator source, IExcelDecorator target)
    {
        source.ThrowIfNull(nameof(source));
        target.ThrowIfNull(nameof(target));

        Logger.LogDebug("Запуск трансформации {t} для правила ({id}): '{desc}'",
            GetType().Name, Rule.RuleId, Rule.Description);

        var constantMapping = Rule.Dictionary.RuleDictionaryItems.Single();

        var valuesCount = GetColumnValuesCount(source, target);
        var targetValues = MultiplyValue(constantMapping.DestinationValue, valuesCount);

        ColumnValues resultValues;
        if (Rule.RuleOperator != RuleOperator.None)
        {
            var existingValues = target.GetColumnValues(Rule.DestinationColumn);
            targetValues = CalculateTargetValues(existingValues, targetValues);

            resultValues = new ColumnValues(targetValues
                .Select(value => MapCalculatedValue(value, false)));
        }
        else
        {
            resultValues = targetValues;
        }

        target.SetColumnValues(Rule.RuleDataType, Rule.DestinationColumn, resultValues);

        var operatorMessage = Rule.RuleOperator == RuleOperator.None
            ? string.Empty
            : $"Был применен оператор '{Rule.RuleOperator}'. ";

        Logger.LogDebug("Закончена трансформация {t} для правила ({id}). Значение '{src}' было скопировано {cnt} раз в колонку {col} {op}",
            GetType().Name, Rule.RuleId, constantMapping.DestinationValue, valuesCount, Rule.DestinationColumn, operatorMessage);
    }

    /// <summary>
    /// Возвращает количество констант, которые необходимо скопировать
    /// </summary>
    /// <param name="source">Исходный шаблон</param>
    /// <param name="target">Шаблон СВТ</param>
    /// <returns></returns>
    protected abstract int GetColumnValuesCount(IExcelDecorator source, IExcelDecorator target);
}