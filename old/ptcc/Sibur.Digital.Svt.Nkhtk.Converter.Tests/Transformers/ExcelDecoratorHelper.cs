using System.IO;
using Microsoft.Extensions.Logging;
using Moq;
using Sibur.Digital.Svt.Infrastructure.Utils;
using Sibur.Digital.Svt.Nkhtk.Converter.DataProviders;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Tests.Transformers;

public static class ExcelDecoratorHelper
{
    public static (ExcelDecorator, ExcelDecorator) GetSourceAndTargetExcels(string templateFile)
    {
        var (sourceExcel, _, targetExcel, _) = GetSourceAndTargetExcelsWithStreams(templateFile);
        return (sourceExcel, targetExcel);
    }

    public static (ExcelDecorator, Stream, ExcelDecorator, Stream) GetSourceAndTargetExcelsWithStreams(string templateFile)
    {
        var logger = Mock.Of<ILogger<IExcelDecorator>>();
        var sourceProvider = new FileProvider();
        var sourceStream = sourceProvider.GetFileStream(templateFile);
        var sourceExcel = new ExcelDecorator(logger);
        sourceExcel.Load(sourceStream, 1 ,"Тариф");

        var targetProvider = new FileProvider();
        var targetStream = targetProvider.GetFileStream("SVT_Template_test.xlsx");
        var targetExcel = new ExcelDecorator(logger);
        targetExcel.Load(targetStream, 1, "Code");
        return (sourceExcel, sourceStream, targetExcel, targetStream);
    }
}