using System.Data;
using Dapper;
using Sibur.Digital.Svt.Infrastructure.Exceptions;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.Data.Interfaces;

namespace Sibur.Digital.Svt.Nkhtk.Data.Repositories;

/// <inheritdoc />
public class RuleRepository : IRuleRepository
{
    private readonly IDataProvider _provider;

    public RuleRepository(IDataProvider provider)
    {
        _provider = provider;
    }

    /// <inheritdoc />
    public async Task<List<RuleDto>> GetRulesAsync(int worksheetId)
    {
        var rules = await GetRulesInternalAsync(worksheetId)
            .ConfigureAwait(false);
        var entities = await GetEntitiesInternalAsync(worksheetId)
            .ConfigureAwait(false);
        var dictionaries = await GetDictionariesInternalAsync(worksheetId)
            .ConfigureAwait(false);

        foreach (var rule in rules)
        {
            // привязывает сущности (столбцу или ячейки шаблона) к правилам по ключу.
            // Это необходимо т.к. процедура получения правил вытаскивает только ключ сущности, а не ее всю целиком
            // Если ключ null то значит, правило не имеет связанных сущностей
            var entityId = rule.SourceEntity.RuleEntityId;
            if (entityId.HasValue)
            {
                if (!entities.TryGetValue(entityId.Value, out var entity))
                {
                    throw new EntityNotFoundException(worksheetId, entityId.Value);
                }

                rule.SourceEntity = entity;
            }

            // привязывает словарь к правилам по ключу.
            // Это необходимо т.к. процедура получения правил вытаскивает только ключ словаря, а не весь его целиком
            // Если ключ null то значит, правило не имеет связанных словарей
            var dictionaryId = rule.Dictionary.RuleDictionaryId;
            if (dictionaryId.HasValue)
            {
                if (!dictionaries.TryGetValue(dictionaryId.Value, out var dictionary))
                {
                    throw new EntityNotFoundException(worksheetId, dictionaryId.Value);
                }

                rule.Dictionary = dictionary;
            }
        }
        return rules;
    }

    /// <summary>
    /// Выполняет запрос бизнес-правил из БД
    /// </summary>
    /// <param name="worksheetId">Идентификатор исходного шаблона</param>
    /// <returns>Список бизнес-правил</returns>
    private async Task<List<RuleDto>> GetRulesInternalAsync(int worksheetId)
    {
        using var con = _provider.CreateConnection();
        var rules = (await con.QueryAsync<RuleDto, RuleExtensionDto, RuleDto>("[nkhtk].[GetRules]",
                param: new { worksheetId },
                commandType: CommandType.StoredProcedure,
                map: (rule, extension) =>
                {
                    if (extension != null)
                    {
                        rule.SourceEntity = new RuleEntityDto { RuleEntityId = extension.RuleEntityId };
                        rule.Dictionary = new RuleDictionaryDto { RuleDictionaryId = extension.RuleDictionaryId };
                    }

                    return rule;
                },
                splitOn: nameof(RuleExtensionDto.RuleId))
            .ConfigureAwait(false))
            .AsList();

        if (!rules.Any())
        {
            throw new RuleNotFoundException(worksheetId);
        }

        return rules;
    }

    /// <summary>
    /// Выполняет запрос сущностей шаблона (столбец или ячейка) я из БД
    /// </summary>
    /// <param name="worksheetId">Идентификатор исходного шаблона</param>
    /// <returns>Список сущностей шаблона</returns>
    private async Task<Dictionary<int, RuleEntityDto>> GetEntitiesInternalAsync(int? worksheetId = null)
    {
        var entityMap = new Dictionary<int, RuleEntityDto>();

        using var con = _provider.CreateConnection();
        await con.QueryAsync<RuleEntityDto, RuleEntityItemDto, RuleEntityDto>("[nkhtk].[GetRuleEntities]",
                param: new { worksheetId },
                commandType: CommandType.StoredProcedure,
                map: (entity, item) =>
                {
                    if (entity.RuleEntityId.HasValue)
                    {
                        if (entityMap.TryGetValue(entity.RuleEntityId.Value, out var existingEntity))
                        {
                            entity = existingEntity;
                        }
                        else
                        {
                            entityMap.Add(entity.RuleEntityId.Value, entity);
                        }

                        if (item != null)
                        {
                            entity.RuleEntityItems.Add(item);
                        }
                    }

                    return entity;
                },
                splitOn: nameof(RuleEntityItemDto.RuleEntityItemId))
            .ConfigureAwait(false);

        return entityMap;
    }


    /// <summary>
    /// Выполняет запрос словарей из БД
    /// </summary>
    /// <param name="worksheetId">Идентификатор исходного шаблона</param>
    /// <returns>Список словарей</returns>
    private async Task<Dictionary<int, RuleDictionaryDto>> GetDictionariesInternalAsync(int? worksheetId = null)
    {
        var dictionaryMap = new Dictionary<int, RuleDictionaryDto>();

        using var con = _provider.CreateConnection();
        await con.QueryAsync<RuleDictionaryDto, RuleDictionaryItemDto, RuleDictionaryDto>("[nkhtk].[GetRuleDictionaries]",
                param: new { worksheetId },
                commandType: CommandType.StoredProcedure,
                map: (dictionary, item) =>
                {
                    if (dictionary.RuleDictionaryId.HasValue)
                    {
                        if (dictionaryMap.TryGetValue(dictionary.RuleDictionaryId.Value, out var existingDictionary))
                        {
                            dictionary = existingDictionary;
                        }
                        else
                        {
                            dictionaryMap.Add(dictionary.RuleDictionaryId.Value, dictionary);
                        }

                        if (item != null)
                        {
                            dictionary.RuleDictionaryItems.Add(item);
                        }
                    }

                    return dictionary;
                },
                splitOn: nameof(RuleDictionaryItemDto.RuleDictionaryItemId))
            .ConfigureAwait(false);

        return dictionaryMap;
    }
}