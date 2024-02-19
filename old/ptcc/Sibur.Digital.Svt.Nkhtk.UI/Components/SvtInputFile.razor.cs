using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Forms;

namespace Sibur.Digital.Svt.Nkhtk.UI.Components;

/// <summary>
/// Обертка над компонентом для закачивания файла
/// </summary>
public sealed partial class SvtInputFile : SvtInput
{
    [Parameter]
    public IBrowserFile? File { get; set; }

    [Parameter]
    public EventCallback<IBrowserFile> FileChanged { get; set; }

    protected override bool Valid
        => !Required || File is not null;

    private async Task OnFileChanged(InputFileChangeEventArgs e)
    {
        File = e.File;
        await FileChanged.InvokeAsync(File);
    }
}