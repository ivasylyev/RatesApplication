﻿using Mapster;
using Vasiliev.Idp.Dto;
using Vasiliev.Idp.Orchestrator.Models;
using Vasiliev.Idp.Orchestrator.Repository;

namespace Vasiliev.Idp.Orchestrator.Services;

public class CalculatorFacadeService
{
    private const int BufferSize = 100;
    private IKafkaProducerService KafkaProducerService { get; }

    private IRateQueryRepository RateQueryRepository { get; }

    public CalculatorFacadeService(IKafkaProducerService kafkaProducerService, IRateQueryRepository rateQueryRepository)
    {
        KafkaProducerService = kafkaProducerService;
        RateQueryRepository = rateQueryRepository;
    }

    public async Task SendToKafka(Action<int> updateProgress, CancellationToken ct)
    {
        KafkaProducerService.SendCommand(RateCommandDto.StartCalculate, ct);

        var rateCount = await RateQueryRepository.GetNonDeflatedRatesCountAsync();
        var rates = RateQueryRepository.GetRatesAsync();
        var rateDtoBuffer = new List<RateDataDto>(BufferSize);
        var progress = new KafkaProgress(rateCount);

        await foreach (var rate in rates.Where(r => !r.IsDeflated).WithCancellation(ct))
        {
            var rateDto = rate.Adapt<RateDataDto>();
            rateDtoBuffer.Add(rateDto);
            if (rateDtoBuffer.Count == BufferSize)
            {
                //break;
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