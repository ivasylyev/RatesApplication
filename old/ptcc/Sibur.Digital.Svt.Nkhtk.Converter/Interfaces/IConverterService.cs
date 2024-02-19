using Sibur.Digital.Svt.Nkhtk.Converter.Model;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;

public interface IConverterService
{

    /// <summary>
    /// Возвращает список вкладок excel файла
    /// </summary>
    /// <param name="file">Файл исходного шаблона</param>
    /// <returns>Список вкладок</returns>
    List<string> GetWorksheetNames(IFormFile file);


    /// <summary>
    /// Конвертирует выбранную страницу эксель файла из формата исходного шаблона
    /// в одностраничный эксель формат шаблона назначения (СВТ)
    /// </summary>
    /// <param name="parameters">Параметры исходного шаблона (идентификатор, имя странцы, даты начала и конца)</param>
    /// <param name="sourceStream">Поток исходного шаблона</param>
    /// <returns>Поток заполненного экслеь файла в формате шаблона назначения (СВТ)</returns>
    Task<Stream> ConvertFileAsync(TemplateParameters parameters, Stream sourceStream);
}