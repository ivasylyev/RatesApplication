using Sibur.Digital.Svt.Infrastructure.Models;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;

/// <summary>
/// Сервис для загрузки Excel файла шаблона СВТ в поток
/// </summary>
public interface ISvtTemplateService
{
    /// <summary>
    /// Номер вкладки шаблона СВТ
    /// </summary>
    int ExcelWorksheetIndex { get; }

    // Имя первой колонки в шаблоне СВТ
    string FirstColumnName { get; }

    /// <summary>
    /// Загружает шаблон СВТ в поток
    /// </summary>
    /// <param name="templateType">Тип шаблона СВТ</param>
    /// <returns>Поток с загруженным шаблоном СВТ</returns>
    Stream GetTemplateFileStream(TemplateType templateType);
}