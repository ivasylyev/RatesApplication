using Microsoft.AspNetCore.Components;

namespace Sibur.Digital.Svt.Nkhtk.UI.Components;

/// <summary>
/// Компонент, содержащий кнопку отправки HTML формы
/// </summary>
public partial class FileConvertSubmit
{
    /// <summary>
    /// Параметр, отключающий кнопку отправки  HTML формыю
    /// Значение true означает, что кнопка недоступна.
    /// Значение false означает, что кнопка доступна для нажатия
    /// </summary>
    [Parameter]
    public bool Disabled { get; set; }
}