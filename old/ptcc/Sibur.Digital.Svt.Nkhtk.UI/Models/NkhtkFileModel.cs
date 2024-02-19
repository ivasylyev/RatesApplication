using Microsoft.Extensions.Options;
using Sibur.Digital.Svt.Nkhtk.UI.Config;
using Sibur.Digital.Svt.Nkhtk.UI.Services;

namespace Sibur.Digital.Svt.Nkhtk.UI.Models;

public class NkhtkFileModel : FileModel
{
    public NkhtkFileModel(IOptions<UiOptions> options,
        ConverterService converterService, TemplateService templateService, WorksheetService worksheetService,
        ILogger<FileModel> logger)
        : base(options, converterService, templateService, worksheetService, logger)
    {
    }

    private DateTime CurrencyRateMonth { get; } = DateTime.Today;

    public override string GetUrlParameters()
        => $"{base.GetUrlParameters()}&currencyRateMonth={CurrencyRateMonth.ToString(DateFormat)}";
}