using Microsoft.AspNetCore.Components;
using Npgsql;
using Vasiliev.Idp.Orchestrator.Models;
using Vasiliev.Idp.Orchestrator.Services;

namespace Vasiliev.Idp.Orchestrator.Components.Pages;

public partial class Rates
{
    private const int PageSize = 15;
    bool _skipped;

    [Inject] 
    private IQueryService QueryService { get; set; } = default!;

    private Rate[]? _rates;
    private int _rateCount;
    private int _currentPageNumber = 1;

    protected override async Task OnInitializedAsync()
    {
        _rates = await QueryService.GetRatesAsync(PageSize).ToArrayAsync();
        _rateCount = await QueryService.GetRateCountAsync();


        try
        {
            var connectionString = "Host=localhost;Username=postgres;Password=14142135;Database=rates";
            await using var dataSource = NpgsqlDataSource.Create(connectionString);

            // Insert some data
            // await using (var cmd = dataSource.CreateCommand("INSERT INTO data (some_field) VALUES ($1)"))
            //  {
            //      cmd.Parameters.AddWithValue("Hello world");
            //       await cmd.ExecuteNonQueryAsync();
            //  }

            // Retrieve all rows
            await using (var cmd = dataSource.CreateCommand("SELECT '222' some_field"))
            await using (var reader = await cmd.ExecuteReaderAsync())
            {
                while (await reader.ReadAsync())
                {
                    var format = reader.GetString(0);
                    Console.WriteLine(format);
                }
            }
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            throw;
        }
        
    }

    private async Task PageSelected(int page)
    {
        _currentPageNumber = page;
        _rates = await QueryService.GetRatesAsync(PageSize, (page - 1) * PageSize).ToArrayAsync();
    }
}