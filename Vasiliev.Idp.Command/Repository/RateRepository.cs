using Dapper;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Npgsql;
using NpgsqlTypes;
using System.Data;
using System.Diagnostics.Metrics;
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
    public void InsertOrUpdateRate(RateDataDto rate)
    {
        try
        {
            if (string.IsNullOrEmpty(Options.ConnectionString))
                throw new InvalidOperationException($"Config value {nameof(Options.ConnectionString)} is absent");

            using var dataSource = NpgsqlDataSource.Create(Options.ConnectionString);
            using var con = dataSource.CreateConnection();
            con.Open();
            
            using var command = new NpgsqlCommand(@"public.""SaveRate""", con);
            command.CommandType = CommandType.StoredProcedure;

            command.Parameters.AddWithValue("node_from_id", NpgsqlDbType.Bigint, rate.NodeFromId);
            command.Parameters.AddWithValue("node_to_id", NpgsqlDbType.Bigint, rate.NodeToId);
            command.Parameters.AddWithValue("product_group_id", NpgsqlDbType.Bigint, rate.ProductGroupId);
            command.Parameters.AddWithValue("start_date", NpgsqlDbType.Date, rate.StartDate);
            command.Parameters.AddWithValue("end_date", NpgsqlDbType.Date, rate.EndDate);
            command.Parameters.AddWithValue("val", NpgsqlDbType.Numeric, rate.Value);
            command.Parameters.AddWithValue("is_deflated", NpgsqlDbType.Boolean, rate.IsDeflated);

            command.ExecuteNonQuery();
        }
        catch (Exception e)
        {
            Logger.LogError(e, $"Cannot save rate {rate}");
            throw;
        }
    }
}