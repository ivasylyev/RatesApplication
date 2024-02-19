using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Mvc;

namespace Sibur.Digital.Svt.Infrastructure.Exceptions;

/// <summary>
/// Исключение, вбрасываемое в случае ошибки конвертации исходного шаблона в шаблон СВТ
/// </summary>
[Serializable]
public class ConvertException : Exception
{
    [JsonConstructor]
    private ConvertException()
    {
    }

    public ConvertException(ProblemDetails problemDetails) : base(problemDetails.ToString())
    {
        ProblemDetails = problemDetails;
    }

    public ConvertException(ProblemDetails problemDetails, Exception? innerException) : base(problemDetails.ToString(), innerException)
    {
        ProblemDetails = problemDetails;
    }

    public ProblemDetails? ProblemDetails { get; set; }
}