using System.Globalization;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;
using Sibur.Digital.Svt.Nkhtk.Converter.Model;
using Sibur.Digital.Svt.Nkhtk.Converter.Transformers;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Services;

/// <inheritdoc />
public class TransformerService : ITransformerService
{
    private readonly ILogger<ITransformerService> _logger;

    public TransformerService(ILogger<ITransformerService> logger)
    {
        _logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }

    /// <inheritdoc />
    public IEnumerable<ITransformer> GetTransformers(TemplateParameters parameters, List<RuleDto> rules)
    {
        rules.Sort((r1, r2) => r1.Order.CompareTo(r2.Order));
        foreach (var rule in rules)
        {
            SetRuleParameter(parameters, rule);
            yield return GetTransformer(rule);
        }
    }

    /// <summary>
    /// Создает экземпляр <see cref="ITransformer" /> на основании описания бизнес правила <see cref="RuleDto" />
    /// </summary>
    /// <param name="rule">Бизнес-правило</param>
    /// <returns>Новый экземпляр преобразователя из исходного шаблона в шаблон СВТ</returns>
    private ITransformer GetTransformer(RuleDto rule) =>
        rule.RuleKind switch
        {
            // todo: Use DI
            RuleKind.SourceSheetDeleteRows => new DeleteInvalidSourceRowsTransformer(rule, _logger),
            RuleKind.SourceColumnCopy => new SourceColumnCopyTransformer(rule, _logger),
            RuleKind.SourceColumnCopyDictionaryOnly => new SourceColumnCopyDictionaryOnlyTransformer(rule, _logger),
            RuleKind.DestinationColumnCopy => new DestinationColumnCopyTransformer(rule, _logger),

            // Для правила выставления константы в качекстве значения шаблона СВТ
            // и для правила выставления параметра извне в качекстве значения шаблона СВТ
            // используем один и тот же конвертер 
            RuleKind.DestinationSheetConstant => new DestinationSheetConstantTransformer(rule, _logger),
            RuleKind.SheetParameter => new DestinationSheetConstantTransformer(rule, _logger),

            RuleKind.SourceSheetConstant => new SourceSheetConstantTransformer(rule, _logger),

            RuleKind.SheetMultiplier => new SheetMultiplierTransformer(rule, _logger),

            // Для вертикального и горизонтального расположения ячейки используется один и тот же конвертер
            RuleKind.VerticalCellCopy => new CellCopyTransformer(rule, _logger),
            RuleKind.HorizontalCellCopy => new CellCopyTransformer(rule, _logger),

            _ => throw new NotSupportedException($"Transformer for {rule.RuleKind} is not implemented")
        };

    /// <summary>
    /// Заполняет словарь юизнес-правила значениями из параметров исходного шаблона
    /// </summary>
    /// <param name="parameters">Параметры исходного шаблона</param>
    /// <param name="rule">Бизнес-правило</param>
    private void SetRuleParameter(TemplateParameters parameters, RuleDto rule)
    {
        // todo: при увеличении количества параметров нужно подумать о маппинге
        if (rule.RuleKind == RuleKind.SheetParameter)
        {
            SetRuleDictionary(rule, nameof(parameters.StartDate), parameters.StartDate.ToString(CultureInfo.InvariantCulture));
            SetRuleDictionary(rule, nameof(parameters.EndDate), parameters.EndDate.ToString(CultureInfo.InvariantCulture));
            SetRuleDictionary(rule, nameof(parameters.CurrencyRateMonth), parameters.CurrencyRateMonth.ToString(CultureInfo.InvariantCulture));
            SetRuleDictionary(rule, nameof(parameters.CurrencyDate), parameters.CurrencyDate.ToString(CultureInfo.InvariantCulture));

            SetRuleDictionary(rule, nameof(parameters.ProductGroup), parameters.ProductGroup);
            SetRuleDictionary(rule, nameof(parameters.Product), parameters.Product);
            SetRuleDictionary(rule, nameof(parameters.Basis), parameters.Basis);
            var effLoad = parameters.EffectiveLoadOfTransportType?.ToString(CultureInfo.InvariantCulture);
            SetRuleDictionary(rule, nameof(parameters.EffectiveLoadOfTransportType), effLoad);
            SetRuleDictionary(rule, nameof(parameters.Leg1_EffectiveLoad), effLoad); // для обоих плеч проставляем одну и ту же загрузку из общего параметра
            SetRuleDictionary(rule, nameof(parameters.Leg2_EffectiveLoad), effLoad);
            SetRuleDictionary(rule, nameof(parameters.CurrencyStandard), parameters.CurrencyStandard);
            var generalCurrency = parameters.GeneralCurrency;
            SetRuleDictionary(rule, nameof(parameters.GeneralCurrency), generalCurrency);
            SetRuleDictionary(rule, nameof(parameters.Leg1_BaseCurrency), generalCurrency);// для обоих плеч проставляем одну и ту же валюту из общего параметра
            SetRuleDictionary(rule, nameof(parameters.Leg2_BaseCurrency), generalCurrency);
        }
    }

    private static void SetRuleDictionary(RuleDto rule, string paramName, string? paramValue)
    {
        if (rule.DestinationColumn == paramName)
        {
            var dictionaryValue = paramValue ?? string.Empty;
            rule.Dictionary = new RuleDictionaryDto(new List<RuleDictionaryItemDto> { new(dictionaryValue) });
        }
    }
}