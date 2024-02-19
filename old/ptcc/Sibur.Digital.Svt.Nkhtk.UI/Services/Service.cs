using System.Net.Http.Headers;
using Microsoft.Extensions.Options;
using Sibur.Digital.Svt.Infrastructure.Exceptions;
using Sibur.Digital.Svt.Nkhtk.UI.Config;

namespace Sibur.Digital.Svt.Nkhtk.UI.Services;

public abstract class Service : IDisposable
{
    private const string ContentType = "multipart/form-data";

    protected Service(HttpClient client, IOptions<UiOptions> options, ILogger<Service> logger)
    {
        Client = client ?? throw new ArgumentNullException(nameof(client));
        Options = options.Value ?? throw new ArgumentNullException(nameof(options), $"{nameof(options)} doesn't have Value");
        Logger = logger ?? throw new ArgumentNullException(nameof(logger));

        DataUrl = Options.BaseDataUrl ?? throw new ConfigValueNotFoundException(nameof(UiOptions.BaseDataUrl));
    }

    protected HttpClient Client { get; }

    protected ILogger<Service> Logger { get; }
    protected UiOptions Options { get; }

    protected string DataUrl { get; }

    public void Dispose()
    {
        Dispose(true);
        GC.SuppressFinalize(this);
    }

    protected virtual void Dispose(bool disposing)
    {
        if (disposing)
        {
            Client.Dispose();
        }
    }
}