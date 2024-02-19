using Microsoft.AspNetCore.Components;
using Sibur.Digital.Svt.Nkhtk.UI.Models;

namespace Sibur.Digital.Svt.Nkhtk.UI.Components;

/// <summary>
/// Обертка над компонентом с выпадающим списком
/// </summary>
public sealed partial class SvtInputSelect : SvtInput
{
    /// <summary>
    /// Элементы выпадающего списка
    /// </summary>
    [Parameter]
    public List<SvtSelectListItem> Items { get; set; } = new();

    /// <summary>
    /// Выбранное значение выпадающего списка
    /// </summary>
    [Parameter]
    public int Value { get; set; }

    /// <summary>
    /// Делегат для обработчика изменения выпадающего списка
    /// </summary>
    [Parameter]
    public EventCallback<int> ValueChanged { get; set; }

    protected override bool Valid
        => !Required || Value != 0;

    protected override string CustomCssClass => "form-select";

    private async Task OnValueChanged(int value)
    {
        Value = value;
        await ValueChanged.InvokeAsync(Value);
    }
}