using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Infrastructure.Utils;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Services;

/// <summary>
///     <see cref="ISvtTemplateService" />
/// </summary>
/// <remarks>
/// Это временное решение, загружающее файл прямо с диска.
/// Постояное решение должно интегрироваться с СВТ и получать оттуда актуальный шаблон
/// </remarks>
public class HddSvtTemplateService : ISvtTemplateService
{
    /// <inheritdoc />
    public int ExcelWorksheetIndex => 1;

    /// <inheritdoc />
    public string FirstColumnName => "Code";

    /// <inheritdoc />
    public Stream GetTemplateFileStream(TemplateType templateType)
    {
        var fileProvider = new FileProvider();
        var templateName = GetTemplateName(templateType);

        var stream = fileProvider.GetFileStream(templateName);
        return stream;
    }

    private static string GetTemplateName(TemplateType templateType) =>
        templateType switch
        {
            TemplateType.Nkhtk => "TransportRateTemplate.xlsx",
            TemplateType.MultiModal => "TransportRateTemplate.xlsx",
            TemplateType.MultiModalSpecial => "MultiModal_SpecialRateTemplate.xlsx",
            _ => throw new NotImplementedException($"Template {templateType} is not implemented.")
        };
}