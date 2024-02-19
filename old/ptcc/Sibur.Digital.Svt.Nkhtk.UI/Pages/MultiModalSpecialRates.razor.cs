using Microsoft.AspNetCore.Components;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.UI.Models;

namespace Sibur.Digital.Svt.Nkhtk.UI.Pages;

public sealed partial class MultiModalSpecialRates : Rates
{
    [Inject]
    private MultiModalSpecialFileModel MultiModalModel { get; set; } = default!;

    protected override FileModel Model => MultiModalModel;

    protected override async Task OnInitializedAsync()
        => await Model.LoadTemplates(TemplateType.MultiModalSpecial);

    private void EffectiveLoadOfTransportTypeChanged(string? value)
        => MultiModalModel.EffectiveLoadOfTransportType = value;

    private void CurrencyChanged(string? value)
        => MultiModalModel.CurrencyStandard = value;

    private void ProductGroupChanged(string? value)
        => MultiModalModel.ProductGroup = value;

    private void ProductChanged(string? value)
        => MultiModalModel.Product = value;

    private void BasisChanged(string? value)
        => MultiModalModel.Basis = value;
}