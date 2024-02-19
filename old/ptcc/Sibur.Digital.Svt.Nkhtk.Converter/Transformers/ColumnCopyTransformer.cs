using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Infrastructure.Utils;
using Sibur.Digital.Svt.Nkhtk.Converter.DataProviders;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;
using Sibur.Digital.Svt.Nkhtk.Converter.Model;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Transformers;

/// <summary>
/// Преобразователь колонок исходного шаблона или же шаблона СВТ в другую колонку шаблона СВТ, действующий на основании бизнес-правла
/// </summary>
public abstract class ColumnCopyTransformer : Transformer
{
    protected ColumnCopyTransformer(RuleDto rule, ILogger logger) : base(rule, logger)
    {
        if (rule.SourceEntity is null || rule.SourceEntity.RuleEntityItems is null || !rule.SourceEntity.RuleEntityItems.Any())
        {
            throw new ArgumentException($"Имена сущностей отсутствуют для правила {Rule.RuleId}");
        }
    }

    /// <summary>
    /// Выдает список исходных значений для трансформации, описанной в правиле
    /// </summary>
    /// <param name="source">Исходный шаблон (на данный момент НХТК)</param>
    /// <param name="target">Результирующий шаблон СВТ</param>
    /// <returns></returns>
    public abstract ColumnValues GetInitialValues(IExcelDecorator source, IExcelDecorator target);

    /// <summary>
    /// Преобразователь исходного шаблона или же шаблона СВТ в другую колонку шаблона СВТ, действующий на основании бизнес-правла.
    /// Копирование происходит либо напрямую, либо, если у правила существует словарь - происходит
    /// подмена значений исходного шаблона на соответсвующие значения из словаря
    /// </summary>
    /// <param name="source">Исходный шаблон</param>
    /// <param name="target">Шаблон СВТ</param>
    public override void Apply(IExcelDecorator source, IExcelDecorator target)
    {
        source.ThrowIfNull(nameof(source));
        target.ThrowIfNull(nameof(target));


        Logger.LogDebug("Запуск трансформации {t} для правила ({id}): '{desc}'",
            GetType().Name, Rule.RuleId, Rule.Description);

        ColumnValues initialValues;
        try
        {
            initialValues = GetInitialValues(source, target);
        }
        catch (ExcelColumnNotFoundException)
        {
            if (Rule.Mandatory)
            {
                throw;
            }

            Logger.LogWarning("Необязательное правило {Id} не было применено", Rule.RuleId);
            return;
        }

        var calculatedValues = new ColumnValues(initialValues
            .Select(value => MapInitialValue(value, Rule.TreatMissingDictionaryValueAsError)));

        ColumnValues resultValues;
        if (Rule.RuleOperator != RuleOperator.None)
        {
            var existingValues = target.GetColumnValues(Rule.DestinationColumn);
            calculatedValues = CalculateTargetValues(existingValues, calculatedValues);

            resultValues = new ColumnValues(calculatedValues
                .Select(value => MapCalculatedValue(value, false)));
        }
        else
        {
            resultValues = calculatedValues;
        }

        target.SetColumnValues(Rule.RuleDataType, Rule.DestinationColumn, resultValues);

        var operatorMessage = Rule.RuleOperator == RuleOperator.None
            ? string.Empty
            : $"Был применен оператор '{Rule.RuleOperator}'. ";
        var dictionaryMessage = Rule.Dictionary.RuleDictionaryId is null
            ? string.Empty
            : $"Был использован словарь ({Rule.Dictionary.RuleDictionaryName} {Rule.Dictionary.RuleDictionaryId}) '{Rule.Dictionary.RuleDictionaryDescription}'";
        Logger.LogDebug("Закончена трансформация {t} для правила ({id}). Было скопировано {cnt} значений из исходной колонки в колонку '{col}'. {op} {dic} ",
            GetType().Name, Rule.RuleId, calculatedValues.Count, Rule.DestinationColumn, operatorMessage, dictionaryMessage);
    }

    /// <summary>
    /// Маппинг между посчитанными значениями при применнении оператора правила (+, -, *, /)
    /// и окончательными значениями шаблона и СВТ.
    /// В случае наличия значения в словаре - возвращается словарное значение по ключу "Предрасчитанное значение шаблона"
    /// в случае отсутствия - возвращается само "Предрасчитанное значение шаблона"
    /// </summary>
    /// <param name="source">Предрасчитанное значение шаблона</param>
    /// <param name="treatMissingValueAsError">Флаг, трактовать ли отсутсвие значения в словаре, как ошибку</param>
    /// <returns>значение для шаблона СВТ</returns>
    protected override ColumnValue MapCalculatedValue(ColumnValue source, bool treatMissingValueAsError)
    {
        var key = source.ValueToString();
        if (string.IsNullOrEmpty(key))
        {
            return source;
        }

        return Dictionary.TryGetValue(key, out var value)
            ? new ColumnValue(value)
            : new ColumnValue(source.Value, treatMissingValueAsError);
    }
}