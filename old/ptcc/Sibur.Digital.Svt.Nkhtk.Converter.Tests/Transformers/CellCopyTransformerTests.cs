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

public class CellCopyTransformerTests
{
    [Fact(DisplayName = "CellCopyTransformer Apply On Decimal Cell - horizontal header")]
    [Trait("Category", "Unit")]
    public void Can_Copy_Horisontal_Decimal()
    {
        // Arrange
        var (sourceExcel, targetExcel) = ExcelDecoratorHelper.GetSourceAndTargetExcels("NKHTK_SUG_Template_Test.xlsx");
        var logger = Mock.Of<ILogger>();
        var targetWorksheet = targetExcel.Workbook.Worksheet(1);
        targetWorksheet.Cell("A4").Value = 1;
        targetWorksheet.Cell("A5").Value = 2;

        ITransformer transformer = new CellCopyTransformer(new RuleDto
        {
            RuleKind = RuleKind.HorizontalCellCopy,
            SourceEntity = new RuleEntityDto(new List<string> { "загрузка" }),
            DestinationColumn = "EffectiveLoadOfTransportType",
            Mandatory = true
        }, logger);

        // Act
        transformer.Apply(sourceExcel, targetExcel);

        // Assert

        var resultCount = targetWorksheet.RowsUsed().Count();
        resultCount.Should().Be(5);

        targetWorksheet.Cell("AY4").Value.Should().Be(36.82);
        targetWorksheet.Cell("AY5").Value.Should().Be(36.82);
        targetWorksheet.Cell("AY6").Value.Should().Be("");
    }

    [Fact(DisplayName = "CellCopyTransformer Apply On Decimal Cell - vertical header")]
    [Trait("Category", "Unit")]
    public void Can_Copy_Vertical_Decimal()
    {
        // Arrange
        var logger = Mock.Of<ILogger>();
        var (sourceExcel, targetExcel) = ExcelDecoratorHelper.GetSourceAndTargetExcels("NKHTK_SUG_Template_Test.xlsx");

        var targetWorksheet = targetExcel.Workbook.Worksheet(1);
        targetWorksheet.Cell("A4").Value = 1;
        targetWorksheet.Cell("A5").Value = 2;

        ITransformer transformer = new CellCopyTransformer(new RuleDto
        {
            RuleKind = RuleKind.VerticalCellCopy,
            SourceEntity = new RuleEntityDto(new List<string> { "Код позиции ЕТСНГ" }),
            DestinationColumn = "ETSNGCode",
            Mandatory = true
        }, logger);

        // Act
        transformer.Apply(sourceExcel, targetExcel);

        // Assert

        var resultCount = targetWorksheet.RowsUsed().Count();
        resultCount.Should().Be(5);

        targetWorksheet.Cell("C4").Value.Should().Be(226);
        targetWorksheet.Cell("C5").Value.Should().Be(226);
        targetWorksheet.Cell("C6").Value.Should().Be("");
    }


    [Fact(DisplayName = "CellCopyTransformer ignores non-mandatory rule")]
    [Trait("Category", "Unit")]
    public void Ignore_Not_Mandatory_Rule()
    {
        // Arrange
        var logger = Mock.Of<ILogger>();
        var (sourceExcel, targetExcel) = ExcelDecoratorHelper.GetSourceAndTargetExcels("NKHTK_SUG_Template_Test.xlsx");

        var targetWorksheet = targetExcel.Workbook.Worksheet(1);
        targetWorksheet.Cell("A4").Value = 1;
        targetWorksheet.Cell("A5").Value = 2;

        ITransformer transformer = new CellCopyTransformer(new RuleDto
        {
            RuleKind = RuleKind.VerticalCellCopy,
            SourceEntity = new RuleEntityDto(new List<string> { "белиберда" }),
            DestinationColumn = "ETSNGCode",
            Mandatory = false
        }, logger);

        // Act
        var exception = Record.Exception(() => transformer.Apply(sourceExcel, targetExcel));

        // Assert
        exception.Should().BeNull();
    }

    [Fact(DisplayName = "CellCopyTransformer doesn't ignore non-mandatory rule")]
    [Trait("Category", "Unit")]
    public void Dont_Ignore_Not_Mandatory_Rule()
    {
        // Arrange
        var logger = Mock.Of<ILogger>();
        var (sourceExcel, targetExcel) = ExcelDecoratorHelper.GetSourceAndTargetExcels("NKHTK_SUG_Template_Test.xlsx");

        var targetWorksheet = targetExcel.Workbook.Worksheet(1);
        targetWorksheet.Cell("A4").Value = 1;
        targetWorksheet.Cell("A5").Value = 2;

        ITransformer transformer = new CellCopyTransformer(new RuleDto
        {
            RuleKind = RuleKind.VerticalCellCopy,
            SourceEntity = new RuleEntityDto(new List<string> { "белиберда" }),
            DestinationColumn = "ETSNGCode",
            Mandatory = true
        }, logger);

        // Act
        var exception = Record.Exception(() => transformer.Apply(sourceExcel, targetExcel));

        // Assert
        exception.Should().NotBeNull();
        exception?.Message.ToLower().Should().Contain("ни одно из имен колонок не найдено (белиберда)");
    }
}