using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using Sibur.Digital.Svt.Infrastructure.Utils;
using Sibur.Digital.Svt.Nkhtk.Converter.Config;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;

namespace Sibur.Digital.Svt.Nkhtk.Converter.DataProviders;

/// <inheritdoc cref="IApiDataProvider"/>
public class ApiDataProvider : IApiDataProvider, IDisposable
{
    private readonly IHttpDecorator _httpClient;
    private readonly string _baseUrl;

    private bool _disposed;

    public ApiDataProvider(IHttpDecorator httpClient, IOptions<ApiOptions> options)
    {
        _httpClient = httpClient;
        _baseUrl = options.Value?.BaseUrl ??
                   throw new ArgumentNullException(nameof(options), $"{nameof(options)} doesn't have parameter {nameof(ApiOptions.BaseUrl)} specified");
    }

    /// <inheritdoc />
    public async Task<T> GetAsync<T>(string apiControllerAction, IDictionary<string, string>? parameters)
    {
        apiControllerAction.ThrowIfNullOrEmpty(nameof(apiControllerAction));

        var parametersString = CreateParametersString(parameters);
        var requestUri = new Uri($"{_baseUrl}/{apiControllerAction}?{parametersString}");

        try
        {
            var response = await _httpClient.GetAsync(requestUri)
                .ConfigureAwait(false);
            var rawContent = await response.Content.ReadAsStringAsync()
                .ConfigureAwait(false);
             
            if (!response.IsSuccessStatusCode)
            {
                throw new ApiDataException($"Error reading from {requestUri}. Status Code: '{response.StatusCode}'. Content: '{rawContent}'");
            }

            try
            {
                var content = JsonConvert.DeserializeObject<T>(rawContent);
                if (content != null)
                {
                    return content;
                }
            }
            catch (Exception ex)
            {
                throw new ApiDataException($"Could not deserialize content from '{requestUri}'. Raw content: '{rawContent}'", ex);
            }

            throw new ApiDataException($"Deserialized content from '{requestUri}' is null. Raw content: '{rawContent}'");
        }
        catch (ApiDataException)
        {
            throw;
        }
        catch (Exception ex)
        {
            throw new ApiDataException($"Error reading from '{requestUri}'", ex);
        }
    }

    private static string CreateParametersString(IDictionary<string, string>? parameters) =>
        parameters is null
            ? string.Empty
            : string.Join("&", parameters.Select(kv => $"{kv.Key}={kv.Value}"));

    public void Dispose()
    {
        Dispose(true);
        GC.SuppressFinalize(this);
    }

    protected virtual void Dispose(bool disposing)
    {
        if (_disposed)
        {
            return;
        }

        if (disposing)
        {
            _httpClient.Dispose();
        }

        _disposed = true;
    }
}