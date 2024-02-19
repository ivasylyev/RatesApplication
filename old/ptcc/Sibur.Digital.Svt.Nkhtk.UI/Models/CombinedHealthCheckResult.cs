using Sibur.Digital.Svt.Infrastructure.Config;
using Sibur.Digital.Svt.Infrastructure.Models;

namespace Sibur.Digital.Svt.Nkhtk.UI.Models;

public class CombinedHealthCheckResult
{
    public SiburHealthCheckResult? DataHealthCheckResult { get; set; }
    public SiburHealthCheckResult? ConverterHealthCheckResult { get; set; }
    public ProjectInfoDto? ProjectInfo { get; set; }
}