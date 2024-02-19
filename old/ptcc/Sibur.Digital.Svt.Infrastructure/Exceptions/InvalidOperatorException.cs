using System.Runtime.Serialization;

namespace Sibur.Digital.Svt.Infrastructure.Exceptions;

/// <summary>
/// Исключение, вбрасываемое в случае если данный оператор не поддерживается
/// </summary>
[Serializable]
public class InvalidOperatorException : Exception
{
    public InvalidOperatorException()
    {
    }

    protected InvalidOperatorException(SerializationInfo info, StreamingContext context) : base(info, context)
    {
    }

    public InvalidOperatorException(string? message) : base(message)
    {
    }

    public InvalidOperatorException(string? message, Exception? innerException) : base(message, innerException)
    {
    }
}