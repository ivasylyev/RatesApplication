using System.Net;
using System.Net.Http.Headers;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;

namespace Sibur.Digital.Svt.Nkhtk.Converter.DataProviders;

public class HttpDecorator : IHttpDecorator
{
    private readonly HttpClient _client;
    private bool _disposed;

    public HttpDecorator()
    {
        //Accept all server certificate
        ServicePointManager.ServerCertificateValidationCallback = delegate { return true; };

        var clientHandler = new HttpClientHandler
        {
            UseDefaultCredentials = true,
            // Игнорируем проблемы с устаревшим сертификатом
            ServerCertificateCustomValidationCallback = (_, _, _, _) => true
        };
        _client = new HttpClient(clientHandler);
        _client.DefaultRequestHeaders.Accept.Clear();
        _client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
    }

    public void Dispose()
    {
        Dispose(true);
        GC.SuppressFinalize(this);
    }


    public HttpResponseMessage Get(Uri url)
        => GetAsync(url)
            .GetAwaiter()
            .GetResult();

    public HttpResponseMessage Post(Uri url, HttpContent content)
        => PostAsync(url, content)
            .GetAwaiter()
            .GetResult();

    public async Task<HttpResponseMessage> GetAsync(Uri url)
        => await _client.GetAsync(url)
            .ConfigureAwait(false);

    public async Task<HttpResponseMessage> PostAsync(Uri url, HttpContent content)
        => await _client.PostAsync(url, content)
            .ConfigureAwait(false);

    protected virtual void Dispose(bool disposing)
    {
        if (_disposed)
        {
            return;
        }

        if (disposing)
        {
            _client.Dispose();
        }

        _disposed = true;
    }
}