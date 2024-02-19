using System.Runtime.Serialization;

namespace Sibur.Digital.Svt.Infrastructure.Exceptions;

/// <summary>
/// Исключение, вбрасываемое в случае невозможности применить оператор к данным входным значениям
/// </summary>
[Serializable]
public class InvalidOperatorValuesException : Exception
{
    public InvalidOperatorValuesException()
    {
    }

    protected InvalidOperatorValuesException(SerializationInfo info, StreamingContext context) : base(info, context)
    {
    }

    public InvalidOperatorValuesException(string? shortMessage, string? message) : base(message)
    {
        ShortMessage = shortMessage;
    }

    public InvalidOperatorValuesException(string? message, Exception? innerException) : base(message, innerException)
    {
    }

    public string? ShortMessage { get; }
}