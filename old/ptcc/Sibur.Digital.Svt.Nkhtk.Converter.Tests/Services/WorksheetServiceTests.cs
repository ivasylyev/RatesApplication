using System;
using System.Net.Http;
using System.Threading.Tasks;
using FluentAssertions;
using Moq;
using Newtonsoft.Json;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.Converter.DataProviders;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;
using Sibur.Digital.Svt.Nkhtk.Converter.Services;
using Xunit;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Tests.Services;

public class WorksheetServiceTests
{
    [Fact(DisplayName = "Can create WorksheetService instance.")]
    [Trait("Category", "Unit")]
    public void Can_Create_Instance()
    {
        // Arrange
        var provider = Mock.Of<IApiDataProvider>(MockBehavior.Strict);
        var options = ConfigurationHelper.Options;

        // Act
        var exception = Record.Exception(() => new WorksheetService(provider, options));

        // Assert
        exception.Should().BeNull();
    }

    [Fact(DisplayName = "WorksheetService can return a worksheet")]
    [Trait("Category", "Unit")]
    public async Task Can_Return_Worksheets()
    {
        // Arrange
        var expectedResult =
            new WorksheetDto
            {
                WorksheetId = 1001,
                TemplateId = 1,
                WorksheetName = "Worksheet",
                TemplateRussianName = "мой шаблончик",
                TemplateEnglishName = "Template"
            };

        var responseMessage = new HttpResponseMessage { Content = new StringContent(JsonConvert.SerializeObject(expectedResult)) };

        var httpClient = new Mock<IHttpDecorator>(MockBehavior.Strict);
        httpClient.Setup(c => c.GetAsync(It.Is<Uri>(s => s.AbsoluteUri == "http://localhost/worksheet?worksheetId=1001")))
            .Returns(() => Task.FromResult(responseMessage));
        httpClient.Setup(c => c.Dispose());

        using var provider = new ApiDataProvider(httpClient.Object, ConfigurationHelper.Options);
        var service = new WorksheetService(provider, ConfigurationHelper.Options);

        // Act
        var result = await service.GetWorksheetAsync(1001)
            .ConfigureAwait(false);

        // Assert
        result.Should().NotBeNull();
        result.WorksheetId.Should().Be(expectedResult.WorksheetId);
        result.TemplateId.Should().Be(expectedResult.TemplateId);
        result.WorksheetName.Should().Be(expectedResult.WorksheetName);
    }
}