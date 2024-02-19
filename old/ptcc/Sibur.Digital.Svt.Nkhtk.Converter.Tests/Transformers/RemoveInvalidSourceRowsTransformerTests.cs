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

public class RemoveInvalidSourceRowsTransformerTests
{
    [Fact(DisplayName = "RemoveInvalidSourceRowsTransformerTests Apply")]
    [Trait("Category", "Unit")]
    public void Can_Remove_Invalid_Rows()
    {
        // Arrange
        var (sourceExcel, targetExcel) = ExcelDecoratorHelper.GetSourceAndTargetExcels("MM_Sea_Land_Template_Test_999999.xlsx");
        var logger = Mock.Of<ILogger>();
        var sourceWorksheet = sourceExcel.Workbook.Worksheet(1);
        var initialCount = sourceWorksheet.RowsUsed().Count(r=>!r.IsHidden);

        ITransformer transformer = new DeleteInvalidSourceRowsTransformer(new RuleDto
        {
            RuleKind = RuleKind.SourceSheetDeleteRows,
            SourceEntity = new RuleEntityDto(new List<string>
            {
                "Стоимость  ЖД перевозки по территории РФ включая все расходы  Перевозчика.в USD/ктк (Цена) (Цена)",
                "Стоимость морской перевозки, включая экспедирование в порту РФ, USD/ктк (Цена) (Цена)"
            }),
            Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto>
            {
                new("99", ""),
                new("999", ""),
                new("9999", ""),
                new("99999", ""),
                new("999999", ""),
                new("9999999", ""),
                new("99999999", "")
            }),
            DestinationColumn = "TotalCostTransport",
            Mandatory = true
        }, logger);

        // Act
        transformer.Apply(sourceExcel, targetExcel);

        // Assert
        // Проверяем, что вначале было 5 строк заоловка и 5 строк с данными
        initialCount.Should().Be(5 + 5);
        var resultCount = sourceWorksheet.RowsUsed().Count(r => !r.IsHidden);
        // Проверяем, что преобразователь удалил 2 строки с данными, содержащие девятки (то есть, невалидные строки)
        resultCount.Should().Be(5 + 5 - 2);
    }
}