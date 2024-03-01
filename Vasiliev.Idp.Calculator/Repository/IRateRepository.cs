using Vasiliev.Idp.Dto;

namespace Vasiliev.Idp.Calculator.Repository;

public interface IRateRepository
{
    void Reset();
    ICollection<RateDataDto> GetRates();
    void AddRate(RateDataDto rate);
}