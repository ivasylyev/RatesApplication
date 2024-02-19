using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.Converter.Model;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;

/// <summary>
/// Служит для инстанцирования преобразователей из исходного шаблона в шаблон СВТ на основании описания бизнес правил
/// </summary>
public interface ITransformerService
{
    /// <summary>
    /// Создает экземпляр <see cref="ITransformer" /> на основании описания бизнес правила <see cref="RuleDto" />
    /// </summary>
    /// ///
    /// <param name="parameters">Параметры, которые могут быть подставлены в бизнес правила</param>
    /// <param name="rules">Список бизнес правил</param>
    /// <returns>Трансформеты, преобразующие исходный шаблона в СВТ</returns>
    IEnumerable<ITransformer> GetTransformers(TemplateParameters parameters, List<RuleDto> rules);
}