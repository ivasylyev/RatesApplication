using System.Data;
using Dapper;
using Sibur.Digital.Svt.Infrastructure.Exceptions;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.Data.Interfaces;

namespace Sibur.Digital.Svt.Nkhtk.Data.Repositories;

/// <inheritdoc />
public class WorksheetRepository : IWorksheetRepository
{
    private readonly IDataProvider _provider;

    public WorksheetRepository(IDataProvider provider)
    {
        _provider = provider;
    }

    /// <inheritdoc />
    public async Task<WorksheetDto> GetWorksheetAsync(int worksheetId)
    {
        using var con = _provider.CreateConnection();
        var worksheet = await con
            .QueryFirstOrDefaultAsync<WorksheetDto>("[nkhtk].[GetWorksheet]", new { worksheetId }, commandType: CommandType.StoredProcedure)
            .ConfigureAwait(false);
        if (worksheet is null)
        {
            throw new WorksheetNotFoundException(worksheetId);
        }

        return worksheet;
    }
}