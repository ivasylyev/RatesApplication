using Microsoft.AspNetCore.Components;
using RatesKafkaAdapter;
using RatesServices;

namespace RatesApplication.Components.Pages
{
    public partial class Calc
    {
        [Inject]
        IRatesKafkaProducer KafkaProducer { get; set; } = default!;
        [Inject]
        IRatesQueryService RatesQueryService { get; set; } = default!;

        private int _currentCount;
        private string BtnClass
        {
            get
            {
                return (_currentCount == 0 || _currentCount == 100)
                    ? "btn btn-primary"
                    : "btn btn-primary disabled";
            }
        }

        protected override  void OnInitialized()
        {
            _currentCount = 0;
        }

        private async Task IncrementCount()
        {
            _currentCount = 0;
            int count = 0;

            var rateCount = await RatesQueryService.GetRateCountAsync();
            var rates = RatesQueryService.GetRatesAsync();
            await foreach (var rate in rates)
            {
                await KafkaProducer.SendRate(rate);
                UpdateProgress(ref count, rateCount);
            }
        }

        private void UpdateProgress(ref int count, int totalCount)
        {
            count++;
            var newCount = 100 * count / totalCount;
            if (_currentCount != newCount)
                StateHasChanged();
            _currentCount = newCount;
        }
    }
}
