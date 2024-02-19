using Microsoft.AspNetCore.Components;

namespace Sibur.Digital.Svt.Nkhtk.UI.Components;

/// <summary>
/// Базовая обертка над компонентом для ввода данных
/// </summary>
public class SvtInput : ComponentBase
{
    /// <summary>
    /// Заголовок, отображаемый над компонентов ввода
    /// </summary>
    [Parameter]
    public string Title { get; set; } = string.Empty;

    /// <summary>
    /// Флаг, показывающий, отключен ли компонент
    /// </summary>
    [Parameter]
    public bool Disabled { get; set; }

    /// <summary>
    /// Флаг, показывающий, что компонент обязан иметь значение
    /// </summary>
    [Parameter]
    public bool Required { get; set; }

    /// <summary>
    /// Свойство, определяющее валидность веденных данных. олжно быть определено в дочерних компонентах
    /// </summary>
    protected virtual bool Valid => true;

    protected string ValidOrInvalidCssClass => Valid ? string.Empty : "invalid";

    protected virtual string CustomCssClass => "form-control";

    protected string CssClass => $"{CustomCssClass} {ValidOrInvalidCssClass}";

}