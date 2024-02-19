using Sibur.Digital.Svt.Infrastructure.Exceptions;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Model;

/// <summary>
/// Список значений в колонке шаблона
/// </summary>
public class ColumnValues : List<ColumnValue>
{
    public ColumnValues()
    {
    }

    /// <summary>
    /// Инициализирует новый экземпляр <see cref="ColumnValues" /> и копирует в него переданное перечисление значений
    /// </summary>
    /// <param name="collection">Копируемые в создаваемую коллекцию значения</param>
    public ColumnValues(IEnumerable<ColumnValue> collection) : base(collection)
    {
    }

    public ColumnValues(int capacity) : base(capacity)
    {
    }

    public static ColumnValues operator +(ColumnValues a, ColumnValues b)
        => Operation(a, b, (v1, v2) => v1 + v2);

    public static ColumnValues operator -(ColumnValues a, ColumnValues b)
        => Operation(a, b, (v1, v2) => v1 - v2);

    public static ColumnValues operator *(ColumnValues a, ColumnValues b)
        => Operation(a, b, (v1, v2) => v1 * v2);

    public static ColumnValues operator /(ColumnValues a, ColumnValues b)
        => Operation(a, b, (v1, v2) => v1 / v2);

    public ColumnValues IsNull(ColumnValues b)
        => Operation(this, b, (v1, v2) => v1.Value != null ? v1 : v2);

    public ColumnValues Concat(ColumnValues b)
        => Operation(this, b, (v1, v2) =>new ColumnValue(v2.Value + v1.Value, v2.HasError || v1.HasError));

    private static ColumnValues Operation(ColumnValues a, ColumnValues b, Func<ColumnValue, ColumnValue, ColumnValue> operatorFunc)
    {
        if (a.Count != b.Count)
        {
            throw new InvalidOperationException($"Parameter {nameof(a)} count {a.Count} differs from {nameof(b)} count {b.Count}");
        }

        var result = new ColumnValues(a.Count);
        for (var index = 0; index < a.Count; index++)
        {
            try
            {
                result.Add(operatorFunc(a[index], b[index]));
            }
            catch (InvalidOperatorValuesException e)
            {
                result.Add(new ColumnValue(e.ShortMessage, true));
                // todo: add logging
            }
        }

        return result;
    }
}