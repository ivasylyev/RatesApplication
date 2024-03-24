using Dapper;
using Microsoft.Extensions.Options;
using Npgsql;
using Vasiliev.Idp.Orchestrator.Config;
using Vasiliev.Idp.Orchestrator.Models;

namespace Vasiliev.Idp.Orchestrator.Services
{
    public class QueryService : IQueryService
    {
        protected DbOptions Options { get; }
        protected ILogger<QueryService> Logger { get; }

        public QueryService(IOptions<DbOptions> options, ILogger<QueryService> logger)
        {
            Options = options.Value ??
                      throw new ArgumentNullException(nameof(options), $"{nameof(options)} doesn't have Value");

            Logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        public async IAsyncEnumerable<Rate> GetRatesAsync(int take = int.MaxValue, int skip = 0)
        {
            IEnumerable<Rate> result;
            try
            {
                if (string.IsNullOrEmpty(Options.ConnectionString))
                    throw new InvalidOperationException($"Config value {nameof(Options.ConnectionString)} is absent");

                await using var dataSource = NpgsqlDataSource.Create(Options.ConnectionString);
                await using var con = dataSource.CreateConnection();
                con.Open();
                result = await con.QueryAsync<Rate, ProductGroup, LocationNode, LocationNode, Rate>(
                    GetRatesSql(take, skip),
                    (rate, productGroup, nodeFrom, nodeTo) =>
                    {
                        rate.ProductGroup = productGroup;
                        rate.NodeFrom = nodeFrom;
                        rate.NodeTo = nodeTo;
                        return rate;
                    });
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Cannot get rates");
                throw;
            }

            foreach (var rate in result)
            {
                yield return rate;
            }
        }


        public async Task<int> GetRatesCountAsync()
            => await GetRateCountInternalAsync(GetRatesCountSql());


        public async Task<int> GetNonDeflatedRatesCountAsync()
            => await GetRateCountInternalAsync(GetNonDeflatedRatesCountSql());


        private async Task<int> GetRateCountInternalAsync(string sql)
        {
            try
            {
                if (string.IsNullOrEmpty(Options.ConnectionString))
                    throw new InvalidOperationException($"Config value {nameof(Options.ConnectionString)} is absent");

                await using var dataSource = NpgsqlDataSource.Create(Options.ConnectionString);
                await using var con = dataSource.CreateConnection();
                con.Open();
                var result = await con.ExecuteScalarAsync<int>(sql);
                return result;
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Cannot get rates count");
                throw;
            }
        }

        private static string GetRatesSql(int take, int skip)
            => @$"SELECT ""RateId"" AS ""Id"", 
                                ""StartDate"", 
                                ""EndDate"", 
                                ""Value"", 
                                ""IsDeflated"", 
                                ""ProductGroupId"" AS ""Id"", 
                                ""ProductGroupCode"" AS ""Code"", 
                                ""ProductGroupName"" AS ""Name"", 
                                ""NodeFromId"" AS ""Id"", 
                                ""NodeFromCode""  AS ""Code"", 
                                ""NodeFromName"" AS ""Name"", 
                                ""NodeToId"" AS ""Id"", 
                                ""NodeToCode"" AS ""Code"", 
                                ""NodeToName"" AS ""Name""
	                                FROM public.""FullRates""
                        LIMIT {take} OFFSET {skip}";


        private static string GetRatesCountSql()
            => @"SELECT public.""GetRatesCount""()";

        private static string GetNonDeflatedRatesCountSql()
            => @"SELECT public.""GetNonDeflatedRatesCount""()";
    }
}