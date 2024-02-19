using System.Text.Json;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Sibur.Digital.Svt.Infrastructure.Models;

namespace Sibur.Digital.Svt.Infrastructure.Utils;

/// <summary>
/// Помощник записи отчета о здорове в HttpResponse
/// </summary>
public static class HealthCheckResponseWriter
{
    public const string JsonContentType = "application/json; charset=utf-8";

    /// <summary>
    /// Записывает важную информацию из отчета о здоровье в ответ контекста context.Response
    /// </summary>
    /// <param name="context">контекст</param>
    /// <param name="healthReport">Отчет о здоровье</param>
    /// <returns></returns>
    /// <exception cref="ArgumentNullException"></exception>
    public static async Task WriteResponseAsync(HttpContext context, HealthReport healthReport)
    {
        context.ThrowIfNull(nameof(context));
        healthReport.ThrowIfNull(nameof(healthReport));

        var reportEntry = healthReport.Entries.FirstOrDefault().Value;
        var checkResult = new SiburHealthCheckResult(healthReport.Status, reportEntry.Description, reportEntry.Exception?.Message, reportEntry.Exception?.StackTrace);

        var json = JsonSerializer.Serialize(checkResult, new JsonSerializerOptions { WriteIndented = true });

        context.Response.ContentType = JsonContentType;
        await context.Response.WriteAsync(json)
            .ConfigureAwait(false);
    }
}