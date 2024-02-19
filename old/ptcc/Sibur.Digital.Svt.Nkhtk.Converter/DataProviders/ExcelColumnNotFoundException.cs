using System.Runtime.Serialization;

namespace Sibur.Digital.Svt.Nkhtk.Converter.DataProviders;

[Serializable]
public class ExcelColumnNotFoundException : ArgumentException
{
    public ExcelColumnNotFoundException()
    {
    }

    public ExcelColumnNotFoundException(string worksheetName, string[]? columnNames)
        : base(columnNames is null
        ? $"Параметр {nameof(columnNames)} не содержит имен колонок"
        : $"На вкладке {worksheetName} файла excel ни одно из имен колонок не найдено ({string.Join(", ", columnNames)})")
    {
    }

    protected ExcelColumnNotFoundException(SerializationInfo info, StreamingContext context) : base(info, context)
    {
    }

    public ExcelColumnNotFoundException(string? message) : base(message)
    {
    }

    public ExcelColumnNotFoundException(string? message, Exception? innerException) : base(message, innerException)
    {
    }
}