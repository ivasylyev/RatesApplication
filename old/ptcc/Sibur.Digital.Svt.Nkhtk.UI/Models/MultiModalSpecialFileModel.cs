using System.ComponentModel.DataAnnotations;
using Microsoft.Extensions.Options;
using Sibur.Digital.Svt.Nkhtk.UI.Config;
using Sibur.Digital.Svt.Nkhtk.UI.Services;

namespace Sibur.Digital.Svt.Nkhtk.UI.Models;

public class MultiModalSpecialFileModel : FileModel
{
    private string? _effectiveLoadOfTransportType;
    private string? _productGroup;
    private string? _product;
    private string? _basis;
    private string? _currencyStandard;

    public MultiModalSpecialFileModel(IOptions<UiOptions> options,
        ConverterService converterService, TemplateService templateService, WorksheetService worksheetService,
        ILogger<FileModel> logger)
        : base(options, converterService, templateService, worksheetService, logger)
    {
    }

    [DisplayFormat(DataFormatString = "{0:N3}", ApplyFormatInEditMode = true)]
    [Required]
    public string? EffectiveLoadOfTransportType
    {
        get => _effectiveLoadOfTransportType;
        set
        {
            _effectiveLoadOfTransportType = value;
            ClearInfoAndError();
        }
    }

    /// <summary>
    /// Группа продуктов
    /// </summary>
    [Required]
    public string? ProductGroup
    {
        get => _productGroup;
        set
        {
            _productGroup = value;
            ClearInfoAndError();
        }
    }

    /// <summary>
    /// Продукт
    /// </summary>
    public string? Product
    {
        get => _product;
        set
        {
            _product = value;
            ClearInfoAndError();
        }
    }

    /// <summary>
    /// Базис поставки
    /// </summary>
    [Required]
    public string? Basis
    {
        get => _basis;
        set
        {
            _basis = value;
            ClearInfoAndError();
        }
    }

    /// <summary>
    /// Валюта-эталон
    /// </summary>
    [Required]
    public string? CurrencyStandard
    {
        get => _currencyStandard;
        set
        {
            _currencyStandard = value;
            ClearInfoAndError();
        }
    }

    private DateTime CurrencyDate { get; set; } = DateTime.Today;


    public override string GetUrlParameters()
        =>
            $"{base.GetUrlParameters()}&effectiveLoadOfTransportType={EffectiveLoadOfTransportType}&productGroup={ProductGroup}&product={Product}&currencyStandard={CurrencyStandard}&basis={Basis}&currencyDate={CurrencyDate.ToString(DateFormat)}";
}