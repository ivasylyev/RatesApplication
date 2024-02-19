using System.Runtime.Serialization;

namespace Sibur.Digital.Svt.Infrastructure.Exceptions;

/// <summary>
/// Исключение, вбрасываемое в случае невозможности найти вкладку шаблона по идентификатору
/// </summary>
[Serializable]
public class WorksheetNotFoundException : Exception

{
    public WorksheetNotFoundException()
    {
    }

    public WorksheetNotFoundException(int worksheetId) : base($"Не найдена вкладка шаблона с идентификатором {worksheetId}")
    {
    }

    protected WorksheetNotFoundException(SerializationInfo info, StreamingContext context) : base(info, context)
    {
    }

    public WorksheetNotFoundException(string? message) : base(message)
    {
    }

    public WorksheetNotFoundException(string? message, Exception? innerException) : base(message, innerException)
    {
    }
}