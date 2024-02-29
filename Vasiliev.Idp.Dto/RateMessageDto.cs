using Newtonsoft.Json;

namespace Vasiliev.Idp.Dto;

public class RateMessageDto
{
    [JsonRequired]
    [JsonProperty("command")]
    public RateCommandDto Command { get; set; }

    [JsonProperty("data")] 
    public RateDataDto? Data { get; set; }

    [JsonConstructor]
    private RateMessageDto()
    {
    }

    public RateMessageDto(RateCommandDto command)
    {
        Command = command;
    }

    public RateMessageDto(RateDataDto? data)
    {
        Command = RateCommandDto.None;
        Data = data;
    }
}