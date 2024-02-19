using System.Threading.Tasks;
using FluentAssertions;
using Moq;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.Data.Controllers;
using Sibur.Digital.Svt.Nkhtk.Data.Interfaces;
using Xunit;

namespace Sibur.Digital.Svt.Nkhtk.Data.Tests.Controller;

public class WorksheetControllerTests
{
    [Fact(DisplayName = "WorksheetController can return worksheet")]
    [Trait("Category", "Unit")]
    public async Task Can_Return_Worksheet()
    {
        // Arrange
        var givenWorksheet =
            new WorksheetDto
            {
                WorksheetId = 1001,
                TemplateId = 1,
                WorksheetName = "Ставки"
            };

        var repository = new Mock<IWorksheetRepository>(MockBehavior.Strict);
        repository.Setup(r => r.GetWorksheetAsync(It.IsAny<int>()))
            .Returns(() => Task.FromResult(givenWorksheet));

        var controller = new WorksheetController(repository.Object);

        // Act
        var worksheet = await controller.Get(It.IsAny<int>());
     
        // Assert

        worksheet.Should().NotBeNull();
        worksheet.WorksheetName.Should().Be("Ставки");
        worksheet.WorksheetId.Should().Be(1001);
        worksheet.TemplateId.Should().Be(1);
    }
}