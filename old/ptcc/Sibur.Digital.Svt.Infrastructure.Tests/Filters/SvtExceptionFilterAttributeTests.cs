using System.Collections.Generic;
using System.Threading.Tasks;
using FluentAssertions;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Controllers;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.Logging;
using Moq;
using Sibur.Digital.Svt.Infrastructure.Filters;
using Xunit;

namespace Sibur.Digital.Svt.Infrastructure.Tests.Filters;

public class SvtExceptionFilterAttributeTests
{
    [Fact(DisplayName = "Can create SvtExceptionFilterAttribute instance.")]
    [Trait("Category", "Unit")]
    public void Can_Create_Instance()
    {
        // Arrange
        var logger = Mock.Of<ILogger<SvtExceptionFilterAttribute>>(MockBehavior.Strict);

        // Act
        var exception = Record.Exception(() => new SvtExceptionFilterAttribute(logger));

        // Assert
        exception.Should().BeNull();
    }

    [Fact(DisplayName = "SvtExceptionFilterAttribute can log an error within OnException.")]
    [Trait("Category", "Unit")]
    public async Task OnException_Logs_Error()
    {
        // Arrange
        var httpContext = Mock.Of<HttpContext>(MockBehavior.Strict);
        var routeData = Mock.Of<RouteData>(MockBehavior.Strict);
        var controllerActionDescriptor = new ControllerActionDescriptor
        {
            ActionName = "Action",
            ControllerName = "Controller"
        };
        var actionContext = new ActionContext(httpContext, routeData, controllerActionDescriptor);
        var context = new ExceptionContext(actionContext, new List<IFilterMetadata>());
        var loggerMock = new Mock<ILogger<SvtExceptionFilterAttribute>>();
        var filter = new SvtExceptionFilterAttribute(loggerMock.Object);

        // Act
        var exception = await Record.ExceptionAsync(async () => await filter.OnExceptionAsync(context)
                .ConfigureAwait(false))
            .ConfigureAwait(false);

        // Assert
        exception.Should().BeNull();
        loggerMock.Verify(LogLevel.Error, "Controller.Action()");
    }
}