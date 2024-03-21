using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using Npgsql;
using NpgsqlTypes;
using System.Data;
using Vasiliev.Idp.Command.Config;
using Vasiliev.Idp.Dto;

namespace Vasiliev.Idp.Command.Repository;

public class RateRepository : IRateRepository
{
    protected DbOptions Options { get; }
    protected ILogger<RateRepository> Logger { get; }
    public RateRepository(IOptions<DbOptions> options, ILogger<RateRepository> logger)
    {
        Options = options.Value ??
                  throw new ArgumentNullException(nameof(options), $"{nameof(options)} doesn't have Value");

        Logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }
    public async Task InsertOrUpdateRatesAsync(ICollection<RateDataDto> rates, CancellationToken ct)
    {
        try
        {
            if (string.IsNullOrEmpty(Options.ConnectionString))
                throw new InvalidOperationException($"Config value {nameof(Options.ConnectionString)} is absent");

            await using var dataSource = NpgsqlDataSource.Create(Options.ConnectionString);
            await using var con = dataSource.CreateConnection();
            await con.OpenAsync(ct);

            await using var command = new NpgsqlCommand(@"public.""SaveRates""", con);
            command.CommandType = CommandType.StoredProcedure;

            var json = JsonConvert.SerializeObject(rates);
            command.Parameters.AddWithValue("rates", NpgsqlDbType.Json, json);

            await command.ExecuteNonQueryAsync(ct);
        }
        catch (Exception e)
        {
            Logger.LogError(e, $"Cannot save rates");
            throw;
        }
    }
    public async Task InsertOrUpdateRate(RateDataDto rate, CancellationToken ct)
    {
        try
        {
            if (string.IsNullOrEmpty(Options.ConnectionString))
                throw new InvalidOperationException($"Config value {nameof(Options.ConnectionString)} is absent");

            await using var dataSource = NpgsqlDataSource.Create(Options.ConnectionString);
            await using var con = dataSource.CreateConnection();
            await con.OpenAsync(ct);

            await using var command = new NpgsqlCommand(@"public.""SaveRate""", con);
            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.AddWithValue("node_from_id", NpgsqlDbType.Bigint, rate.NodeFromId);
            command.Parameters.AddWithValue("node_to_id", NpgsqlDbType.Bigint, rate.NodeToId);
            command.Parameters.AddWithValue("product_group_id", NpgsqlDbType.Bigint, rate.ProductGroupId);
            command.Parameters.AddWithValue("start_date", NpgsqlDbType.Date, rate.StartDate);
            command.Parameters.AddWithValue("end_date", NpgsqlDbType.Date, rate.EndDate);
            command.Parameters.AddWithValue("val", NpgsqlDbType.Numeric, rate.Value);
            command.Parameters.AddWithValue("is_deflated", NpgsqlDbType.Boolean, rate.IsDeflated);

            await command.ExecuteNonQueryAsync(ct);
        }
        catch (Exception e)
        {
            Logger.LogError(e, $"Cannot save rate {rate}");
            throw;
        }
    }
}