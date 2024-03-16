using Dapper;
using Microsoft.AspNetCore.Components;
using Npgsql;
using Vasiliev.Idp.Orchestrator.Models;
using Vasiliev.Idp.Orchestrator.Services;

namespace Vasiliev.Idp.Orchestrator.Components.Pages;

public partial class Rates
{
    private const int PageSize = 15;
    bool _skipped;

    [Inject] 
    private IQueryService QueryService { get; set; } = default!;

    private Rate[]? _rates;
    private int _rateCount;
    private int _currentPageNumber = 1;

    protected override async Task OnAfterRenderAsync(bool firstRender)
    {
        if (firstRender)
        {
             _rates = await QueryService.GetRatesAsync(PageSize).ToArrayAsync();
             _rateCount = await QueryService.GetRateCountAsync();
            StateHasChanged();
        }
    }
    private async Task PageSelected(int page)
    {
        _currentPageNumber = page;
        _rates = await QueryService.GetRatesAsync(PageSize, (page - 1) * PageSize).ToArrayAsync();
    }
}