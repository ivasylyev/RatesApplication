using Mapster;
using Vasiliev.Idp.Dto;
using Vasiliev.Idp.Orchestrator.Models;

namespace Vasiliev.Idp.Orchestrator.Services;

public class CalculatorFacadeService
{
    private const int BufferSize = 100;
    private IKafkaProducerService KafkaProducerService { get; }

    private IQueryService QueryService { get; }

    public CalculatorFacadeService(IKafkaProducerService kafkaProducerService, IQueryService queryService)
    {
        KafkaProducerService = kafkaProducerService;
        QueryService = queryService;
    }

    public async Task SendToKafka(Action<int> updateProgress, CancellationToken ct)
    {
        KafkaProducerService.SendCommand(RateCommandDto.StartCalculate, ct);

        var rateCount = await QueryService.GetRateCountAsync();
        var rates = QueryService.GetRatesAsync();
        var rateDtoBuffer = new List<RateDataDto>(BufferSize);
        var progress = new KafkaProgress(rateCount);

        await foreach (var rate in rates)
        {
            var rateDto = rate.Adapt<RateDataDto>();
            rateDtoBuffer.Add(rateDto);
            if (rateDtoBuffer.Count == BufferSize)
            {
                if (ct.IsCancellationRequested)
                {
                    progress.Reset();
                    rateDtoBuffer.Clear();
                    break;
                }

                KafkaProducerService.SendRates(rateDtoBuffer, ct);
                await UpdateProgressInternal(updateProgress, progress, rateDtoBuffer.Count);
                rateDtoBuffer.Clear();
            }
        }

        if (rateDtoBuffer.Any()) 
            KafkaProducerService.SendRates(rateDtoBuffer, ct);

        
        KafkaProducerService.SendCommand(RateCommandDto.EndCalculate, ct);

        await UpdateProgressInternal(updateProgress, progress, rateDtoBuffer.Count);
    }

    private async Task UpdateProgressInternal(Action<int> updateProgress, KafkaProgress progress, int delta)
    {
        if (progress.Increment(delta))
        {
            updateProgress(progress.CurrentProgress);
            // Даем шанс потоку UI отрисовать измененения
            await Task.Yield();
        }
    }
}