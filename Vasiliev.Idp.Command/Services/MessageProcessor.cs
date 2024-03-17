using Confluent.Kafka;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Vasiliev.Idp.Command.Repository;
using Vasiliev.Idp.Dto;

namespace Vasiliev.Idp.Command.Services;

public class MessageProcessor : IMessageProcessor
{
    public MessageProcessor(IRateRepository repository, ILogger<MessageProcessor> logger)
    {
        Repository = repository ?? throw new ArgumentNullException(nameof(repository));
        Logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }

    private IRateRepository Repository { get; }
    private ILogger<MessageProcessor> Logger { get; }

    public void Process(string? message, CancellationToken ct)
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

        if (dto.Data != null)
        {
            Repository.InsertOrUpdateRate(dto.Data);
        }
    }
}