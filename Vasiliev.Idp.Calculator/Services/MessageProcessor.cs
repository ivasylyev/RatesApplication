using Confluent.Kafka;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Vasiliev.Idp.Dto;

namespace Vasiliev.Idp.Calculator.Services;

public class MessageProcessor : IMessageProcessor
{
    public MessageProcessor(ILogger<MessageProcessor> logger)
    {
        Logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }

    private ILogger<MessageProcessor> Logger { get; }

    public void Process(string? message)
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
            Logger.LogError(e,$"{nameof(MessageProcessor)} could not deserialize message {message}");
            return;
        }

        if (dto == null)
        {
            Logger.LogError($"{nameof(MessageProcessor)} deserialized the message into NULL. Message: {message}");
            return;

        }
       
        ProcessCommand(dto.Command);
        if (dto.Data != null)
        {
            ProcessData(dto.Data);
        }
    }

    private void ProcessCommand(RateCommandDto command)
    {
        switch (command)
        {
            case RateCommandDto.StartCalculate:
                break;
            case RateCommandDto.EndCalculate:
                break;
        }
    }
    private void ProcessData(RateDataDto data)
    {
       
    }
}