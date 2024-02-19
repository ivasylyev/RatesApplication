using System;
using System.Linq;
using System.Threading.Tasks;
using FluentAssertions;
using Moq;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.Data.DataProviders;
using Sibur.Digital.Svt.Nkhtk.Data.Interfaces;
using Sibur.Digital.Svt.Nkhtk.Data.Repositories;
using Xunit;

namespace Sibur.Digital.Svt.Nkhtk.Data.Tests.Repositories;

public class RuleRepositoryTests
{
    [Fact(DisplayName = "Can create RuleRepository.")]
    [Trait("Category", "Unit")]
    public void Can_Create_Instance()
    {
        // Arrange
        var provider = Mock.Of<IDataProvider>();

        // Act
        var exception = Record.Exception(() => new RuleRepository(provider));

        // Assert
        exception.Should().BeNull();
    }

    [Fact(DisplayName = "RuleRepository can return all  Rules for the first Template.")]
    [Trait("Category", "Integration")]
    public async Task Can_Return_Rules_By_Template()
    {
        // Arrange
        var config = ConfigurationHelper.GetConfiguration(MockBehavior.Strict);
        var provider = new DapperDataProvider(config);

        var templateRepository = new TemplateRepository(provider);
        var template = (await templateRepository.GetTemplatesAsync(1))
            .First();

        var ruleRepository = new RuleRepository(provider);

        // Act
        var rules = (await ruleRepository.GetRulesAsync(template.Worksheets.First().WorksheetId))
            .ToArray();

        // Assert
#pragma warning disable CS8602
        rules.Should().NotBeNull();
        rules.Should().HaveCountGreaterThan(0);

        var rule = rules.FirstOrDefault();
        rule.Should().NotBeNull();
        rule.DestinationColumn.Should().NotBeNull();

        rule.RuleId.Should().BeGreaterThan(0);
        Assert.True(rule != null && Enum.IsDefined(typeof(RuleKind), rule.RuleKind));
        rule.RuleKind.Should().NotBe(RuleKind.None);

        // проверяем существование правил, у которых присутствует оператор
        // то есть существуют правила каким-то оператором, напримре, плюс или минус. Иначе это может быть ошибкой маппинга из базы.
        var ruleWithOperator = rules.FirstOrDefault(r => r.RuleOperator != RuleOperator.None);
        ruleWithOperator.Should().NotBeNull();

        // проверяем существование правил, у которых данные не являются общим типом
        // то есть существуют правила с типом число или дата. Иначе это может быть ошибкой маппинга из базы.
        var ruleWithNonGeneralData = rules.FirstOrDefault(r => r.RuleDataType != RuleType.General);
        ruleWithNonGeneralData.Should().NotBeNull();

        // Проверяем существование правила, у которого пустая исходная сущность(колонка или ячейка).
        // Например, правило валюты, которому не нужна колонка или ячейка из исходного шаблона
        // проверяем, что у этой сущости все поля "по нулям"
        var emptyEntityRule = rules.FirstOrDefault(r => r.SourceEntity.RuleEntityId is null);
        emptyEntityRule.Should().NotBeNull();
        emptyEntityRule.SourceEntity.RuleEntityName.Should().BeNull();
        emptyEntityRule.SourceEntity.RuleEntityDescription.Should().BeNull();
        emptyEntityRule.SourceEntity.RuleEntityItems.Should().BeEmpty();

        // Проверяем существование правила, у которого пустой словарь 
        // Например, правило копирования загрузки, которое просто копирует без поиса по словарю
        // проверяем, что у этого пустого словаря все поля "по нулям"
        var emptyDictRule = rules.FirstOrDefault(r => r.Dictionary.RuleDictionaryId is null);
        emptyDictRule.Should().NotBeNull();
        emptyDictRule.Dictionary.RuleDictionaryName.Should().BeNull();
        emptyDictRule.Dictionary.RuleDictionaryDescription.Should().BeNull();
        emptyDictRule.Dictionary.RuleDictionaryItems.Should().BeEmpty();


        // Проверяем существование правила, у которого НЕ пустая исходная сущность(колонка или ячейка).
        // Например,  правило копирования загрузки, которому нужна колонка в исходном шаблоне
        // проверяем, что у этой сущности, т.е. колонки, все поля заполнены
        var existingEntityRule = rules.FirstOrDefault(r => r.SourceEntity.RuleEntityId is not null);
        existingEntityRule.Should().NotBeNull();
        existingEntityRule.SourceEntity.RuleEntityName.Should().NotBeNull();
        existingEntityRule.SourceEntity.RuleEntityDescription.Should().NotBeNull();
        existingEntityRule.SourceEntity.RuleEntityItems.Should().NotBeEmpty();


        // Проверяем существование правила, у которого НЕ пустой словарь 
        // Например, правило узла отправления или назначения, которое по имени подставляет код узла в СВТ
        // проверяем, что у этого НЕ пустого словаря все поля заполнены и есть элементы
        var existingDictRule = rules.FirstOrDefault(r => r.Dictionary.RuleDictionaryId is not null);
        existingDictRule.Should().NotBeNull();
        existingDictRule.Dictionary.RuleDictionaryName.Should().NotBeEmpty();
        existingDictRule.Dictionary.RuleDictionaryDescription.Should().NotBeEmpty();
        existingDictRule.Dictionary.RuleDictionaryItems.Should().NotBeEmpty();
#pragma warning restore CS8602
    }

    [Fact(DisplayName = "RuleRepository will fail with unknown worksheet id.")]
    [Trait("Category", "Integration")]
    public async Task Unknown_Id_Fail()
    {
        // Arrange
        var config = ConfigurationHelper.GetConfiguration(MockBehavior.Strict);
        var provider = new DapperDataProvider(config);
        var repository = new RuleRepository(provider);

        // Act
        var exception = await Record.ExceptionAsync(async () => await repository.GetRulesAsync(-1));

        // Assert

        exception.Should().NotBeNull();
        exception?.Message.Should().Contain("Не найдены бизнес-правила для вкладки с идентификатором -1");
    }
}