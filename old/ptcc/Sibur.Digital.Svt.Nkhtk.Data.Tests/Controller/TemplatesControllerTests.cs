using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using FluentAssertions;
using Moq;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.Data.Controllers;
using Sibur.Digital.Svt.Nkhtk.Data.Interfaces;
using Xunit;

namespace Sibur.Digital.Svt.Nkhtk.Data.Tests.Controller;

public class TemplatesControllerTests
{
    [Fact(DisplayName = "Can create TemplateController.")]
    [Trait("Category", "Unit")]
    public void Can_Create_Instance()
    {
        // Arrange
        var repository = Mock.Of<ITemplateRepository>(MockBehavior.Strict);

        // Act
        var exception = Record.Exception(() => new TemplateController(repository));

        // Assert
        exception.Should().BeNull();
    }

    [Fact(DisplayName = "TemplateController can return all Templates.")]
    [Trait("Category", "Unit")]
    public async Task Can_Return_All_Templates()
    {
        // Arrange
        var givenTemplates = (IEnumerable<TemplateDto>)new List<TemplateDto>
        {
            new()
            {
                TemplateId = 1,
                TemplateRussianName = "тест",
                TemplateEnglishName = "Test"
            }
        };

        var repository = new Mock<ITemplateRepository>(MockBehavior.Strict);
        repository.Setup(r => r.GetTemplatesAsync(1))
            .Returns(() => Task.FromResult(givenTemplates));

        var controller = new TemplateController(repository.Object);

        // Act
        var templates = (await controller.Get(1))
            .ToList();

        // Assert

        templates.Should().NotBeNull();
        templates.Should().HaveCount(1);

        var template = templates.First();
        template.TemplateId.Should().Be(1);
        template.TemplateRussianName.Should().Be("тест");
        template.TemplateEnglishName.Should().Be("Test");
    }
}