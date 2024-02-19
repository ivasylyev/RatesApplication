using System.Reflection;

namespace Sibur.Digital.Svt.Infrastructure.Utils;

public class FileProvider
{
    public Stream GetFileStream(string name)
    {
        var directory = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
        if (directory is null)
        {
            throw new DirectoryNotFoundException("Cannot get executing assembly location");
        }

        var fullName = Path.Combine(directory, "Resources", name);
        if (!File.Exists(fullName))
        {
            throw new FileNotFoundException($"Cannot get find file {fullName}");
        }

        var fileStream = new FileStream(fullName, FileMode.Open, FileAccess.Read, FileShare.Read);
        return fileStream;
    }
}