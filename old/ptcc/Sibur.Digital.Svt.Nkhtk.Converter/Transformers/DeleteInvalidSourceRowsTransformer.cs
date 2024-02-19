using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Infrastructure.Utils;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Transformers;

/// <summary>
/// Преобразователь, удаляющий строки из исходного шаблона. Критерий удаления - наличие значения ячейки в словаре передаваемого правила
/// </summary>
public class DeleteInvalidSourceRowsTransformer : Transformer
{
    public DeleteInvalidSourceRowsTransformer(RuleDto rule, ILogger logger) : base(rule, logger)
    {
        if (rule.RuleKind != RuleKind.SourceSheetDeleteRows)
        {
            throw new ArgumentException(
                $"Тип правила {nameof(rule)}.{nameof(rule.RuleKind)} должен быть {RuleKind.SourceSheetDeleteRows}");
        }
    }


    /// <summary>
    /// Преобразователь удаляет невалидные строчки исходного шаблона мультимодальных перевозок
    /// </summary>
    /// <param name="source">Исходный шаблон</param>
    /// <param name="target">Шаблон СВТ - не используется</param>
    public override void Apply(IExcelDecorator source, IExcelDecorator target)
    {
        source.ThrowIfNull(nameof(source));
        
        Logger.LogDebug("Запуск трансформации {t} для правила ({id}): '{desc}'", GetType().Name, Rule.RuleId, Rule.Description);

        var garbageValues = new HashSet<string>(Dictionary.Keys);
        var columnNames = Rule.SourceEntity.GetItemNames();

        var rows = source.DeleteGarbageRows(v => garbageValues.Contains(v), columnNames);
        Logger.LogDebug("Из исходного файла удалено {r} строк", rows);

        Logger.LogDebug("Закончена трансформация {t} для правила ({id}).", GetType().Name, Rule.RuleId);
    }
}