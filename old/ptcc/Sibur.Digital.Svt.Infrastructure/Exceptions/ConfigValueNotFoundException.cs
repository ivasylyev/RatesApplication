using System.Runtime.Serialization;

namespace Sibur.Digital.Svt.Infrastructure.Exceptions;

/// <summary>
/// Исключение, вбрасываемое в случае если для данного ключа не найдено значение в конфиге
/// </summary>
[Serializable]
public class ConfigValueNotFoundException : Exception
{
    public ConfigValueNotFoundException()
    {
    }

    protected ConfigValueNotFoundException(SerializationInfo info, StreamingContext context) : base(info, context)
    {
    }

    public ConfigValueNotFoundException(string parameterName) : base($"Config doesn't have parameter {parameterName} specified")
    {
    }

    public ConfigValueNotFoundException(string? message, Exception? innerException) : base(message, innerException)
    {
    }
}