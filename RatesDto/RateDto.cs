using Newtonsoft.Json;

namespace RatesDto;

public class RateDto
{
    [JsonRequired]
    [JsonProperty("rate_id")]
    public long RateId { get; set; }

    [JsonRequired]
    [JsonProperty("start_date")]
    public DateOnly StartDate { get; set; }

    [JsonRequired]
    [JsonProperty("end_date")]
    public DateOnly EndDate { get; set; }

    [JsonRequired]
    [JsonProperty("node_from_code")]
    public string NodeFromCode { get; set; } = default!;

    [JsonRequired]
    [JsonProperty("node_to_code")]
    public string NodeToCode { get; set; } = default!;

    [JsonRequired]
    [JsonProperty("product_group_code")]
    public string ProductGroupCode { get; set; } = default!;

    [JsonRequired] [JsonProperty("value")] public decimal Value { get; set; }

    [JsonRequired]
    [JsonProperty("is_deflated")]
    public bool IsDeflated { get; set; }
}