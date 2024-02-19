using Microsoft.Extensions.Options;
using Sibur.Digital.Svt.Infrastructure.Exceptions;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.Converter.Config;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Services;

/// <summary>
///     <see cref="IRuleService" />
/// </summary>
public class RuleService : IRuleService
{
    private readonly string _getRulesAction;
    private readonly IApiDataProvider _provider;

    public RuleService(IApiDataProvider provider, IOptions<ApiOptions> options)
    {
        _provider = provider;
        _getRulesAction = options.Value?.GetRulesAction ??
                          throw new ArgumentNullException(nameof(options), $"{nameof(options)} doesn't have parameter {nameof(ApiOptions.GetRulesAction)} specified");
    }

    /// <summary>
    ///     <see cref="IRuleService" />
    /// </summary>
    public async Task<List<RuleDto>> GetRulesAsync(int worksheetId)
    {
        var parameters = new Dictionary<string, string> { { nameof(worksheetId), worksheetId.ToString() } };
        var rules = await _provider
            .GetAsync<List<RuleDto>>(_getRulesAction, parameters)
            .ConfigureAwait(false);
        if (!rules.Any())
        {
            throw new RuleNotFoundException(worksheetId);
        }

        return rules;
    }
}