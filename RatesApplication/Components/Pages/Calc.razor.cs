using Microsoft.AspNetCore.Components;
using RatesKafkaAdapter;
using RatesServices;

namespace RatesApplication.Components.Pages;

public partial class Calc
{
    private int _currentCount;
    private CancellationTokenSource _cancellationTokenSource = new();

    [Inject] 
    private IRatesKafkaProducer KafkaProducer { get; set; } = default!;

    [Inject] 
    private IRatesQueryService RatesQueryService { get; set; } = default!;

    private bool IsSending => _currentCount == 0 || _currentCount == 100;

    private string BtnSendClass =>
        IsSending
            ? "btn btn-primary"
            : "btn btn-primary disabled";

    private string BtnCancelClass =>
        IsSending
            ? "btn btn-secondary disabled"
            : "btn btn-secondary";

    protected override void OnInitialized()
    {
        _currentCount = 0;
    }

    private async Task SendToKafka()
    {
        _currentCount = 0;
        var count = 0;

        var rateCount = await RatesQueryService.GetRateCountAsync();
        var rates = RatesQueryService.GetRatesAsync();

        await foreach (var rate in rates)
        {
            if (_cancellationTokenSource.IsCancellationRequested)
            {
                _currentCount = 0;
                _cancellationTokenSource = new CancellationTokenSource();
                break;
            }

            await KafkaProducer.SendRate(rate, _cancellationTokenSource.Token);
            UpdateProgress(ref count, rateCount);
        }
    }

    private async Task CancelSendingToKafka()
    {
        await _cancellationTokenSource.CancelAsync();
    }

    private void UpdateProgress(ref int count, int totalCount)
    {
        count++;
        var newCount = 100 * count / totalCount;

        if (_currentCount != newCount)
        {
            StateHasChanged();
        }

        _currentCount = newCount;
    }
}