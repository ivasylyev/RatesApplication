using Microsoft.Extensions.Configuration;
using Moq;

namespace Sibur.Digital.Svt.Nkhtk.Data.Tests;

public static class ConfigurationHelper
{
    private const string ConnectionString =
        "Server=S001ITD-0084;Database=mdm_integ;Trusted_Connection=false;User ID=SVT;Password=SVTsrv1!;MultipleActiveResultSets=true;Application Name=nkhtk-tests";

    public static IConfiguration GetConfiguration(MockBehavior mockBehavior)
    {
        var section = new Mock<IConfigurationSection>(mockBehavior);
        section.SetupGet(m => m[It.Is<string>(s => s == "SqlConnection")])
            .Returns(ConnectionString);

        var configuration = new Mock<IConfiguration>(mockBehavior);
        configuration.Setup(c => c.GetSection(It.Is<string>(s => s == "ConnectionStrings")))
            .Returns(() => section.Object);
        return configuration.Object;
    }
}