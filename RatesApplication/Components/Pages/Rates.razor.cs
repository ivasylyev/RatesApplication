﻿using Microsoft.AspNetCore.Components;
using RatesApplication.Models;
using RatesApplication.Services;

namespace RatesApplication.Components.Pages;

public partial class Rates
{
    private const int PageSize = 15;
    bool _skipped;

    [Inject] 
    private IRatesQueryService RatesQueryService { get; set; } = default!;

    private Rate[]? _rates;
    private int _rateCount;
    private int _currentPageNumber = 1;

    protected override async Task OnInitializedAsync()
    {
        _rates = await RatesQueryService.GetRatesAsync(PageSize).ToArrayAsync();
        _rateCount = await RatesQueryService.GetRateCountAsync();
    }

    private async Task PageSelected(int page)
    {
        _currentPageNumber = page;
        _rates = await RatesQueryService.GetRatesAsync(PageSize, (page - 1) * PageSize).ToArrayAsync();
    }
}