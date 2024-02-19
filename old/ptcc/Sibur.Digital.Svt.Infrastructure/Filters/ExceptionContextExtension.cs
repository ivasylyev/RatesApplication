using Microsoft.AspNetCore.Mvc.Controllers;
using Microsoft.AspNetCore.Mvc.Filters;
using Sibur.Digital.Svt.Infrastructure.Utils;

namespace Sibur.Digital.Svt.Infrastructure.Filters;

/// <summary>
/// Расширение для класса  <see cref="ExceptionContext" />.
/// </summary>
public static class ExceptionContextExtension
{
    /// <summary>
    /// Создает человеко-читабельное описание контекста исключения в случае возникновения любых ошибок для целей логирования.
    /// Описание содержит имя вызываемого метода с парамтерами в формате ControllerName.ActionName(parameterName=parameterValue) 
    /// </summary>
    /// <param name="context">Контекст исключения</param>
    /// <returns>Описание имени метода с параметрами, в котором возникло исключение, например Rule.GetRulesAsync(worksheetId=1001)</returns>
    public static string GetActionDescription(this ExceptionContext context)
    {
        context.ThrowIfNull(nameof(context));

        var actionFullName = context.ActionDescriptor is ControllerActionDescriptor descriptor
            ? $"{descriptor.ControllerName}.{descriptor.ActionName}"
            : context.ActionDescriptor.DisplayName;

        var parameters = string.Join(", ", context.ModelState.Select(a => $"{a.Key}={a.Value?.RawValue}"));

        var message = $"{actionFullName}({parameters})";
        return message;
    }
}