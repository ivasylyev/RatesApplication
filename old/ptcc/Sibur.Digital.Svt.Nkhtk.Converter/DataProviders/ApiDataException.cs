using System.Runtime.Serialization;

namespace Sibur.Digital.Svt.Nkhtk.Converter.DataProviders;

[Serializable]
public class ApiDataException : Exception
{
    public ApiDataException()
    {
    }

    protected ApiDataException(SerializationInfo info, StreamingContext context) : base(info, context)
    {
    }

    public ApiDataException(string? message) : base(message)
    {
    }

    public ApiDataException(string? message, Exception? innerException) : base(message, innerException)
    {
    }
}