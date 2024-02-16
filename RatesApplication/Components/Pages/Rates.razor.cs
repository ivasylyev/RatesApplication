using Microsoft.AspNetCore.Components;
using RatesServices;

namespace RatesApplication.Components.Pages
{
    public partial class Rates
    {
        [Inject]
        IRatesQueryService RatesQueryService { get; set; } = default!;

        private RatesModels.RateListItemDto[]? rates;

        protected override async Task OnInitializedAsync()
        {
   
            rates = await RatesQueryService.GetRatesAsync(30).ToArrayAsync();

        }

        private async Task PageSelected(int page)
        {

            rates = await RatesQueryService.GetRatesAsync(30, (page-1)* 30).ToArrayAsync();

        }


    }
}
