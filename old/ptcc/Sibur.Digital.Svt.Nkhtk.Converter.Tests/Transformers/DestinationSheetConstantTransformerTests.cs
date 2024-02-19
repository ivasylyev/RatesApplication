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

public class DestinationSheetConstantTransformerTests
{

    [Fact(DisplayName = "Destination ConstantTransformerApply On String Column.")]
    [Trait("Category", "Unit")]
    public void Can_Apply_String()
    {
        // Arrange
        var logger = Mock.Of<ILogger>();
        var (sourceExcel, targetExcel) = ExcelDecoratorHelper.GetSourceAndTargetExcels("NKHTK_SUG_Template_Test.xlsx");

        var targetWorksheet = targetExcel.Workbook.Worksheet(1);
        targetWorksheet.Cell("A4").Value = 1;
        targetWorksheet.Cell("A5").Value = 2;

        ITransformer transformer = new DestinationSheetConstantTransformer(new RuleDto
        {
            RuleKind = RuleKind.DestinationSheetConstant,
            Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("RUB") }),
            DestinationColumn = "EmptyRFCurrency",
            Mandatory = true
        }, logger);

        // Act
        transformer.Apply(sourceExcel, targetExcel);

        // Assert
        var resultCount = targetWorksheet.RowsUsed().Count();
        resultCount.Should().Be(5);

        targetWorksheet.Cell("I4").Value.Should().Be("RUB");
        targetWorksheet.Cell("I5").Value.Should().Be("RUB");
        targetWorksheet.Cell("I6").Value.Should().Be("");
    }

    [Fact(DisplayName = "Destination  ConstantTransformerApply On String Column with Concat operator.")]
    [Trait("Category", "Unit")]
    public void Can_Concat_String()
    {
        // Arrange
        var logger = Mock.Of<ILogger>();
        var (sourceExcel, targetExcel) = ExcelDecoratorHelper.GetSourceAndTargetExcels("MM_Sea_Land_Template_Test.xlsx");

        var targetWorksheet = targetExcel.Workbook.Worksheet(1);
        targetWorksheet.Cell("AJ4").Value = 1;
        targetWorksheet.Cell("AJ5").Value = 2;

        ITransformer transformer = new DestinationSheetConstantTransformer(new RuleDto
        {
            RuleKind = RuleKind.DestinationSheetConstant,
            Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("NewString") }),
            DestinationColumn = "RateTenderServicePack",
            RuleOperator = RuleOperator.Concat,
            Mandatory = true
        }, logger);

        // Act
        transformer.Apply(sourceExcel, targetExcel);

        // Assert
        // Проверяем, что скопировалось 2 константы, т.к. в результирующем шаблоне мы вставили ранее 2 строки
        var resultCount = targetWorksheet.RowsUsed().Count();
        resultCount.Should().Be(5);

        targetWorksheet.Cell("AJ4").Value.Should().Be("1NewString");
        targetWorksheet.Cell("AJ5").Value.Should().Be("2NewString");
        targetWorksheet.Cell("AJ6").Value.Should().Be("");
    }

    
}