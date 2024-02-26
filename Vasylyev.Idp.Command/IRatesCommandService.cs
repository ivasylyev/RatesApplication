using Vasiliev.Idp.Dto;

namespace Vasiliev.Idp.Command;

public interface IRatesCommandService
{
    Task SaveRate(RateDto rate);
}