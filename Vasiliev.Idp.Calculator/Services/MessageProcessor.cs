using Confluent.Kafka;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Vasiliev.Idp.Calculator.Repository;
using Vasiliev.Idp.Dto;

namespace Vasiliev.Idp.Calculator.Services;

public class MessageProcessor : IMessageProcessor
{

    public MessageProcessor(IRateRepository repository, IProducerService producer, ILogger<MessageProcessor> logger)
    {
        Repository = repository ?? throw new ArgumentNullException(nameof(repository));
        Producer = producer ?? throw new ArgumentNullException(nameof(producer));
        Logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }

    private IRateRepository Repository { get; }
    private IProducerService Producer { get; }
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
            Logger.LogError(e,$"{nameof(MessageProcessor)} could not deserialize message {message}");
            return;
        }

        if (dto == null)
        {
            Logger.LogError($"{nameof(MessageProcessor)} deserialized the message into NULL. Message: {message}");
            return;

        }
       
        ProcessCommand(dto.Command, ct);
        if (dto.Data != null)
        {
            ProcessData(dto.Data);
        }
    }

    private void ProcessCommand(RateCommandDto command, CancellationToken ct)
    {
        switch (command)
        {
            case RateCommandDto.StartCalculate:
                Repository.Reset();
                break;
            case RateCommandDto.EndCalculate:
                var rates = Repository.GetRates();
                Producer.SendRates(rates, ct);
                Repository.Reset();
                break;
        }
    }
    private void ProcessData(RateDataDto data)
    {
       Repository.AddRate(data);
    }
}