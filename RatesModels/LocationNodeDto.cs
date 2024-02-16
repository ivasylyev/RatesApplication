using Newtonsoft.Json;

namespace RatesModels;

public class LocationNodeDto
{
    [JsonRequired] 
    [JsonProperty("id")] 
    public long Id { get; }

    [JsonRequired] 
    [JsonProperty("code")] 
    public string Code { get; }

    [JsonRequired] 
    [JsonProperty("name")] 
    public string Name { get; }

    public LocationNodeDto(long id, string code, string name)
    {
        Id = id;
        Code = code;
        Name = name;
    }
}