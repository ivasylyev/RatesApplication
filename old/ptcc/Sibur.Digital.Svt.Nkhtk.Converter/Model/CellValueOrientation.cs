namespace Sibur.Digital.Svt.Nkhtk.Converter.Model;

/// <summary>
/// Расположение ячейки со значением относительно заголовка
/// </summary>
public enum CellValueOrientation
{
    /// <summary>
    /// Значение берется из ячейки по вертикали снизу от ячейки с заголовком
    /// </summary>
    Vertical,

    /// <summary>
    /// Значение берется из ячейки по горизонтаи сбоку от ячейки с заголовком
    /// </summary>
    Horizontal
}