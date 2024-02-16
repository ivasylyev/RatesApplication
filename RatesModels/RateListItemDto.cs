using Newtonsoft.Json;


namespace RatesModels
{
    public class RateListItemDto
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
        [JsonProperty("node_from")]
        public LocationNodeDto NodeFrom { get; set; }

        [JsonRequired]
        [JsonProperty("node_to")]
        public LocationNodeDto NodeTo { get; set; }

        [JsonRequired]
        [JsonProperty("value")]
        public decimal Value { get; set; }

        [JsonRequired]
        [JsonProperty("is_deflated")]
        public bool IsDeflated { get; set; }

    }
}
