using System.Linq;
using System.Threading.Tasks;
using FluentAssertions;
using Moq;
using Sibur.Digital.Svt.Nkhtk.Data.DataProviders;
using Sibur.Digital.Svt.Nkhtk.Data.Interfaces;
using Sibur.Digital.Svt.Nkhtk.Data.Repositories;
using Xunit;

namespace Sibur.Digital.Svt.Nkhtk.Data.Tests.Repositories;

public class TemplatesRepositoryTests
{
    [Fact(DisplayName = "Can create TemplateRepository.")]
    [Trait("Category", "Unit")]
    public void Can_Create_Instance()
    {
        // Arrange
        var provider = Mock.Of<IDataProvider>(MockBehavior.Strict);

        // Act
        var exception = Record.Exception(() => new TemplateRepository(provider));

        // Assert
        exception.Should().BeNull();
    }

    [Fact(DisplayName = "TemplateRepository Can return All Templates.")]
    [Trait("Category", "Integration")]
    public async Task Can_Return_Templates()
    {
        // Arrange
        var config = ConfigurationHelper.GetConfiguration(MockBehavior.Strict);
        var provider = new DapperDataProvider(config);
        var repository = new TemplateRepository(provider);

        // Act
        var templates = (await repository.GetTemplatesAsync(1))
            .ToArray();

        // Assert
        templates.Should().NotBeNull();
        templates.Should().HaveCountGreaterThan(0);

        var template = templates.First();
        template.Should().NotBeNull();
        template.TemplateId.Should().BeGreaterThan(0);
        template.TemplateRussianName.Should().NotBeNull();
        template.TemplateEnglishName.Should().NotBeNull();
        template.Worksheets.Should().HaveCountGreaterThan(0);
        var worksheet = template.Worksheets.First();
        worksheet.TemplateId.Should().Be(template.TemplateId);
        worksheet.WorksheetName.Should().NotBeNull();
        worksheet.WorksheetId.Should().BeGreaterThan(0);
    }
}