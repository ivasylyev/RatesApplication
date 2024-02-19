using FluentAssertions;
using Sibur.Digital.Svt.Nkhtk.Converter.DataProviders;
using Xunit;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Tests.DataProviders;

public class HttpDecoratorTests
{
    [Fact(DisplayName = "Can create HttpDecorator instance.")]
    [Trait("Category", "Unit")]
    public void Can_Create_Instance()
    {
        // Arrange

        // Act
        var exception = Record.Exception(() => new HttpDecorator());

        // Assert
        exception.Should().BeNull();
    }

    [Fact(DisplayName = "Can dispose HttpDecorator instance.")]
    [Trait("Category", "Unit")]
    public void Can_Dispose_Instance()
    {
        // Arrange

        // Act
        var exception = Record.Exception(() =>
        {
            using (new HttpDecorator())
            {
            }
        });

        // Assert
        exception.Should().BeNull();
    }
}