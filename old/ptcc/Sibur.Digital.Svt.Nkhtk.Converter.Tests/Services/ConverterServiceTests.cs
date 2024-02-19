using System;
using System.Diagnostics.CodeAnalysis;
using System.IO;
using System.Net.Http;
using System.Threading.Tasks;
using ClosedXML.Excel;
using FluentAssertions;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Moq;
using Newtonsoft.Json;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.Converter.DataProviders;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;
using Sibur.Digital.Svt.Nkhtk.Converter.Model;
using Sibur.Digital.Svt.Nkhtk.Converter.Services;
using Sibur.Digital.Svt.Nkhtk.Converter.Tests.Transformers;
using Xunit;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Tests.Services;

public class ConverterServiceTests
{
    [Fact(DisplayName = "Transformation Chain - verify all transformations at once")]
    [Trait("Category", "Unit")]
    public async Task Can_Run_Converter()
    {
        // Arrange
        var (converter, sourceStream, parameters) = await ArrangeConverterAsync(1,"Ставки", 1001, "NKHTK_SUG_Template_Test.xlsx");

        // Act
        var targetStream = await converter.ConvertFileAsync(parameters, sourceStream);

        // Assert
        var workbook = new XLWorkbook(targetStream);
        var targetWorksheet = workbook.Worksheet(1);

        // LoadedRFSize
        // Тариф + охрана
        targetWorksheet.Cell("D4").Value.Should().Be(Math.Round(345.00 + 75.07, 2));
        targetWorksheet.Cell("D5").Value.Should().Be(Math.Round(355.78 + 75.07, 2));
        targetWorksheet.Cell("D6").Value.Should().Be(Math.Round(419.27 + 75.07, 2));
        targetWorksheet.Cell("D7").Value.Should().Be(Math.Round(345.00 + 75.07, 2));
        targetWorksheet.Cell("D8").Value.Should().Be(Math.Round(355.78 + 75.07, 2));
        targetWorksheet.Cell("D9").Value.Should().Be(Math.Round(419.27 + 75.07, 2));

        for (var rowIndex = 4; rowIndex < 10; rowIndex++)
        {
            //LoadedRFCurrency
            targetWorksheet.Cell($"E{rowIndex}").Value.Should().Be("RUB");
            //EmptyRFCurrency
            targetWorksheet.Cell($"I{rowIndex}").Value.Should().Be("RUB");
            //ProvisionTransportCurrency
            targetWorksheet.Cell($"M{rowIndex}").Value.Should().Be("RUB");

            // Проверяем, что ячейки содержат валюту там, где есть соответсвующая цена
            var dependentCurrency = rowIndex == 4 || rowIndex == 7 || rowIndex == 10
                ? "RUB"
                : string.Empty;

            //TEFromCurrency
            targetWorksheet.Cell($"Q{rowIndex}").Value.Should().Be(dependentCurrency);
            //PNPFromCurrency
            targetWorksheet.Cell($"S{rowIndex}").Value.Should().Be(dependentCurrency);
            //TEToCurrency
            targetWorksheet.Cell($"U{rowIndex}").Value.Should().Be(dependentCurrency);
            //PNPToCurrency
            targetWorksheet.Cell($"W{rowIndex}").Value.Should().Be(dependentCurrency);
        }

        //EmptyRFSize
        targetWorksheet.Cell("H4").Value.Should().Be(2.00); // 637 - 635
        targetWorksheet.Cell("H5").Value.Should().Be(7.00); // 642 - 635
        targetWorksheet.Cell("H6").Value.Should().Be(35.00); // 728 - 693
        targetWorksheet.Cell("H7").Value.Should().Be(2.00); // 637 - 635
        targetWorksheet.Cell("H8").Value.Should().Be(7.00); // 642 - 635
        targetWorksheet.Cell("H9").Value.Should().Be(35.00); // 728 - 693

        //TEFromSize
        // проверяем, что число округлено до 2-х знаков
        targetWorksheet.Cell("P4").Value.Should().Be(60.12);
        // проверяем, что отработало правило, которое вместо нуля подставляет пустое значение
        targetWorksheet.Cell("P5").Value.Should().Be("");
        targetWorksheet.Cell("P6").Value.Should().Be("");
        targetWorksheet.Cell("P7").Value.Should().Be(60.12);
        targetWorksheet.Cell("P8").Value.Should().Be("");
        targetWorksheet.Cell("P9").Value.Should().Be("");

        //TEFromCurrency
        // проверяем, что число округлено до 2-х знаков
        targetWorksheet.Cell("Q4").Value.Should().Be("RUB");
        // проверяем, что отработало правило, подставляет пустое значение вместо валюты, если TEFromSize равно нулю
        targetWorksheet.Cell("Q5").Value.Should().Be("");
        targetWorksheet.Cell("Q6").Value.Should().Be("");
        targetWorksheet.Cell("Q7").Value.Should().Be("RUB");
        targetWorksheet.Cell("Q8").Value.Should().Be("");
        targetWorksheet.Cell("Q9").Value.Should().Be("");
    }


