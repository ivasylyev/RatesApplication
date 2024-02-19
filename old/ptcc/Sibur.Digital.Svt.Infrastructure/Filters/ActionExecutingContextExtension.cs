using Microsoft.AspNetCore.Mvc.Controllers;
using Microsoft.AspNetCore.Mvc.Filters;
using Sibur.Digital.Svt.Infrastructure.Utils;

namespace Sibur.Digital.Svt.Infrastructure.Filters;

/// <summary>
/// Расширение для класса  <see cref="ActionExecutingContext" />.
/// </summary>
public static class ActionExecutingContextExtension
{
    /// <summary>
    /// Создает человеко-читабельное описание контекста исполнения для целей логирования
    /// Описание содержит имя вызываемого метода с парамтерами в формате ControllerName.ActionName(parameterName=parameterValue)
    /// </summary>
    /// <param name="context">Контекст исполнения</param>
    /// <returns>Описание вызываемого имени метода с параметрами, например Rule.GetRulesAsync(worksheetId=1001)</returns>
    public static string GetActionDescription(this ActionExecutingContext context)
    {
        context.ThrowIfNull(nameof(context));

        var actionFullName = context.ActionDescriptor is ControllerActionDescriptor descriptor
            ? $"{descriptor.ControllerName}.{descriptor.ActionName}"
            : context.ActionDescriptor.DisplayName;

        var parameters = string.Join(", ", context.ActionArguments.Select(a => $"{a.Key}={a.Value}"));

        var message = $"{actionFullName}({parameters})";
        return message;
    }
}