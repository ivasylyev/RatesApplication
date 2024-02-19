using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.Extensions.Logging;
using Sibur.Digital.Svt.Infrastructure.Utils;

namespace Sibur.Digital.Svt.Infrastructure.Filters;

/// <inheritdoc />
public sealed class SvtExceptionFilterAttribute : ExceptionFilterAttribute
{
    private readonly ILogger<SvtExceptionFilterAttribute> _logger;

    public SvtExceptionFilterAttribute(ILogger<SvtExceptionFilterAttribute> logger)
    {
        _logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }

    /// <summary>
    /// Логирует все необработанные ошибки и возвращает в ответе описание ошибки
    /// </summary>
    /// <param name="context"></param>
    public override void OnException(ExceptionContext context)
    {
        context.ThrowIfNull(nameof(context));

        var message = GetErrorDescription(context);

        _logger.LogError(context.Exception, "{Msg}", message);

        context.Result = new ContentResult { Content = $"Action: {message} Exception: {context.Exception}" };
        context.ExceptionHandled = true;
    }

    private string GetErrorDescription(ExceptionContext context)
    {
        try
        {
            return context.GetActionDescription();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Cannot Get Error Message");
            return ex.Message;
        }
    }
}