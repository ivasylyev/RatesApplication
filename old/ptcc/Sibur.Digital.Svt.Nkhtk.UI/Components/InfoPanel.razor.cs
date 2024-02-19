using Microsoft.AspNetCore.Components;
using Sibur.Digital.Svt.Nkhtk.UI.Models;

namespace Sibur.Digital.Svt.Nkhtk.UI.Components;

/// <summary>
/// Компонент информационной панели. Отображает информацию или ошибку
/// </summary>
public partial class InfoPanel
{
    /// <summary>
    /// Оторажаемое информационное сообщение или сообщение об ошибке
    /// </summary>
    [Parameter]
    public InfoModel? Info { get; set; }
}