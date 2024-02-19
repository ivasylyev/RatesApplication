using System.Collections.Generic;
using System.Linq;
using ClosedXML.Excel;
using FluentAssertions;
using Microsoft.Extensions.Logging;
using Moq;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.Converter.Transformers;
using Xunit;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Tests.Transformers;

public class SourceColumnCopyTransformerTests
{
    [Fact(DisplayName = "SourceColumnCopyTransformer Apply On Decimal Column.")]
    [Trait("Category", "Unit")]
    public void Can_Copy_Decimal()
    {
        // Arrange
        var (sourceExcel, targetExcel) = ExcelDecoratorHelper.GetSourceAndTargetExcels("NKHTK_SUG_Template_Test.xlsx");
        var logger = Mock.Of<ILogger>();
        var transformer = new SourceColumnCopyTransformer(new RuleDto
        {
            RuleKind = RuleKind.SourceColumnCopy,
            SourceEntity = new RuleEntityDto(new List<string> { "Тариф" }),
            DestinationColumn = "LoadedRFSize",
            Mandatory = true
        }, logger);

        // Act
        transformer.Apply(sourceExcel, targetExcel);

        // Assert
        var targetWorksheet = targetExcel.Workbook.Worksheet(1);
        var resultCount = targetWorksheet.RowsUsed().Count();
        resultCount.Should().Be(6);

        targetWorksheet.Cell("D4").Value.Should().Be(345.00);
        targetWorksheet.Cell("D5").Value.Should().Be(355.78);
        targetWorksheet.Cell("D6").Value.Should().Be(419.27);
        targetWorksheet.Cell("D7").Value.Should().Be("");
    }


    [Fact(DisplayName = "SourceColumnCopyTransformer Apply On String Column.")]
    [Trait("Category", "Unit")]
    public void Can_Copy_String()
    {
        // Arrange
        var (sourceExcel, targetExcel) = ExcelDecoratorHelper.GetSourceAndTargetExcels("NKHTK_SUG_Template_Test.xlsx");
        var logger = Mock.Of<ILogger>();
        var transformer = new SourceColumnCopyTransformer(new RuleDto
        {
            RuleKind = RuleKind.SourceColumnCopy,
            TreatMissingDictionaryValueAsError = true,
            SourceEntity = new RuleEntityDto(new List<string> { "Станция назначения" }),
            DestinationColumn = "NodeTo",
            Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto>
            {
                new("Осенцы", "R761602"),
                new("Химзаводская", "R637208"),
                new("Водинская", "R637803")
            }),
            Mandatory = true
        }, logger);

        // Act
        transformer.Apply(sourceExcel, targetExcel);

        // Assert
        var targetWorksheet = targetExcel.Workbook.Worksheet(1);
        var resultCount = targetWorksheet.RowsUsed().Count();
        resultCount.Should().Be(6);

        targetWorksheet.Cell("AV4").Value.Should().Be("R761602");
        targetWorksheet.Cell("AV5").Value.Should().Be("R637208");
        targetWorksheet.Cell("AV6").Value.Should().Be("Нет в словаре");
        targetWorksheet.Cell("AV7").Value.Should().Be("");

