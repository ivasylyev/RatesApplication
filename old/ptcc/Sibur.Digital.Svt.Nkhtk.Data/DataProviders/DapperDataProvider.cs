using System.Data;
using System.Data.SqlClient;
using Sibur.Digital.Svt.Nkhtk.Data.Interfaces;

namespace Sibur.Digital.Svt.Nkhtk.Data.DataProviders;

/// <summary>
/// Провайдер данных для работы с БД c использованием Dapper
/// </summary>
public class DapperDataProvider : IDataProvider
{
    private readonly string _connectionString;

    public DapperDataProvider(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("SqlConnection");
    }

    /// <inheritdoc />
    public IDbConnection CreateConnection() => new SqlConnection(_connectionString);
}