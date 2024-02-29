using Microsoft.Extensions.Logging;
using Vasiliev.Idp.Dto;

namespace Vasiliev.Idp.Calculator.Services;

public class MessageProcessor : IMessageProcessor
{
    public MessageProcessor(ILogger<MessageProcessor> logger)
    {
        Logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }

    private ILogger<MessageProcessor> Logger { get; }

    public void Process(RateMessageDto? message)
    {
        if (message == null)
        {
            Logger.LogWarning($"{nameof(MessageProcessor)} got an empty message");
            return;
        }

        ProcessCommand(message.Command);
        if (message.Data != null)
        {
            ProcessData(message.Data);
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