using System.Collections.Concurrent;
using System.Diagnostics;
using Confluent.Kafka;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Vasiliev.Idp.Command.Repository;
using Vasiliev.Idp.Dto;
using static Confluent.Kafka.ConfigPropertyNames;

namespace Vasiliev.Idp.Command.Services;

public class MessageProcessor : IMessageProcessor
{
    private const int RateBatchSize = 200;

    public MessageProcessor(IRateRepository repository, ILogger<MessageProcessor> logger)
    {
        Repository = repository ?? throw new ArgumentNullException(nameof(repository));
        Logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }

    private IRateRepository Repository { get; }
    private ILogger<MessageProcessor> Logger { get; }

    private ConcurrentQueue<RateDataDto> RatesQueue { get; } = new();
    private AutoResetEvent QueueSignal { get; } = new(false);

    public void Enqueue(string? message, CancellationToken ct)
    {
        if (message == null)
        {
            Logger.LogError($"{nameof(MessageProcessor)} got an empty message");
            return;
        }

        RateMessageDto? dto;
        try
        {
            dto = JsonConvert.DeserializeObject<RateMessageDto>(message);
        }
        catch (Exception e)
        {
            Logger.LogError(e, $"{nameof(MessageProcessor)} could not deserialize message {message}");
            return;
        }

        if (dto == null)
        {
            Logger.LogError($"{nameof(MessageProcessor)} deserialized the message into NULL. Message: {message}");
            return;
        }

        if (dto.Data != null && dto.Data.IsDeflated)
        {
            RatesQueue.Enqueue(dto.Data);
            QueueSignal.Set();
        }
    }

    public async Task ProcessMessageQueue(CancellationToken ct)
    {
        int counter = 0;
        List<RateDataDto> batch = new List<RateDataDto>(RateBatchSize);
        while (RatesQueue.TryDequeue(out var rate) && rate != null && counter < RateBatchSize)
        {
            batch.Add(rate);
            counter++;
        }

        if (batch.Any())
        {
            Logger.LogDebug($"Processed {batch.Count} messages");
            await Repository.InsertOrUpdateRatesAsync(batch, ct);
        }
        else
        {
            Logger.LogDebug($"Message queue is empty. Waiting for message to process");
            QueueSignal.WaitOne();
        }

    }
}