using Mapster;
using Microsoft.AspNetCore.Components;
using System.Threading;
using Vasiliev.Idp.Dto;

namespace Vasiliev.Idp.Orchestrator.Services
{
    public class CalculatorFacadeService
    {
        private int _bufferSize = 100;
        private int _currentCount;
        private IKafkaProducerService KafkaProducerService { get; }


        private IQueryService QueryService { get; }

        public CalculatorFacadeService(IKafkaProducerService kafkaProducerService, IQueryService queryService)
        {
            KafkaProducerService = kafkaProducerService;
            QueryService = queryService;
        }

        public async Task SendToKafka(Action<int> updateProgress, CancellationToken ct)
        {
            _currentCount = 0;
            var count = 0;

            var rateCount = await QueryService.GetRateCountAsync();
            var rates = QueryService.GetRatesAsync();
            var rateDtoBuffer = new List<RateDto>(_bufferSize);

            await foreach (var rate in rates)
            {
                var rateDto = rate.Adapt<RateDto>();
                rateDtoBuffer.Add(rateDto);
                if (rateDtoBuffer.Count == _bufferSize)
                {
                    if (ct.IsCancellationRequested)
                    {
                        _currentCount = 0;
                        break;
                    }

                    KafkaProducerService.SendRates(rateDtoBuffer, ct);
                    if (UpdateProgressInternal(updateProgress, ref count, rateDtoBuffer.Count, rateCount))
                    {
                        // Даем шанс потоку UI отрисовать измененения
                        await Task.Yield();
                    }

                    rateDtoBuffer.Clear();
                }
            }

            if (rateDtoBuffer.Any())
            {
                KafkaProducerService.SendRates(rateDtoBuffer, ct);
                UpdateProgressInternal(updateProgress, ref count, rateDtoBuffer.Count, rateCount);
            }
        }

        private bool UpdateProgressInternal(Action<int> updateProgress, ref int count, int delta, int totalCount)
        {
            count += delta;
            var newCount = 100 * count / totalCount;
            bool hasChanged = _currentCount != newCount;
            if (hasChanged)
            {
                updateProgress(_currentCount);
            }

            _currentCount = newCount;
            return hasChanged;
        }
    }
}