    [Fact(DisplayName = "Load SVT template worksheets from NB")]
    [Trait("Category", "Unit")]
    public async Task Converter_Gets_SVT_Template_Worksheets_From_NB()
    {
        // Arrange
        var (converter, sourceStream, _) = await ArrangeConverterAsync(1, "Ставки", 1001, "NKHTK_NB_Template_Test.xlsx");
        IFormFile file = new FormFile(sourceStream, 0, sourceStream.Length, "file.xlsx", "file.xlsx");
        // Act
        var names = converter.GetWorksheetNames(file);

        // Assert
        names.Should().NotBeNullOrEmpty();
        names.Count.Should().Be(7);
        names.Contains("Ставки").Should().BeTrue();
        names.Contains("Ставки со скидкой на 720 км").Should().BeTrue();
        names.Contains("МТБЭ Сургут").Should().BeTrue();
        names.Contains("МТБЭ Сахалин МАЙ 2022").Should().BeTrue();
        names.Contains("Стирол").Should().BeTrue();
        names.Contains("Гликоли").Should().BeTrue();
        names.Contains("Гликоли КЛН  МАЙ").Should().BeTrue();
    }

    [Fact(DisplayName = "Transformation Chain - create SVT template from SUG-1")]
    [Trait("Category", "Integration")]
    [ExcludeFromCodeCoverage]
    public async Task Converter_Creates_SVT_Template_From_SUG()
    {
        // Arrange
        var (converter, sourceStream, parameters) = await ArrangeConverterAsync(1, "Ставки", 1001, "NKHTK_SUG_Template_Test.xlsx");

        // Act
        var targetStream = await converter.ConvertFileAsync(parameters, sourceStream);

        // no assert, just creating a file to check it out manually
        await using var file = new FileStream("SUG-ConverterServiceTests-1001.xlsx", FileMode.Create, FileAccess.Write);
        await targetStream.CopyToAsync(file);
    }

    [Fact(DisplayName = "Transformation Chain - create SVT template from NB-1 Rates")]
    [Trait("Category", "Integration")]
    [ExcludeFromCodeCoverage]
    public async Task Converter_Creates_SVT_Template_From_NB_1_Rates()
    {
        // Arrange
        var (converter, sourceStream, parameters) = await ArrangeConverterAsync(1,"Ставки", 6001, "NKHTK_NB_Template_Test.xlsx");

        // Act
        var targetStream = await converter.ConvertFileAsync(parameters, sourceStream);

        // no assert, just creating a file to check it out manually
        await using var file = new FileStream("NB-ConverterServiceTests-6001.xlsx", FileMode.Create, FileAccess.Write);
        await targetStream.CopyToAsync(file);
    }

    [Fact(DisplayName = "Transformation Chain - create SVT template from NB-1 Rates")]
    [Trait("Category", "Integration")]
    [ExcludeFromCodeCoverage]
    public async Task Converter_Creates_SVT_Template_From_NB_1_Sachkalin()
    {
        // Arrange
        var (converter, sourceStream, parameters) = await ArrangeConverterAsync(4,"МТБЭ Сахалин", 6004, "NKHTK_NB_Template_Test.xlsx");

        // Act
        var targetStream = await converter.ConvertFileAsync(parameters, sourceStream);

        // no assert, just creating a file to check it out manually
        await using var file = new FileStream("NB-ConverterServiceTests-6004.xlsx", FileMode.Create, FileAccess.Write);
        await targetStream.CopyToAsync(file);
    }

    [Fact(DisplayName = "Transformation Chain - create SVT template from SUG-3 Rates")]
    [Trait("Category", "Integration")]
    [ExcludeFromCodeCoverage]
    public async Task Converter_Creates_SVT_Template_From_SUG_3()
    {
        // Arrange
        var (converter, sourceStream, parameters) = await ArrangeConverterAsync(1,"Ставки", 3201, "NKHTK_SUG_Propilen_Template_Test.xlsx");

        // Act
        var targetStream = await converter.ConvertFileAsync(parameters, sourceStream);

        // no assert, just creating a file to check it out manually
        await using var file = new FileStream("SUG-ConverterServiceTests-4003.xlsx", FileMode.Create, FileAccess.Write);
        await targetStream.CopyToAsync(file);
    }

    private static async Task<(ConverterService, Stream, TemplateParameters)> ArrangeConverterAsync(int excelIndex, string worksheetName, int worksheetId, string templateFile)
    {
        var ruleRepository = new HardcodedRuleRepository();
        var rules = await ruleRepository.GetRulesAsync(worksheetId);
        var responseMessage = new HttpResponseMessage { Content = new StringContent(JsonConvert.SerializeObject(rules)) };

        var httpClient = new Mock<IHttpDecorator>(MockBehavior.Strict);
        httpClient.Setup(c => c.GetAsync(It.IsAny<Uri>()))
            .Returns(() => Task.FromResult(responseMessage));
        httpClient.Setup(c => c.Dispose());

        using var provider = new ApiDataProvider(httpClient.Object, ConfigurationHelper.Options);
        var hardcodedRuleService = new RuleService(provider, ConfigurationHelper.Options);

        var (sourceExcel, sourceStream, targetExcel, _) = ExcelDecoratorHelper.GetSourceAndTargetExcelsWithStreams(templateFile);
        var templateService = new HddSvtTemplateService();
        var transformerLogger = Mock.Of<ILogger<ITransformerService>>();
        var transformerService = new TransformerService(transformerLogger);
        var converterLogger = Mock.Of<ILogger<IConverterService>>();
        var converter = new ConverterService(sourceExcel, targetExcel, templateService, transformerService, hardcodedRuleService, converterLogger);
        var parameters = new TemplateParameters()
            {
                ExcelWorksheetIndex = excelIndex,
                TemplateWorksheetId = worksheetId,
                TemplateWorksheetName = worksheetName,
                StartDate = DateTime.Today,
                EndDate = DateTime.Today.AddMonths(1),
                TemplateTypeId = (int)TemplateType.Nkhtk
            };
        return (converter, sourceStream, parameters);
    }
}