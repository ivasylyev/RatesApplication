namespace Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;

/// <summary>
/// Преобразователь одного элемента исходного шаблонаК в шаблон СВТ, действующий на основании бизнес-правла.
/// Полное преобразование исходного шаблона в шаблон СВТ происходит посредством
/// последовательного применения преобразователей.
/// </summary>
public interface ITransformer
{
    /// <summary>
    /// Преобразовывает один элемент исходного шаблона в элемент шаблона СВТ на основании бизнес-правла.
    /// </summary>
    /// <param name="source">Исходный шаблона</param>
    /// <param name="target">Шаблон СВТ</param>
    void Apply(IExcelDecorator source, IExcelDecorator target);
}