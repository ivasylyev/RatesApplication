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

public class SourceSheetConstantTransformerTests
{
    [Fact(DisplayName = "Source ConstantTransformerApply On String Column.")]
    [Trait("Category", "Unit")]
    public void Can_Apply_String()
    {
        // Arrange
        var logger = Mock.Of<ILogger>();
        var (sourceExcel, targetExcel) = ExcelDecoratorHelper.GetSourceAndTargetExcels("NKHTK_SUG_Template_Test.xlsx");
        var targetWorksheet = targetExcel.Workbook.Worksheet(1);


        ITransformer transformer = new SourceSheetConstantTransformer(new RuleDto
        {
            RuleKind = RuleKind.SourceSheetConstant,
            Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("RUB") }),
            DestinationColumn = "EmptyRFCurrency",
            Mandatory = true
        }, logger);

        // Act
        transformer.Apply(sourceExcel, targetExcel);

        // Assert
        // Проверяем, что скопировалось 3 константы, т.к. в исходном шаблоне три строки с данными.
        var resultCount = targetWorksheet.RowsUsed().Count();

        // три строки заголовка + три строки с данными
        resultCount.Should().Be(3 + 3);

        targetWorksheet.Cell("I4").Value.Should().Be("RUB");
        targetWorksheet.Cell("I5").Value.Should().Be("RUB");
        targetWorksheet.Cell("I6").Value.Should().Be("RUB");
        targetWorksheet.Cell("I7").Value.Should().Be("");
    }

    [Fact(DisplayName = "Source ConstantTransformerApply Ignores Hidden Columns.")]
    [Trait("Category", "Unit")]
    public void Can_Ignore_Hidden_String()
    {
        // Arrange
        var logger = Mock.Of<ILogger>();
        var (sourceExcel, targetExcel) = ExcelDecoratorHelper.GetSourceAndTargetExcels("NKHTK_SUG_Template_Test.xlsx");
        var targetWorksheet = targetExcel.Workbook.Worksheet(1);
        var sourceWorksheet = sourceExcel.Workbook.Worksheet(1);
        sourceWorksheet.Row(11).Hide();

        ITransformer transformer = new SourceSheetConstantTransformer(new RuleDto
        {
            RuleKind = RuleKind.SourceSheetConstant,
            Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("RUB") }),
            DestinationColumn = "EmptyRFCurrency",
            Mandatory = true
        }, logger);

        // Act
        transformer.Apply(sourceExcel, targetExcel);

        // Assert
        // Проверяем, что скопировалось 2 константы, т.к. в исходном шаблоне три строки с данными, одна из которых скрыта
        var resultCount = targetWorksheet.RowsUsed().Count();
        // три строки заголовка + две строки с данными
        resultCount.Should().Be(3 + 2);

        targetWorksheet.Cell("I4").Value.Should().Be("RUB");
        targetWorksheet.Cell("I5").Value.Should().Be("RUB");
        targetWorksheet.Cell("I6").Value.Should().Be("");
    }
}