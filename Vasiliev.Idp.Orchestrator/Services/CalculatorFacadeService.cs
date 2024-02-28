﻿using Mapster;
using Vasiliev.Idp.Dto;
using Vasiliev.Idp.Orchestrator.Models;

namespace Vasiliev.Idp.Orchestrator.Services;

public class CalculatorFacadeService
{
    private int _bufferSize = 100;
    private IKafkaProducerService KafkaProducerService { get; }

    private IQueryService QueryService { get; }

    public CalculatorFacadeService(IKafkaProducerService kafkaProducerService, IQueryService queryService)
    {
        KafkaProducerService = kafkaProducerService;
        QueryService = queryService;
    }

    public async Task SendToKafka(Action<int> updateProgress, CancellationToken ct)
    {
        var rateCount = await QueryService.GetRateCountAsync();
        var rates = QueryService.GetRatesAsync();
        var rateDtoBuffer = new List<RateDto>(_bufferSize);

        var progress = new KafkaProgress(rateCount);

        KafkaProducerService.SendCommand(RateCommandDto.StartCalculate, ct);
        await foreach (var rate in rates)
        {
            var rateDto = rate.Adapt<RateDto>();
            rateDtoBuffer.Add(rateDto);
            if (rateDtoBuffer.Count == _bufferSize)
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