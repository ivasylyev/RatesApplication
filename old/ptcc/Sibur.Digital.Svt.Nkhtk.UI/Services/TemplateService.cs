using Microsoft.Extensions.Options;
using Sibur.Digital.Svt.Infrastructure.Exceptions;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.UI.Config;

namespace Sibur.Digital.Svt.Nkhtk.UI.Services;

public class TemplateService : Service
{
    /// <summary>
    /// URL для оправки GET запросов для получшения списка шаблонов
    /// </summary>
    private readonly string _dataTemplatesUrl;

    public TemplateService(HttpClient client, IOptions<UiOptions> options, ILogger<Service> logger)
        : base(client, options, logger)
    {
        var action = Options.DataTemplatesAction ??
                     throw new ConfigValueNotFoundException(nameof(UiOptions.DataTemplatesAction));
        _dataTemplatesUrl = $"{DataUrl}/{action}";
    }


    /// <summary>
    /// Запрашивает у API сервиса данных список шблонов 
    /// </summary>
    /// <param name="templateType">Тип шаблонов, которые войдут в возвращаемый список</param>
    /// <returns> список шблонов</returns>
    public async Task<List<TemplateDto>> GetTemplatesAsync(TemplateType templateType)
    {
        var getTemplateUrl = new Uri($"{_dataTemplatesUrl}?templateTypeId={(int)templateType}");
        var templates = await Client.GetFromJsonAsync<List<TemplateDto>>(getTemplateUrl)
            .ConfigureAwait(false);
        return templates!;
    }
}