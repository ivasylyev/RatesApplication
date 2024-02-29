using Newtonsoft.Json;

namespace Vasiliev.Idp.Dto;

public class RateMessageDto
{
    [JsonRequired]
    [JsonProperty("command")]
    public RateCommandDto Command { get; set; }

    [JsonRequired]
    [JsonProperty("data")]
    public RateDataDto? Data { get; set; }
}