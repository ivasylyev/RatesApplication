using Vasiliev.Idp.Dto;

namespace Vasiliev.Idp.Command.Services;

public interface ICommandService
{
    Task SaveRate(RateDataDto rateData);
}