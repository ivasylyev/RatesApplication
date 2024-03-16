using Dapper;
using Microsoft.AspNetCore.Components;
using Microsoft.Extensions.Options;
using Npgsql;
using Vasiliev.Idp.Orchestrator.Config;
using Vasiliev.Idp.Orchestrator.Models;

namespace Vasiliev.Idp.Orchestrator.Services
{
    public class QueryService :  IQueryService
    {
        string connectionString = "Host=localhost;Username=postgres;Password=14142135;Database=rates";
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
            await using var dataSource = NpgsqlDataSource.Create(connectionString);
            await using var con = dataSource.CreateConnection();
            con.Open();
            var result = await con.QueryAsync<Rate, ProductGroup, LocationNode, LocationNode, Rate>(@"
                    SELECT 
	                r.*, pg.*, nf.*, nt.*
                FROM public.""Rate"" as r
                JOIN public.""ProductGroup"" pg
	                ON pg.""Id"" = r.""ProductGroupId""
                JOIN public.""LocationNode"" nf
	                ON nf.""Id"" = r.""NodeFromId""
                JOIN public.""LocationNode"" nt
	                ON nt.""Id"" = r.""NodeToId""        
                    ", (rate, productGroup, nodeFrom, nodeTo) =>
            {
                rate.ProductGroup = productGroup;
                rate.NodeFrom = nodeFrom;
                rate.NodeTo = nodeTo;
                return rate;
            });

            foreach (var rate in result)
            {
                yield return rate;
            }
        }

        public async Task<int> GetRateCountAsync()
        {
            await using var dataSource = NpgsqlDataSource.Create(connectionString);
            await using var con = dataSource.CreateConnection();
            con.Open();
            var result = await con.ExecuteScalarAsync<int>(@"SELECT COUNT (*)	FROM public.""Rate""");
            return result;
        }
    }
}