using System.Net.Http.Headers;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Sibur.Digital.Svt.Infrastructure.Exceptions;
using Sibur.Digital.Svt.Infrastructure.Utils;
using Sibur.Digital.Svt.Nkhtk.UI.Config;
using Sibur.Digital.Svt.Nkhtk.UI.Models;

namespace Sibur.Digital.Svt.Nkhtk.UI.Services;

public class ConverterService : Service
{
    private const string MediaType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

    /// <summary>
    /// URL для оправки POST-запросов на конвертацию excel файлов
    /// </summary>
    private readonly string _convertFileUrl;

    /// <summary>
    /// URL для оправки POST-запросов на получение спикка вкладок excel файлов
    /// </summary>
    private readonly string _worksheetNamesUrl;

    public ConverterService(HttpClient client, IOptions<UiOptions> options, ILogger<Service> logger)
        : base(client, options, logger)
    {
        // URL сервиса конвертации
        var converterUrl = Options.BaseConverterUrl ??
                           throw new ConfigValueNotFoundException(nameof(UiOptions.BaseConverterUrl));

        var action = Options.ConverterFileAction ??
                     throw new ConfigValueNotFoundException(nameof(UiOptions.ConverterFileAction));
        _convertFileUrl = $"{converterUrl}/{action}";

        action = Options.ConverterWorksheetNamesAction ??
                 throw new ConfigValueNotFoundException(nameof(UiOptions.ConverterWorksheetNamesAction));
        _worksheetNamesUrl = $"{converterUrl}/{action}";
    }


    /// <summary>
    /// Возвращает вкладки excel файла из потока
    /// </summary>
    /// <param name="excelStream">поток эксель файла</param>
    /// <returns>список вкладок</returns>
    public async Task<List<string>> GetWorksheetNamesAsync(StreamModel excelStream)
    {
        var multipartFormContent = GetMultipartFormDataContent(excelStream.Stream);
        var response = await Client.PostAsync(_worksheetNamesUrl, multipartFormContent);

        var result = await response.Content.ReadFromJsonAsync<List<string>>();

        return result ?? new List<string>();
    }

    /// <summary>
    /// Скачивает сконвертированный шаблон
    /// </summary>
    /// <param name="excelStream">модель с потоком исходного excel файла</param>
    /// <param name="parameters">параметры URL</param>
    /// <returns></returns>
    /// <exception cref="ArgumentNullException"></exception>
    /// <exception cref="ConvertException"></exception>
    public async Task<Stream> DownloadConvertedTemplateAsync(StreamModel excelStream, string parameters)
    {
        excelStream.ThrowIfNull(nameof(excelStream));
        parameters.ThrowIfNullOrEmpty(nameof(parameters));

        var fileUrl = new Uri($"{_convertFileUrl}?{parameters}");
        var multipartFormContent = GetMultipartFormDataContent(excelStream.Stream);
        var response = await Client.PostAsync(fileUrl, multipartFormContent);

        if (response.IsSuccessStatusCode)
        {
            var stream = await response.Content.ReadAsStreamAsync();
            return stream;
        }

        var error = await response.Content.ReadFromJsonAsync<ProblemDetails>();
        throw new ConvertException(error!);
    }

    private MultipartFormDataContent GetMultipartFormDataContent(Stream uploadStream)
    {
        uploadStream.Position = 0;
        var fileStreamContent = new StreamContent(uploadStream);

        fileStreamContent.Headers.ContentType = new MediaTypeHeaderValue(MediaType);
        var multipartFormContent = new MultipartFormDataContent { { fileStreamContent, "file", "file.xls" } };
        return multipartFormContent;
    }
}