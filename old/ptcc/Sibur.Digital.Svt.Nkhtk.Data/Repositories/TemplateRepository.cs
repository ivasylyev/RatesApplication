using System.Data;
using Dapper;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.Data.Interfaces;

namespace Sibur.Digital.Svt.Nkhtk.Data.Repositories;

/// <inheritdoc />
public class TemplateRepository : ITemplateRepository
{
    private readonly IDataProvider _provider;

    public TemplateRepository(IDataProvider provider)
    {
        _provider = provider;
    }

    /// <inheritdoc />
    public async Task<IEnumerable<TemplateDto>> GetTemplatesAsync(int templateTypeId)
    {
        var templateMap = new Dictionary<int, TemplateDto>();

        using var con = _provider.CreateConnection();
        var templates = await con.QueryAsync<TemplateDto, WorksheetDto, TemplateDto>("[nkhtk].[GetTemplates]",
                param: new { templateTypeId },
                commandType: CommandType.StoredProcedure,
                map: (template, worksheet) =>
                {
                    if (templateMap.TryGetValue(template.TemplateId, out var existingTemplate))
                    {
                        template = existingTemplate;
                    }
                    else
                    {
                        templateMap.Add(template.TemplateId, template);
                    }

                    template.Worksheets.Add(worksheet);
                    return template;
                },
                splitOn: nameof(WorksheetDto.WorksheetId))
            .ConfigureAwait(false);

        // убираем дублирование шаблонов
        return templates.ToHashSet();
    }
}