using Dapper;
using Microsoft.AspNetCore.Components;
using Npgsql;
using Vasiliev.Idp.Orchestrator.Models;
using Vasiliev.Idp.Orchestrator.Repository;

namespace Vasiliev.Idp.Orchestrator.Components.Pages;

public partial class Rates
{
    private const int PageSize = 15;
    bool _skipped;

    [Inject] 
    private IRateQueryRepository QueryRepository { get; set; } = default!;

    private Rate[]? _rates;
    private int _rateCount;
    private int _currentPageNumber = 1;

    protected override async Task OnAfterRenderAsync(bool firstRender)
    {
        if (firstRender)
        {
             _rates = await QueryRepository.GetRatesAsync(PageSize).ToArrayAsync();
             _rateCount = await QueryRepository.GetRatesCountAsync();
            StateHasChanged();
        }
    }
    private async Task PageSelected(int page)
    {
        _currentPageNumber = page;
        _rates = await QueryRepository.GetRatesAsync(PageSize, (page - 1) * PageSize).ToArrayAsync();
    }
}