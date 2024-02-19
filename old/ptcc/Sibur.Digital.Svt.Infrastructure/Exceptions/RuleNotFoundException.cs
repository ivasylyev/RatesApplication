using System.Runtime.Serialization;

namespace Sibur.Digital.Svt.Infrastructure.Exceptions;

/// <summary>
/// Исключение, вбрасываемое в случае невозможности найти правила для данного исходного шаблона
/// </summary>
[Serializable]
public class RuleNotFoundException : Exception
{
    public RuleNotFoundException()
    {
    }

    public RuleNotFoundException(int worksheetId) : base(GetMessage(worksheetId))
    {
    }

    protected RuleNotFoundException(SerializationInfo info, StreamingContext context) : base(info, context)
    {
    }

    public RuleNotFoundException(string? message) : base(message)
    {
    }

    public RuleNotFoundException(string? message, Exception? innerException) : base(message, innerException)
    {
    }

    private static string GetMessage(int worksheetId)
        => $"Не найдены бизнес-правила для вкладки с идентификатором {worksheetId}";
}