using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Components;

namespace Sibur.Digital.Svt.Nkhtk.UI.Components;

/// <summary>
/// Обертка над компонентом для ввода даты (календарем)
/// </summary>
public sealed partial class SvtInputDate : SvtInput
{
    /// <summary>
    /// Текущее значение даты
    /// </summary>
    [Parameter]
    [Required]
    public DateTime? Value { get; set; }

    /// <summary>
    /// Делегат для обработчика изменения даты
    /// </summary>
    [Parameter]
    public EventCallback<DateTime?> ValueChanged { get; set; }

    protected override bool Valid
        => !Required || Value is not null;

    private async Task OnValueChanged(DateTime? value)
    {
        Value = value;
        await ValueChanged.InvokeAsync(Value);
    }
}