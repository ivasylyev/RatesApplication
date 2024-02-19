using System.Threading.Tasks;
using FluentAssertions;
using Moq;
using Sibur.Digital.Svt.Nkhtk.Data.DataProviders;
using Sibur.Digital.Svt.Nkhtk.Data.Repositories;
using Xunit;

namespace Sibur.Digital.Svt.Nkhtk.Data.Tests.Repositories;

public class WorksheetRepositoryTests
{
    [Fact(DisplayName = "WorksheetRepository will get worksheet by ID")]
    [Trait("Category", "Integration")]
    public async Task Can_GetWorksheet()
    {
        // Arrange
        var config = ConfigurationHelper.GetConfiguration(MockBehavior.Strict);
        var provider = new DapperDataProvider(config);
        var repository = new WorksheetRepository(provider);

        // Act
        var worksheet = await repository.GetWorksheetAsync(1001);

        // Assert
        worksheet.Should().NotBeNull();
        worksheet.WorksheetId.Should().BeGreaterThan(0);
        worksheet.TemplateId.Should().BeGreaterThan(0);
        worksheet.WorksheetName.Should().NotBeNull();
    }

    [Fact(DisplayName = "WorksheetRepository will fail with unknown worksheet id.")]
    [Trait("Category", "Integration")]
    public async Task Unknown_Id_Fail()
    {
        // Arrange
        var config = ConfigurationHelper.GetConfiguration(MockBehavior.Strict);
        var provider = new DapperDataProvider(config);
        var repository = new WorksheetRepository(provider);

        // Act
        var exception = await Record.ExceptionAsync(async () => await repository.GetWorksheetAsync(-1));

        // Assert
        exception.Should().NotBeNull();
        exception?.Message.Should().Contain("Не найдена вкладка шаблона с идентификатором -1");
    }
}