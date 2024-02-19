using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Components;

namespace Sibur.Digital.Svt.Nkhtk.UI.Components;

/// <summary>
/// Обертка над компонентом для ввода текста
/// </summary>
public sealed partial class SvtInputText : SvtInput
{
    /// <summary>
    /// Текущее значение введенного текста
    /// </summary>
    [Parameter]
    [Required]
    public string? Value { get; set; }

    /// <summary>
    /// Делегат для обработчика изменения введенного текста
    /// </summary>
    [Parameter]
    public EventCallback<string?> ValueChanged { get; set; }

    protected override bool Valid
        => !Required || !string.IsNullOrEmpty(Value);

    private async Task OnValueChanged(string? value)
    {
        Value = value;
        await ValueChanged.InvokeAsync(Value);
    }
}