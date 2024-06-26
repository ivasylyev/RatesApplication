﻿using Vasiliev.Idp.Dto;

namespace Vasiliev.Idp.Orchestrator.Services;

public interface IKafkaProducerService
{
    void SendRates(IEnumerable<RateDataDto> rate, CancellationToken ct);
    void SendCommand(RateCommandDto command, CancellationToken ct);
}