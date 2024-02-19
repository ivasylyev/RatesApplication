using FluentAssertions;
using Sibur.Digital.Svt.Nkhtk.Converter.Model;
using Xunit;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Tests.Model;

public class ColumnValuesTests
{
    [Fact(DisplayName = "ColumnValues Can perform Addition")]
    [Trait("Category", "Unit")]
    public void Can_Plus()
    {
        // Arrange
        var v1 = new ColumnValues(new[]
        {
            new ColumnValue("1.23"),
            new ColumnValue("2.23")
        });
        var v2 = new ColumnValues(new[]
        {
            new ColumnValue("2"),
            new ColumnValue("3.77")
        });

        // Act
        var v3 = v1 + v2;

        // Assert
        v3[0].Value.Should().Be("3.23");
        v3[1].Value.Should().Be("6.00");
    }

    [Fact(DisplayName = "ColumnValues Cannot perform Addition if argumnts have diferent size")]
    [Trait("Category", "Unit")]
    public void Exception_On_Different_Size()
    {
        // Arrange
        var v1 = new ColumnValues(new[]
        {
            new ColumnValue("1"),
            new ColumnValue("2")
        });
        var v2 = new ColumnValues(new[] { new ColumnValue("3") });

        // Act
        var exception = Record.Exception(() => v1 + v2);

        // Assert
        exception.Should().NotBeNull();
        exception?.Message.Should().Contain("Parameter a count 2 differs from b count 1");
    }
}