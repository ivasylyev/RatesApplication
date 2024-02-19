using Microsoft.Extensions.Options;
using Moq;
using Sibur.Digital.Svt.Nkhtk.Converter.Config;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Tests;

public static class ConfigurationHelper
{
    public static IOptions<ApiOptions> Options
    {
        get
        {
            var options = new Mock<IOptions<ApiOptions>>(MockBehavior.Strict);
            options.SetupGet(c => c.Value)
                .Returns(() => new ApiOptions
                {
                    BaseUrl = "http://localhost",
                    GetHealthCheckAction = "hc",
                    GetTemplatesAction = "templates",
                    GetWorksheetAction = "worksheet",
                    GetRulesAction = "rules"
                });

            return options.Object;
        }
    }
}