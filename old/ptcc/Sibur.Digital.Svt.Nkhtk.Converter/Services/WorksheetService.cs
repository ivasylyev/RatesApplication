using Microsoft.Extensions.Options;
using Sibur.Digital.Svt.Infrastructure.Exceptions;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.Converter.Config;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Services;

/// <summary>
///     <see cref="IWorksheetService" />
/// </summary>
public class WorksheetService : IWorksheetService
{
    private readonly string _getWorksheetAction;
    private readonly IApiDataProvider _provider;

    public WorksheetService(IApiDataProvider provider, IOptions<ApiOptions> options)
    {
        _provider = provider;
        _getWorksheetAction = options.Value?.GetWorksheetAction ??
                              throw new ArgumentNullException(nameof(options), $"{nameof(options)} doesn't have parameter {nameof(ApiOptions.GetWorksheetAction)} specified");
    }

    /// <inheritdoc />
    public async Task<WorksheetDto> GetWorksheetAsync(int worksheetId)
    {
        var parameters = new Dictionary<string, string> { { nameof(worksheetId), worksheetId.ToString() } };
        var worksheet = await _provider
            .GetAsync<WorksheetDto>(_getWorksheetAction, parameters)
            .ConfigureAwait(false);
        if (worksheet is null)
        {
            throw new WorksheetNotFoundException(worksheetId);
        }

        return worksheet;
    }
}