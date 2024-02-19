using Microsoft.AspNetCore.Components.Forms;
using Sibur.Digital.Svt.Infrastructure.Utils;

namespace Sibur.Digital.Svt.Nkhtk.UI.Models;

public class StreamModel
{
    private StreamModel(Stream stream)
    {
        stream.ThrowIfNull(nameof(stream));
        Stream = stream;
    }

    public Stream Stream { get; }
    public long Size => Stream.Length;

    public static async Task<StreamModel> GetStreamFromFileAsync(IBrowserFile file, int maxAllowedFileSizeBytes)
    {
        var openReadStream = file.OpenReadStream(maxAllowedFileSizeBytes);
        var memStream = new MemoryStream();
        await openReadStream.CopyToAsync(memStream);
        await memStream.FlushAsync();
        memStream.Position = 0;
        var model = new StreamModel(memStream);
        return model;
    }
}