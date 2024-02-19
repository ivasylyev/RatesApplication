using System.Collections.Generic;
using System.Linq;
using FluentAssertions;
using Microsoft.Extensions.Logging;
using Moq;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;
using Sibur.Digital.Svt.Nkhtk.Converter.Transformers;
using Xunit;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Tests.Transformers;

public class SheetMultiplierTransformerTests
{
    [Fact(DisplayName = "SheetMultiplierTransformer Apply On String Column.")]
    [Trait("Category", "Unit")]
    public void Can_Apply_String()
    {
        // Arrange
        var logger = Mock.Of<ILogger>();
        var (sourceExcel, targetExcel) = ExcelDecoratorHelper.GetSourceAndTargetExcels("NKHTK_SUG_Template_Test.xlsx");
        var targetWorksheet = targetExcel.Workbook.Worksheet(1);
        targetWorksheet.Cell("A4").Value = 1;
        targetWorksheet.Cell("A5").Value = 2;
        targetWorksheet.Cell("A6").Value = 3;
        targetWorksheet.Cell("B4").Value = "A";
        targetWorksheet.Cell("B5").Value = "B";
        targetWorksheet.Cell("B6").Value = "C";
        targetWorksheet.Cell("C5").Value = "XXX";
        ITransformer transformer = new SheetMultiplierTransformer(new RuleDto
        {
            DestinationColumn = "Product",
            RuleKind = RuleKind.SheetMultiplier,
            Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto>
            {
                new("Изобутан и его смеси"),
                new("Фракция пропиленовая")
            }),
            Mandatory = true
        }, logger);

        // Act
        transformer.Apply(sourceExcel, targetExcel);

        // Assert
        var resultCount = targetWorksheet.RowsUsed().Count();
        resultCount.Should().Be(9);

        targetWorksheet.Cell("A4").Value.Should().Be(1);
        targetWorksheet.Cell("A5").Value.Should().Be(2);
        targetWorksheet.Cell("A6").Value.Should().Be(3);
        targetWorksheet.Cell("A7").Value.Should().Be(1);
        targetWorksheet.Cell("A8").Value.Should().Be(2);
        targetWorksheet.Cell("A9").Value.Should().Be(3);
        targetWorksheet.Cell("A10").Value.Should().Be("");

        targetWorksheet.Cell("B4").Value.Should().Be("A");
        targetWorksheet.Cell("B5").Value.Should().Be("B");
        targetWorksheet.Cell("B6").Value.Should().Be("C");
        targetWorksheet.Cell("B7").Value.Should().Be("A");
        targetWorksheet.Cell("B8").Value.Should().Be("B");
        targetWorksheet.Cell("B9").Value.Should().Be("C");
        targetWorksheet.Cell("B10").Value.Should().Be("");

        targetWorksheet.Cell("C4").Value.Should().Be("");
        targetWorksheet.Cell("C5").Value.Should().Be("XXX");
        targetWorksheet.Cell("C6").Value.Should().Be("");
        targetWorksheet.Cell("C7").Value.Should().Be("");
        targetWorksheet.Cell("C8").Value.Should().Be("XXX");
        targetWorksheet.Cell("C9").Value.Should().Be("");

        targetWorksheet.Cell("BA4").Value.Should().Be("Изобутан и его смеси");
        targetWorksheet.Cell("BA5").Value.Should().Be("Изобутан и его смеси");
        targetWorksheet.Cell("BA6").Value.Should().Be("Изобутан и его смеси");
        targetWorksheet.Cell("BA7").Value.Should().Be("Фракция пропиленовая");
        targetWorksheet.Cell("BA8").Value.Should().Be("Фракция пропиленовая");
        targetWorksheet.Cell("BA9").Value.Should().Be("Фракция пропиленовая");
        targetWorksheet.Cell("BA10").Value.Should().Be("");
    }
}