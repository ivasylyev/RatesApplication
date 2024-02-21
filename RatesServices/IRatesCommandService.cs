using RatesModels;

namespace RatesServices;

public interface IRatesCommandService
{
    Task SaveRate(Rate rate);
}