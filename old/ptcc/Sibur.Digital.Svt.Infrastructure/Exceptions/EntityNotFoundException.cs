using System.Runtime.Serialization;

namespace Sibur.Digital.Svt.Infrastructure.Exceptions;

/// <summary>
/// Исключение, вбрасываемое в случае невозможности найти сущность (колонку или ячейку) правила для данного исходного шаблона
/// </summary>
[Serializable]
public class EntityNotFoundException : Exception
{
    public EntityNotFoundException()
    {
    }

    public EntityNotFoundException(int worksheetId, int entityId) : base(GetMessage(worksheetId, entityId))
    {
    }

    protected EntityNotFoundException(SerializationInfo info, StreamingContext context) : base(info, context)
    {
    }

    public EntityNotFoundException(string? message) : base(message)
    {
    }

    public EntityNotFoundException(string? message, Exception? innerException) : base(message, innerException)
    {
    }

    private static string GetMessage(int worksheetId, int entityId)
        => $"Не найдена сущность (колонка или ячейка) с идентификатором {entityId} для бизнес-правила для вкладки с идентификатором {worksheetId}";

}