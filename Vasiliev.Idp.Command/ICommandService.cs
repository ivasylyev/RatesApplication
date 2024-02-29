using Vasiliev.Idp.Dto;

namespace Vasiliev.Idp.Command;

public interface ICommandService
{
    Task SaveRate(RateDataDto rateData);
}