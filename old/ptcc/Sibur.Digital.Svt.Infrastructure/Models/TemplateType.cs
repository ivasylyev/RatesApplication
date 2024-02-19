namespace Sibur.Digital.Svt.Infrastructure.Models;

/// <summary>
/// Тип исходного шаблона для конвертации
/// </summary>
public enum TemplateType
{
    /// <summary>
    /// Тип шаблона НХТК ставок
    /// </summary>
    Nkhtk = 1,

    /// <summary>
    /// Тип шаблона мультимодальных ставок
    /// </summary>
    MultiModal = 2,

    /// <summary>
    /// Тип шаблона мультимодальных специальных ставок
    /// </summary>
    MultiModalSpecial = 3
}