namespace Sibur.Digital.Svt.Infrastructure.Models;

public class ProjectInfoDto
{
    /// <summary>
    /// Ветка, из которой произвели сборку
    /// </summary>
    public string? BuildBranchName { get; set; }

    /// <summary>
    /// Дата сборки в виде строки, чтобы не зависеть от формата, в котором дата записана в файле
    /// </summary>
    public string? BuildDate { get; set; }

    /// <summary>
    /// Имя сборки
    /// </summary>
    public string? AssemblyName { get; set; }

    /// <summary>
    /// Версия сборки
    /// </summary>
    public string? AssemblyVersion { get; set; }
}