namespace Sibur.Digital.Svt.Infrastructure.Config;

public class BuildInfoOptions
{
    public const string BuildInfo = "BuildInfo";

    public string? BuildBranchName { get; set; }
    public string? BuildDate { get; set; }
}