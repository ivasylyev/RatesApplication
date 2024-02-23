using RatesServices.Models;

namespace RatesServices.Services;

public interface IRatesCommandService
{
    Task SaveRate(Rate rate);
}