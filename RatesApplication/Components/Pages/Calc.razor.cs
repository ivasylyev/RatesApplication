using Mapster;
using Microsoft.AspNetCore.Components;
using RatesApplication.Services;
using RatesDto;
using RatesKafkaAdapter;

namespace RatesApplication.Components.Pages;

public partial class Calc
{
    private int _bufferSize = 100;
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
        var rateDtoBuffer = new List<RateDto>(_bufferSize);
   
        await foreach (var rate in rates)
        {
            var rateDto = rate.Adapt<RateDto>();
            rateDtoBuffer.Add(rateDto);
            if (rateDtoBuffer.Count == _bufferSize)
            {
                if (_cancellationTokenSource.IsCancellationRequested)
                {
                    _currentCount = 0;
                    _cancellationTokenSource = new CancellationTokenSource();
                    break;
                }

                KafkaProducer.SendRates(rateDtoBuffer, _cancellationTokenSource.Token);
                if (UpdateProgress(ref count, rateDtoBuffer.Count, rateCount))
                {
                    // Даем шанс потоку UI отрисовать измененения
                    await Task.Yield();
                }

                rateDtoBuffer.Clear();
            }
        }
        if (rateDtoBuffer.Any())
        {
            KafkaProducer.SendRates(rateDtoBuffer, _cancellationTokenSource.Token);
            UpdateProgress(ref count, rateDtoBuffer.Count, rateCount);
        }
    }

    private async Task CancelSendingToKafka()
    {
        await _cancellationTokenSource.CancelAsync();
    }

    private bool UpdateProgress(ref int count, int delta, int totalCount)
    {
        
        count+=delta;
        var newCount = 100 * count / totalCount;
        bool hasChanged = _currentCount != newCount;
        if (hasChanged)
        {
            StateHasChanged();
        }

        _currentCount = newCount;
        return hasChanged;
    }
}