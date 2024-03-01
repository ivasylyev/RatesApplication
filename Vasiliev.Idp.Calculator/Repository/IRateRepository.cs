using Vasiliev.Idp.Dto;

namespace Vasiliev.Idp.Calculator.Repository;

public interface IRateRepository
{
    void Reset();
    IEnumerable<RateDataDto> GetRates();
    void AddRate(RateDataDto rate);
}