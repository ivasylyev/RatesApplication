using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.Extensions.Logging;
using Sibur.Digital.Svt.Infrastructure.Utils;

namespace Sibur.Digital.Svt.Infrastructure.Filters;

/// <summary>
/// Фильтр для аудита вызовов всех Action
/// </summary>
public class AuditFilter : IAsyncActionFilter
{
    private readonly ILogger<AuditFilter> _logger;

    public AuditFilter(ILogger<AuditFilter> logger)
    {
        _logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }

    /// <summary>
    /// Получает из контекста <see cref="ActionExecutingContext" /> информацию о вызываемом Action, такую, как полное имя и параметры,
    /// и логирует ее вместе с временем выполнения Action
    /// </summary>
    /// <param name="context">Контекст <see cref="ActionExecutingContext" />.</param>
    /// <param name="next">Делегат <see cref="ActionExecutionDelegate" /> выполняющий сам Action</param>
    /// <returns></returns>
    public async Task OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next)
    {
        // Получаем описание Action для целей аудита. В описание входит имя Controller, имя Action и параметры
        var message = GetAuditDescription(context);

        // Логируем факт вызова Action с описанием и временем исполнения
        using (new StopwatchTransaction(_logger, message))
        {
            await next()
                .ConfigureAwait(false);
        }
    }

    /// <summary>
    /// Создает человеко-читабельное описание контекста исполнения для целей логирования
    /// Описание содержит имя вызываемого метода с парамтерами в формате ControllerName.ActionName(parameterName=parameterValue)
    /// </summary>
    /// <param name="context">Контекст <see cref="ActionExecutingContext" />.</param>
    /// <returns>Описание вызываемого имени метода с параметрами, например Rule.GetRulesAsync(worksheetId=1001)</returns>
    private string GetAuditDescription(ActionExecutingContext context)
    {
        try
        {
            return context.GetActionDescription();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Cannot create {nameof(context)} description.");
            return ex.Message;
        }
    }
}