using Vasiliev.Idp.Dto;

namespace Vasiliev.Idp.Calculator.Services;

public interface IMessageProcessor
{
    void Process(RateMessageDto? message);
}