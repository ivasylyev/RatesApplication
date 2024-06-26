﻿using Newtonsoft.Json;

namespace Vasiliev.Idp.Dto;

public class RateDataDto
{
    [JsonRequired] 
    [JsonProperty("id")] 
    public long Id { get; set; }

    [JsonRequired]
    [JsonProperty("start_date")]
    public DateOnly StartDate { get; set; }

    [JsonRequired]
    [JsonProperty("end_date")]
    public DateOnly EndDate { get; set; }

    [JsonRequired]
    [JsonProperty("node_from_id")]
    public long NodeFromId { get; set; }

    [JsonRequired]
    [JsonProperty("node_to_id")]
    public long NodeToId { get; set; }

    [JsonRequired]
    [JsonProperty("product_group_id")]
    public long ProductGroupId { get; set; }

    [JsonRequired] 
    [JsonProperty("value")] 
    public decimal Value { get; set; }

    [JsonRequired]
    [JsonProperty("is_deflated")]
    public bool IsDeflated { get; set; }

    public override string ToString()
        => $"{Id}, {StartDate}-{EndDate}, Node: {NodeFromId}-{NodeToId}, PG: {ProductGroupId}, Val: {Value}, Deflated: {IsDeflated}";
}