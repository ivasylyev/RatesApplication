using System.Data;
using Dapper;
using FluentAssertions;
using Microsoft.Extensions.Configuration;
using Moq;
using Sibur.Digital.Svt.Nkhtk.Data.DataProviders;
using Xunit;

namespace Sibur.Digital.Svt.Nkhtk.Data.Tests.DataProviders;

public class DapperDataProviderTests
{
    [Fact(DisplayName = "Can create DapperDataProvider instance.")]
    [Trait("Category", "Unit")]
    public void Can_Create_Instance()
    {
        // Arrange
        var config = ConfigurationHelper.GetConfiguration(MockBehavior.Strict);

        // Act
        var exception = Record.Exception(() => new DapperDataProvider(config));

        // Assert
        exception.Should().BeNull();
    }

    [Fact(DisplayName = "Can connect to the SQL Server.")]
    [Trait("Category", "Integration")]
    public void Can_Connect_To_Sql()
    {
        // Arrange
        var config = ConfigurationHelper.GetConfiguration(MockBehavior.Strict);
        var provider = new DapperDataProvider(config);

        // Act
        var exception = Record.Exception(() =>
        {
            var connection = provider.CreateConnection();
            connection.Execute("Select 1");
        });

        // Assert
        exception.Should().BeNull();
    }
}