using System;
using System.Collections.Generic;
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

public class RuleServiceTests
{
    [Fact(DisplayName = "Can create RuleService instance.")]
    [Trait("Category", "Unit")]
    public void Can_Create_Instance()
    {
        // Arrange
        var provider = Mock.Of<IApiDataProvider>(MockBehavior.Strict);
        var options = ConfigurationHelper.Options;

        // Act
        var exception = Record.Exception(() => new RuleService(provider, options));

        // Assert
        exception.Should().BeNull();
    }

    [Fact(DisplayName = "RuleService can return rules")]
    [Trait("Category", "Unit")]
    public async Task Can_Return_Rules()
    {
        // Arrange
        var expectedResult = new[]
        {
            new RuleDto
            {
                RuleId = 40,
                RuleKind = RuleKind.SourceColumnCopy,
                DestinationColumn = "LoadedRFSize",
                Mandatory = true,
                SourceEntity = new RuleEntityDto(new List<string>
                {
                    "Тариф",
                    "Сумма значений (Тариф Сахалин+Тариф по РЖД); Тариф РЖД",
                    "Тариф РЖД",
                    "Тариф по РЖД"
                }),
                SourceWorksheets = new List<int>()
                {
                    101,
                    102,
                    103
                }
            }
        };
        var responseMessage = new HttpResponseMessage { Content = new StringContent(JsonConvert.SerializeObject(expectedResult)) };

        var httpClient = new Mock<IHttpDecorator>(MockBehavior.Strict);
        httpClient.Setup(c => c.GetAsync(It.Is<Uri>(s => s.AbsoluteUri == "http://localhost/rules?worksheetId=1001")))
            .Returns(() => Task.FromResult(responseMessage));
        httpClient.Setup(c => c.Dispose());

        using var provider = new ApiDataProvider(httpClient.Object, ConfigurationHelper.Options);
        var service = new RuleService(provider, ConfigurationHelper.Options);

        // Act
        var result = (await service.GetRulesAsync(1001)
                .ConfigureAwait(false))
            .ToArray();

        // Assert
        result.Should().NotBeNull();
        result.Length.Should().Be(expectedResult.Length);
        result[0].RuleId.Should().Be(expectedResult[0].RuleId);
        result[0].RuleKind.Should().Be(expectedResult[0].RuleKind);
        result[0].DestinationColumn.Should().Be(expectedResult[0].DestinationColumn);
        result[0].SourceEntity.RuleEntityItems.Count.Should().Be(expectedResult[0].SourceEntity.RuleEntityItems.Count);
        result[0].SourceEntity.RuleEntityItems[0].RuleEntityItemName.Should().Be(expectedResult[0].SourceEntity.RuleEntityItems[0].RuleEntityItemName);
        result[0].SourceWorksheets.Count.Should().Be(expectedResult[0].SourceWorksheets.Count);
        result[0].SourceWorksheets[0].Should().Be(expectedResult[0].SourceWorksheets[0]);
    }
}