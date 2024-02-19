using Microsoft.AspNetCore.Components;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.UI.Models;

namespace Sibur.Digital.Svt.Nkhtk.UI.Pages;

public sealed partial class NkhtkRates : Rates
{
    [Inject]
    private NkhtkFileModel NkhtkModel { get; set; } = default!;

    protected override FileModel Model => NkhtkModel;

    protected override async Task OnInitializedAsync()
        => await Model.LoadTemplates(TemplateType.Nkhtk);
}