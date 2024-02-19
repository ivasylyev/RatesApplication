using System.Reflection;
using Microsoft.AspNetCore.Components;
using Microsoft.Extensions.Options;
using Sibur.Digital.Svt.Infrastructure.Config;
using Sibur.Digital.Svt.Infrastructure.Models;

namespace Sibur.Digital.Svt.Nkhtk.UI.Components;

/// <summary>
/// Компонент, отображающий информационное сообщение в футере страницы
/// </summary>
public sealed partial class SvtFooter
{
    [Inject]
    private IOptions<BuildInfoOptions> BuildInfoOptions { get; set; } = default!;

    [Inject]
    private ILogger<SvtFooter> Logger { get; set; } = default!;

    /// <summary>
    /// Информация с техническими данными о приложении
    /// </summary>
    private ProjectInfoDto FooterInfo
    {
        get
        {
            try
            {
                var assemblyName = Assembly.GetExecutingAssembly().GetName();

                var projectInfo = new ProjectInfoDto
                {
                    AssemblyName = assemblyName.Name,
                    AssemblyVersion = assemblyName.Version?.ToString(),
                    BuildBranchName = BuildInfoOptions.Value.BuildBranchName,
                    BuildDate = BuildInfoOptions.Value.BuildDate
                };
                return projectInfo;
            }
            catch (Exception ex)
            {
                Logger.LogError(ex, "Error reading footer options");
                return new ProjectInfoDto { AssemblyName = "Error" };
            }
        }
    }
}