using System.Runtime.Serialization;

namespace Sibur.Digital.Svt.Nkhtk.Converter.DataProviders;

[Serializable]
public class ExcelAmbiguousColumnException : ArgumentException
{
    public ExcelAmbiguousColumnException()
    {
    }

    public ExcelAmbiguousColumnException(string[] columnNames)
        : base( $"Должна быть только одна колонка с одним из данных имен: ({string.Join(", ", columnNames)})")
    {
    }

    protected ExcelAmbiguousColumnException(SerializationInfo info, StreamingContext context) : base(info, context)
    {
    }

    public ExcelAmbiguousColumnException(string? message) : base(message)
    {
    }

    public ExcelAmbiguousColumnException(string? message, Exception? innerException) : base(message, innerException)
    {
    }
}