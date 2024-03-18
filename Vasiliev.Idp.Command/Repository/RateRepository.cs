using Dapper;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Npgsql;
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
            var result = con.Execute("SELECT 1");
        }
        catch (Exception e)
        {
            Logger.LogError(e, "Cannot save rate");
            throw;
        }
    }
}