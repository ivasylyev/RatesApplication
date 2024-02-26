using Microsoft.AspNetCore.Components;
using Vasiliev.Idp.Orchestrator.Services;

namespace Vasiliev.Idp.Orchestrator.Components.Pages;

public partial class Calc
{
    private int _currentProgress;

    [Inject] private CalculatorFacadeService CalculatorFacade { get; set; } = default!;
    CancellationTokenSource _cancellationTokenSource = default!;

    private bool IsSending => _currentProgress == 0 || _currentProgress == 100;

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
        _currentProgress = 0;
    }

    private async Task SendToKafka()
    {
        _cancellationTokenSource = new CancellationTokenSource();
        _currentProgress = 0;


        await CalculatorFacade.SendToKafka(progress =>
            {
                _currentProgress = progress;
                StateHasChanged();
            },
            _cancellationTokenSource.Token);
    }

    private async Task CancelSendingToKafka()
    {
        _currentProgress = 0;
        await _cancellationTokenSource.CancelAsync();
    }
}