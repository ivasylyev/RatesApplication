using Vasiliev.Idp.Dto;

namespace Vasiliev.Idp.Command.Repository;

public interface IRateRepository
{
    void InsertOrUpdateRate(RateDataDto rate);
}