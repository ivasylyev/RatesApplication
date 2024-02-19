using Microsoft.AspNetCore.Components;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.UI.Models;

namespace Sibur.Digital.Svt.Nkhtk.UI.Pages;

public sealed partial class MultiModalRates : Rates
{
    [Inject]
    private MultiModalFileModel MultiModelModel { get; set; } = default!;

    protected override FileModel Model => MultiModelModel;

    protected override async Task OnInitializedAsync()
        => await Model.LoadTemplates(TemplateType.MultiModal);

    private void EffectiveLoadOfTransportTypeChanged(string? value)
        => MultiModelModel.EffectiveLoadOfTransportType = value;

    private void CurrencyChanged(string? value)
        => MultiModelModel.GeneralCurrency = value;

    private void ProductGroupChanged(string? value)
        => MultiModelModel.ProductGroup = value;

    private void ProductChanged(string? value)
        => MultiModelModel.Product = value;
}