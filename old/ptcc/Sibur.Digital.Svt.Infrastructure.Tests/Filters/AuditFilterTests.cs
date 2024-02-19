using System.Collections.Generic;
using System.Threading.Tasks;
using FluentAssertions;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Abstractions;
using Microsoft.AspNetCore.Mvc.Controllers;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.Logging;
using Moq;
using Sibur.Digital.Svt.Infrastructure.Filters;
using Xunit;

namespace Sibur.Digital.Svt.Infrastructure.Tests.Filters;

public class AuditFilterTests
{
    [Fact(DisplayName = "Can create AuditFilter Instance")]
    [Trait("Category", "Unit")]
    public void Can_Create_Instance()
    {
        // Arrange
        var logger = Mock.Of<ILogger<AuditFilter>>(MockBehavior.Strict);

        // Act
        var exception = Record.Exception(() => new AuditFilter(logger));

        // Assert
        exception.Should().BeNull();
    }

    /// <summary>
    /// Этот тест подвисает на тест стенде по непонятной причине.
    /// Временно сделал его интеграционным чтобы не блокировать срочную задачу по CI/CD
    /// </summary>
    [Fact(DisplayName = "AuditFilter.OnActionExecutionAsync can log action description")]
    [Trait("Category", "Unit")]
    public async Task OnActionExecutionAsync_Logs_Action_Description()
    {
        // Arrange
        var controllerActionDescriptor = new ControllerActionDescriptor
        {
            ActionName = "Action",
            ControllerName = "Controller"
        };
        var httpContext = Mock.Of<HttpContext>(MockBehavior.Strict);
        var routeData = Mock.Of<RouteData>(MockBehavior.Strict);
        var actionContext = Mock.Of<ActionContext>(x => x.HttpContext == httpContext
                                                        && x.RouteData == routeData
                                                        && x.ActionDescriptor == controllerActionDescriptor);
        var filters = new List<IFilterMetadata>();
        var actionArguments = new Dictionary<string, object?>
        {
            { "param1", 1 },
            { "param2", "2" }
        };
        var controller = Mock.Of<Controller>(MockBehavior.Strict);
        var context = new ActionExecutingContext(actionContext, filters, actionArguments, controller);
        var loggerMock = new Mock<ILogger<AuditFilter>>();
        var filter = new AuditFilter(loggerMock.Object);

        // Act
        var exception = await Record.ExceptionAsync(async () => await filter.OnActionExecutionAsync(context, ActionNext)
                .ConfigureAwait(false))
            .ConfigureAwait(false);

        // Assert
        exception.Should().BeNull();
        loggerMock.Verify(LogLevel.Debug, "Controller.Action(param1=1, param2=2)");
    }

    private async Task<ActionExecutedContext> ActionNext()
    {
        var httpContext = Mock.Of<HttpContext>(MockBehavior.Strict);
        var routeData = Mock.Of<RouteData>(MockBehavior.Strict);
        var actionDescriptor = Mock.Of<ActionDescriptor>(MockBehavior.Strict);

        var actionContext = Mock.Of<ActionContext>(x => x.HttpContext == httpContext
                                                        && x.RouteData == routeData
                                                        && x.ActionDescriptor == actionDescriptor);
        var controller = Mock.Of<Controller>(MockBehavior.Strict);
        var context = new ActionExecutedContext(actionContext, new List<IFilterMetadata>(), controller);

        return await Task.FromResult(context)
            .ConfigureAwait(false);
    }
}