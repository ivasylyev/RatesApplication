using System.ComponentModel.DataAnnotations;
using Microsoft.Extensions.Options;
using Sibur.Digital.Svt.Nkhtk.UI.Config;
using Sibur.Digital.Svt.Nkhtk.UI.Services;

namespace Sibur.Digital.Svt.Nkhtk.UI.Models;

public class MultiModalFileModel : FileModel
{
    private string? _effectiveLoadOfTransportType;
    private string? _generalCurrency;
    private string? _product;
    private string? _productGroup;

    public MultiModalFileModel(IOptions<UiOptions> options,
        ConverterService converterService, TemplateService templateService, WorksheetService worksheetService,
        ILogger<FileModel> logger)
        : base(options, converterService, templateService, worksheetService, logger)
    {
    }

    /// <summary>
    /// Эффективная загрузка
    /// </summary>
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
    /// Общая валюта затрат
    /// </summary>
    [Required]
    public string? GeneralCurrency
    {
        get => _generalCurrency;
        set
        {
            _generalCurrency = value;
            ClearInfoAndError();
        }
    }

    public override string GetUrlParameters()
        => $"{base.GetUrlParameters()}&effectiveLoadOfTransportType={EffectiveLoadOfTransportType}&productGroup={ProductGroup}&product={Product}&generalCurrency={GeneralCurrency}";
}