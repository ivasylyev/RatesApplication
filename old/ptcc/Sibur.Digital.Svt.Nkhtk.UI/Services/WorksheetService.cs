using Microsoft.Extensions.Options;
using Sibur.Digital.Svt.Infrastructure.Exceptions;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.UI.Config;

namespace Sibur.Digital.Svt.Nkhtk.UI.Services;

public class WorksheetService : Service
{
    /// <summary>
    /// URL для оправки GET запросов для получшения данных о вкладках шаблонов
    /// </summary>
    private readonly string _dataWorksheetsUrl;

    public WorksheetService(HttpClient client, IOptions<UiOptions> options, ILogger<Service> logger)
        : base(client, options, logger)
    {
        var action = Options.DataWorksheetsAction ??
                     throw new ConfigValueNotFoundException(nameof(UiOptions.DataWorksheetsAction));
        _dataWorksheetsUrl = $"{DataUrl}/{action}";
    }

    /// <summary>
    /// Формирует имя файла для данной вкладки шаблона
    /// </summary>
    /// <param name="worksheetId">идентификатор вкладки</param>
    /// <returns></returns>
    public async Task<string> GetFileNameAsync(int worksheetId)
    {
        try
        {
            var url = new Uri($"{_dataWorksheetsUrl}?worksheetId={worksheetId}");
            var worksheet = await Client.GetFromJsonAsync<WorksheetDto>(url)
                .ConfigureAwait(false);

            return $"СВТ ({worksheet?.TemplateRussianName})({worksheet?.WorksheetName}).xlsx";
        }
        catch (Exception ex)
        {
            Logger.LogError(ex, $"Cannot generate the name for worksheet {worksheetId}");
            return $"СВТ_{worksheetId}.xlsx";
        }
    }
}