namespace Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;

public interface IHttpDecorator : IDisposable
{
    HttpResponseMessage Get(Uri url);
    HttpResponseMessage Post(Uri url, HttpContent content);
    Task<HttpResponseMessage> GetAsync(Uri url);
    Task<HttpResponseMessage> PostAsync(Uri url, HttpContent content);
}