using System.Globalization;
using Sibur.Digital.Svt.Infrastructure.Exceptions;
using Sibur.Digital.Svt.Infrastructure.Utils;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Model;

/// <summary>
/// Значение ячейки шаблона
/// </summary>
public class ColumnValue
{
    public ColumnValue(string? value = null)
    {
        Value = value;
    }

    public ColumnValue(string? value, bool hasError)
    {
        Value = value;
        HasError = hasError;
    }

    public string? Value { get; set; }

    public bool HasError { get; set; }

    public static ColumnValue operator +(ColumnValue valA, ColumnValue valB)
    {
        if (TryParse(valA, valB, out var a, out var b))
        {
            return new ColumnValue(FormatDouble(a + b), valA.HasError || valB.HasError);
        }

        var error = GetError(valA, valB, "+");
        throw new InvalidOperatorValuesException(error.ShortMessage, error.Message);
    }

    public static ColumnValue operator -(ColumnValue valA, ColumnValue valB)
    {
        if (TryParse(valA, valB, out var a, out var b))
        {
            return new ColumnValue(FormatDouble(a - b), valA.HasError || valB.HasError);
        }

        var error = GetError(valA, valB, "-");
        throw new InvalidOperatorValuesException(error.ShortMessage, error.Message);
    }


    public static ColumnValue operator *(ColumnValue valA, ColumnValue valB)
    {
        if (TryParse(valA, valB, out var a, out var b))
        {
            return new ColumnValue(FormatDouble(a * b), valA.HasError || valB.HasError);
        }

        var error = GetError(valA, valB, "*");
        throw new InvalidOperatorValuesException(error.ShortMessage, error.Message);
    }

    public static ColumnValue operator /(ColumnValue valA, ColumnValue valB)
    {
        if (TryParse(valA, valB, out var a, out var b))
        {
            return new ColumnValue(FormatDouble(a / b), valA.HasError || valB.HasError);
        }

        var error = GetError(valA, valB, "/");
        throw new InvalidOperatorValuesException(error.ShortMessage, error.Message);
    }

    private static bool TryParse(ColumnValue valA, ColumnValue valB, out double a, out double b)
    {
        b = 0;
        var aValue = string.IsNullOrEmpty(valA.Value) ? "0" : valA.Value;
        var bValue = string.IsNullOrEmpty(valB.Value) ? "0" : valB.Value;
        return TryParse(aValue, out a) && TryParse(bValue, out b);
    }

    public static bool TryParse(object? expression, out double result)
        => double.TryParse(expression.ConvertToString()
            , NumberStyles.Any
            , NumberFormatInfo.InvariantInfo
            , out result);

    public string? ValueToString() => Value.ConvertToString();

    public override string ToString() => ValueToString() ?? string.Empty;

    private static ColumnValueError GetError(ColumnValue valA, ColumnValue valB, string op)
    {
        var a = valA.ValueToString();
        var b = valB.ValueToString();
        return new ColumnValueError($"{a}{op}{b}", $"Operator '{op}' is not supported for '{a}' and '{b}'");
    }

    private static string FormatDouble(double value)
        => value.ToString("F", CultureInfo.InvariantCulture);
}