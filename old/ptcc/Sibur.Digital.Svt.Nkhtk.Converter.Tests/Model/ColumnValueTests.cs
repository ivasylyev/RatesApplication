using FluentAssertions;
using Sibur.Digital.Svt.Nkhtk.Converter.Model;
using Xunit;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Tests.Model;

public class ColumnValueTests
{
    [Fact(DisplayName = "ColumnValue Can perform Addition")]
    [Trait("Category", "Unit")]
    public void Can_Plus()
    {
        // Arrange
        var v1 = new ColumnValue("1.23");
        var v2 = new ColumnValue("2.23");

        // Act
        var v3 = v1 + v2;

        // Assert
        v3.Value.Should().Be("3.46");
        v3.HasError.Should().Be(false);
    }

    [Fact(DisplayName = "ColumnValue Can perform Addition with empty value")]
    [Trait("Category", "Unit")]
    public void Can_Plus_With_Empty()
    {
        // Arrange
        var v1 = new ColumnValue("1.23");
        var v2 = new ColumnValue("");

        // Act
        var v3 = v1 + v2;

        // Assert
        v3.Value.Should().Be("1.23");
        v3.HasError.Should().Be(false);
    }

    [Fact(DisplayName = "ColumnValue Can perform Addition with error value")]
    [Trait("Category", "Unit")]
    public void Can_Plus_With_Error()
    {
        // Arrange
        var v1 = new ColumnValue("1.23");
        var v2 = new ColumnValue("2", true);

        // Act
        var v3 = v1 + v2;

        // Assert
        v3.Value.Should().Be("3.23");
        v3.HasError.Should().Be(true);
    }

    [Fact(DisplayName = "ColumnValue Can perform Subtraction")]
    [Trait("Category", "Unit")]
    public void Can_Minus()
    {
        // Arrange
        var v1 = new ColumnValue("1.23");
        var v2 = new ColumnValue("2.23");

        // Act
        var v3 = v1 - v2;

        // Assert
        v3.Value.Should().Be("-1.00");
        v3.HasError.Should().Be(false);
    }


    [Fact(DisplayName = "ColumnValue Can perform Multiplication")]
    [Trait("Category", "Unit")]
    public void Can_Mult()
    {
        // Arrange
        var v1 = new ColumnValue("1.2");
        var v2 = new ColumnValue("1.3");

        // Act
        var v3 = v1 * v2;

        // Assert
        v3.Value.Should().Be("1.56");
        v3.HasError.Should().Be(false);
    }

    [Fact(DisplayName = "ColumnValue Can perform Division")]
    [Trait("Category", "Unit")]
    public void Can_Div()
    {
        // Arrange
        var v1 = new ColumnValue("4.5");
        var v2 = new ColumnValue("2");

        // Act
        var v3 = v1 / v2;

        // Assert
        v3.Value.Should().Be("2.25");
        v3.HasError.Should().Be(false);
    }
}