using System.Runtime.Serialization;

namespace Sibur.Digital.Svt.Infrastructure.Exceptions;

/// <summary>
/// Исключение, вбрасываемое в случае невозможности найти шаблон по идентификатору
/// </summary>
[Serializable]
public class TemplateNotFoundException : Exception

{
    public TemplateNotFoundException()
    {
    }

    public TemplateNotFoundException(int templateId) : base($"Не найден шаблон с идентификатором {templateId}")
    {
    }

    protected TemplateNotFoundException(SerializationInfo info, StreamingContext context) : base(info, context)
    {
    }

    public TemplateNotFoundException(string? message) : base(message)
    {
    }

    public TemplateNotFoundException(string? message, Exception? innerException) : base(message, innerException)
    {
    }
}