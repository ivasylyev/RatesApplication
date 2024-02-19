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

public class RuleControllerTests
{
    [Fact(DisplayName = "Can create RuleController instance.")]
    [Trait("Category", "Unit")]
    public void Can_Create_Instance()
    {
        // Arrange
        var repository = Mock.Of<IRuleRepository>();

        // Act
        var exception = Record.Exception(() => new RuleController(repository));

        // Assert
        exception.Should().BeNull();
    }

    [Fact(DisplayName = "RuleController Can return a Rule by id")]
    [Trait("Category", "Unit")]
    public async Task Can_Return__Rule_By_Id()
    {
        // Arrange
        var testRules = GetTestRules();

        var repository = new Mock<IRuleRepository>();
        repository.Setup(r => r.GetRulesAsync(It.IsAny<int>()))
            .Returns(() => Task.FromResult(testRules));

        var controller = new RuleController(repository.Object);

        // Act
        var rules = (await controller.GetByWorksheet(1))
            .ToList();

        // Assert
        AssertTestRules(rules);
    }

    private static List<RuleDto> GetTestRules()
    {
        var givenRules = new List<RuleDto>
        {
            new()
            {
                RuleId = 1,
                DestinationColumn = "Test",
                RuleKind = RuleKind.SourceColumnCopy,
                Mandatory = true
            }
        };
        return givenRules;
    }

    private static void AssertTestRules(List<RuleDto> Rules)
    {
        Rules.Should().NotBeNull();
        Rules.Should().HaveCount(1);

        var Rule = Rules.First();
        Rule.RuleId.Should().Be(1);
        Rule.DestinationColumn.Should().Be("Test");
        Rule.RuleKind.Should().Be(RuleKind.SourceColumnCopy);
    }
}