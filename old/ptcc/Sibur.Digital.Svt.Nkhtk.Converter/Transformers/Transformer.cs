using Sibur.Digital.Svt.Infrastructure.Exceptions;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Infrastructure.Utils;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;
using Sibur.Digital.Svt.Nkhtk.Converter.Model;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Transformers;

/// <summary>
/// Базовый класс преобразователя одного элемента исходного шаблона в шаблон СВТ, действующий на основании бизнес-правла.
/// Наследник обязан переопределить <see cref="Apply" />
/// Полное преобразование исходного шаблона в шаблон СВТ происходит посредством
/// последовательного применения преобразователей.
/// </summary>
public abstract class Transformer : ITransformer
{
    protected readonly ILogger Logger;

    protected Transformer(RuleDto rule, ILogger logger)
    {
        Rule = rule ?? throw new ArgumentNullException(nameof(rule));
        Logger = logger ?? throw new ArgumentNullException(nameof(logger));

        if (string.IsNullOrEmpty(rule.DestinationColumn))
        {
            throw new ArgumentException($"{nameof(rule)}.{nameof(rule.DestinationColumn)} is not set. Rule: {rule}");
        }

        Dictionary = new Dictionary<string, string>();

        foreach (var mapping in Rule.Dictionary.RuleDictionaryItems)
        {
            var key = mapping.SourceValue;
            if (key!=null && !Dictionary.ContainsKey(key))
            {
                Dictionary.Add(key, mapping.DestinationValue);
            }
        }
    }

    /// <summary>
    /// Биснес-правило, на основании которого был создан данный преобразователь
    /// </summary>
    protected RuleDto Rule { get; }

    /// <summary>
    /// Словарь соответствия значений исходного шаблона и СВТ
    /// </summary>
    protected Dictionary<string, string> Dictionary { get; }

    /// <inheritdoc />
    public abstract void Apply(IExcelDecorator source, IExcelDecorator target);

    protected ColumnValues CalculateTargetValues(ColumnValues existingValues, ColumnValues newValues) =>
        Rule.RuleOperator switch
        {
            RuleOperator.Plus => existingValues + newValues,
            RuleOperator.Minus => existingValues - newValues,
            RuleOperator.Multiply => existingValues * newValues,
            RuleOperator.Divide => existingValues / newValues,
            //если элемент newValues не равен NULL, берем его. Иначе берем соответсвующий элемент existingValues
            RuleOperator.IsNull => newValues.IsNull(existingValues),
            // складываем значения как строки, 1+1 = 11
            RuleOperator.Concat => newValues.Concat(existingValues),
            _ => throw new InvalidOperatorException($"{nameof(Rule.RuleOperator)} = {Rule.RuleOperator} is not supported")
        };

    /// <summary>
    /// Маппинг между значениями исходного шаблона и СВТ.
    /// В случае наличия значения в словаре <see cref="Dictionary" /> возвращается значение СВТ,
    /// в случае отсутствия - исходное значение исходного шаблона
    /// </summary>
    /// <param name="source">Значение исходного шаблона</param>
    /// <param name="treatMissingValueAsError">Флаг, трактовать ли отсутсвие значения в словаре, как ошибку</param>
    /// <returns>значение для шаблона СВТ</returns>
    protected virtual ColumnValue MapInitialValue(ColumnValue source, bool treatMissingValueAsError)
    {
        var key = source.ValueToString();
        if (key is null)
        {
            return source;
        }

        return Dictionary.TryGetValue(key, out var value)
            ? new ColumnValue(value)
            : new ColumnValue(source.Value, treatMissingValueAsError);
    }

    /// <summary>
    /// Маппинг между предрасчитанными значениями при применнении оператора правила (+, -, *, /) и окончательными значениями шаблона и СВТ.
    /// В базовой реализации значение не меняется.
    /// </summary>
    /// <param name="source">Предрасчитанное значение шаблона</param>
    /// <param name="treatMissingValueAsError">Флаг, трактовать ли отсутсвие значения в словаре, как ошибку</param>
    /// <returns>значение для шаблона СВТ</returns>
    protected virtual ColumnValue MapCalculatedValue(ColumnValue source, bool treatMissingValueAsError)
        => source;

    protected ColumnValues MultiplyValue(string? constantValue, int count)
    {
        constantValue.ThrowIfNull(nameof(constantValue));
        if (count < 1)
        {
            throw new ArgumentException($"Parameter {nameof(count)}={count} must be positive.");
        }

        var values = new ColumnValues(Enumerable
            .Range(1, count)
            .Select(_ => new ColumnValue(constantValue)));
        return values;
    }
}