        // проверяем, что для отсутсвующих в словаре значений название колонки и само зотсутсвующее значение подкрашены
        targetWorksheet.Cell("AV3").Style.Fill.BackgroundColor.Should().Be(XLColor.Red);
        targetWorksheet.Cell("AV6").Style.Fill.BackgroundColor.Should().Be(XLColor.Red);
    }

    [Fact(DisplayName = "SourceColumnCopyTransformer ignores non-mandatory rule")]
    [Trait("Category", "Unit")]
    public void Ignore_Not_Mandatory_Rule()
    {
        // Arrange
        var (sourceExcel, targetExcel) = ExcelDecoratorHelper.GetSourceAndTargetExcels("NKHTK_SUG_Template_Test.xlsx");
        var logger = Mock.Of<ILogger>();
        var transformer = new SourceColumnCopyTransformer(new RuleDto
        {
            RuleKind = RuleKind.SourceColumnCopy,
            SourceEntity = new RuleEntityDto(new List<string> { "белиберда" }),
            DestinationColumn = "NodeTo",
            Mandatory = false
        }, logger);

        // Act
        var exception = Record.Exception(() => transformer.Apply(sourceExcel, targetExcel));

        // Assert
        exception.Should().BeNull();
    }

    [Fact(DisplayName = "SourceColumnCopyTransformer doesn't ignore non-mandatory rule")]
    [Trait("Category", "Unit")]
    public void Dont_Ignore_Not_Mandatory_Rule()
    {
        // Arrange
        var (sourceExcel, targetExcel) = ExcelDecoratorHelper.GetSourceAndTargetExcels("NKHTK_SUG_Template_Test.xlsx");
        var logger = Mock.Of<ILogger>();
        var transformer = new SourceColumnCopyTransformer(new RuleDto
        {
            RuleKind = RuleKind.SourceColumnCopy,
            SourceEntity = new RuleEntityDto(new List<string> { "белиберда" }),
            DestinationColumn = "NodeTo",
            Mandatory = true
        }, logger);

        // Act
        var exception = Record.Exception(() => transformer.Apply(sourceExcel, targetExcel));

        // Assert
        exception.Should().NotBeNull();
        exception?.Message.ToLower().Should().Contain("ни одно из имен колонок не найдено (белиберда)");
    }


    [Fact(DisplayName = "SourceColumnCopyTransformer Apply Transformation Chain with subtraction On Decimal Column")]
    [Trait("Category", "Unit")]
    public void Can_Copy_And_Sub_Decimal()
    {
        // Arrange
        var (sourceExcel, targetExcel) = ExcelDecoratorHelper.GetSourceAndTargetExcels("NKHTK_SUG_Template_Test.xlsx");
        var logger = Mock.Of<ILogger>();
        // Применяем первое преобразование - копирование из колонки НХТК "ВС со СЗ Реализация"
        // в колонку СВТ "EmptyRFSize"
        var copyTransformer = new SourceColumnCopyTransformer(new RuleDto
        {
            RuleKind = RuleKind.SourceColumnCopy,
            SourceEntity = new RuleEntityDto(new List<string> { "ВС со СЗ Реализация" }),
            DestinationColumn = "EmptyRFSize",
            Mandatory = true
        }, logger);

        // Применяем второе преобразование - вычитаение из колонки СВТ "EmptyRFSize"
        // Словарное значение, зависящее от "S, км" 
        var subTransformer = new SourceColumnCopyTransformer(new RuleDto
        {
            RuleKind = RuleKind.SourceColumnCopy,
            SourceEntity = new RuleEntityDto(new List<string> { "S, км" }),
            DestinationColumn = "EmptyRFSize",
            Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto>
            {
                new("5", "635"),
                new("8", "635"),
                new("41", "693")
            }),
            RuleOperator = RuleOperator.Minus,
            Mandatory = true
        }, logger);

        // Act
        copyTransformer.Apply(sourceExcel, targetExcel);
        subTransformer.Apply(sourceExcel, targetExcel);

        // Assert
        var targetWorksheet = targetExcel.Workbook.Worksheet(1);
        var resultCount = targetWorksheet.RowsUsed().Count();
        resultCount.Should().Be(6);

        targetWorksheet.Cell("H4").Value.Should().Be(2.00); // 637 - 635
        targetWorksheet.Cell("H5").Value.Should().Be(7.00); // 642 - 635
        targetWorksheet.Cell("H6").Value.Should().Be(35.00); // 728 - 693
        targetWorksheet.Cell("H7").Value.Should().Be("");
    }

    [Fact(DisplayName = "SourceColumnCopyTransformer Throws ExcelColumnNotFoundException.")]
    [Trait("Category", "Unit")]
    public void Throws_Exception_If_Column_Not_Found()
    {
        // Arrange
        var (sourceExcel, targetExcel) = ExcelDecoratorHelper.GetSourceAndTargetExcels("NKHTK_SUG_Template_Test.xlsx");
        var logger = Mock.Of<ILogger>();
        var transformer = new SourceColumnCopyTransformer(new RuleDto
        {
            RuleKind = RuleKind.SourceColumnCopy,
            TreatMissingDictionaryValueAsError = true,
            SourceEntity = new RuleEntityDto(new List<string> { "абра-кадабра", "сим-салабим" }),
            DestinationColumn = "abc",
            Mandatory = true
        }, logger);

        // Act
        var exception = Record.Exception(() => transformer.Apply(sourceExcel, targetExcel));

        // Assert
        exception.Should().NotBeNull();
        exception?.Message.ToLower().Should().Contain("ни одно из имен колонок не найдено (абра-кадабра, сим-салабим)");
    }

    [Fact(DisplayName = "SourceColumnCopyTransformer Throws ExcelAmbiguousColumnException.")]
    [Trait("Category", "Unit")]
    public void Throws_Exception_If_Multiple_Columns_Are_Found()
    {
        // Arrange
        var (sourceExcel, targetExcel) = ExcelDecoratorHelper.GetSourceAndTargetExcels("NKHTK_SUG_Template_Test.xlsx");
        var logger = Mock.Of<ILogger>();
        var transformer = new SourceColumnCopyTransformer(new RuleDto
        {
            RuleKind = RuleKind.SourceColumnCopy,
            TreatMissingDictionaryValueAsError = true,
            SourceEntity = new RuleEntityDto(new List<string> { "7", "8" }),
            DestinationColumn = "abc",
            Mandatory = true
        }, logger);

        // Act
        var exception = Record.Exception(() => transformer.Apply(sourceExcel, targetExcel));

        // Assert
        exception.Should().NotBeNull();
        exception?.Message.Should().Contain("Должна быть только одна колонка с одним из данных имен: ('7' по адресу 'L1', '7' по адресу 'M1', '8' по адресу 'G1', '8' по адресу 'J1', '8' по адресу 'K1', '8' по адресу 'C11')");
    }
}