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

public class SourceColumnCopyDictionaryOnlyTransformerTests
{
    [Fact(DisplayName = "SourceColumnCopyDictionaryOnlyTransformer Can erase values based on condition")]
    [Trait("Category", "Unit")]
    public void Can_Erase_Currency()
    {
        // Arrange
        var (sourceExcel, targetExcel) = ExcelDecoratorHelper.GetSourceAndTargetExcels("NKHTK_SUG_Template_Test.xlsx");
        var logger = Mock.Of<ILogger>();
        ITransformer copyTransformer = new SourceColumnCopyTransformer(new RuleDto
        {
            RuleKind = RuleKind.SourceColumnCopy,
            SourceEntity = new (new List<string> { "Тариф" }),
            DestinationColumn = "LoadedRFSize",
            Mandatory = true
        }, logger);

        ITransformer constantTransformer = new DestinationSheetConstantTransformer(new RuleDto
        {
            RuleKind = RuleKind.DestinationSheetConstant,
            DestinationColumn = "TEToCurrency",
            Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new("RUB") }),
            Mandatory = true
        }, logger);

        ITransformer eraseTransformer = new SourceColumnCopyDictionaryOnlyTransformer(new RuleDto
        {
            RuleKind = RuleKind.SourceColumnCopyDictionaryOnly,
            RuleOperator = RuleOperator.IsNull,
            SourceEntity = new RuleEntityDto(new List<string> { "ТЭ назнач." }),
            DestinationColumn = "TEToCurrency",
            Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto>
            {
                new("0.00", ""),
                new("0.0", ""),
                new("0", "")
            }),
            Mandatory = true
        }, logger);
        // копируем колонку с тарифами. После выполнения в результируеющем шаблоне будет 3 цифры
        copyTransformer.Apply(sourceExcel, targetExcel);
        // копируем колонку с валютой. После выполнения в результируеющем шаблоне будет 3 ячейки со значением "RUB"
        constantTransformer.Apply(sourceExcel, targetExcel);

        // Act
        // стираем значение "RUB" там, где "ТЭ назнач." нулевое
        eraseTransformer.Apply(sourceExcel, targetExcel);

        // Assert
        var targetWorksheet = targetExcel.Workbook.Worksheet(1);
        var resultCount = targetWorksheet.RowsUsed().Count();
        resultCount.Should().Be(6);

        targetWorksheet.Cell("U4").Value.Should().Be("RUB");
        targetWorksheet.Cell("U5").Value.Should().Be("");
        targetWorksheet.Cell("U6").Value.Should().Be("");
        targetWorksheet.Cell("U7").Value.Should().Be("");
    }
}