﻿using RatesDto;

namespace Vasiliev.Idp.Command;

public interface IRatesCommandService
{
    Task SaveRate(RateDto rate);
}