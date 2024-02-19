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

public class DestinationColumnCopyTransformerTests
{
    [Fact(DisplayName = "DestinationColumnCopyTransformer Apply On String Column.")]
    [Trait("Category", "Unit")]
    public void Can_Copy_String()
    {
        // Arrange
        var logger = Mock.Of<ILogger>();
        var (sourceExcel, targetExcel) = ExcelDecoratorHelper.GetSourceAndTargetExcels("NKHTK_SUG_Template_Test.xlsx");
        var targetWorksheet = targetExcel.Workbook.Worksheet(1);
        targetWorksheet.Cell("BA4").Value = "1088401";
        targetWorksheet.Cell("BA5").Value = "496076";
        ITransformer transformer = new DestinationColumnCopyTransformer(new RuleDto
        {
            RuleKind = RuleKind.DestinationColumnCopy,
            DestinationColumn = "ProductGroup",
            SourceEntity = new RuleEntityDto(new List<string> { "Product" }),
            Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto>
            {
                new("1088401", "T6"),
                new("726073", "T26"),
                new("496076", "T19")
            }),
            Mandatory = true
        }, logger);

        // Act
        transformer.Apply(sourceExcel, targetExcel);

        // Assert
        var resultCount = targetWorksheet.RowsUsed().Count();
        resultCount.Should().Be(5);

        targetWorksheet.Cell("AZ4").Value.Should().Be("T6");
        targetWorksheet.Cell("AZ5").Value.Should().Be("T19");
        targetWorksheet.Cell("AV6").Value.Should().Be("");
    }
}