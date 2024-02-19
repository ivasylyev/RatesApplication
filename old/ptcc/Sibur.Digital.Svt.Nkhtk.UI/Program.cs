using System.Net.Http.Headers;
using Microsoft.AspNetCore.Authentication.Negotiate;
using Serilog;
using Sibur.Digital.Svt.Infrastructure.Config;
using Sibur.Digital.Svt.Nkhtk.UI.Config;
using Sibur.Digital.Svt.Nkhtk.UI.Models;
using Sibur.Digital.Svt.Nkhtk.UI.Services;

const string contentType = "multipart/form-data";

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddAuthentication(NegotiateDefaults.AuthenticationScheme)
    .AddNegotiate();

builder.Services.AddAuthorization(options =>
{
    // By default, all incoming requests will be authorized according to the default policy.
    options.FallbackPolicy = options.DefaultPolicy;
});

builder.Services.AddRazorPages();
builder.Services.AddServerSideBlazor();

builder.Configuration.AddJsonFile("appsettings.Shared.json");
builder.Configuration.AddJsonFile("appsettings.BuildInfo.json");

builder.Services.Configure<UiOptions>(builder.Configuration.GetSection(UiOptions.Api));
builder.Services.Configure<BuildInfoOptions>(builder.Configuration.GetSection(BuildInfoOptions.BuildInfo));
builder.Services.AddSingleton<TemplateService>();
builder.Services.AddSingleton<WorksheetService>();
builder.Services.AddSingleton<ConverterService>();

builder.Services.AddTransient<NkhtkFileModel>();
builder.Services.AddTransient<MultiModalSpecialFileModel>();
builder.Services.AddTransient<MultiModalFileModel>();
builder.Services.AddSingleton(_ => GetHttpClient());

var logger = new LoggerConfiguration()
    .ReadFrom.Configuration(builder.Configuration)
    .Enrich.FromLogContext()
    .CreateLogger();
builder.Logging.AddSerilog(logger);

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();

app.UseStaticFiles();

app.UseRouting();

app.UseAuthentication();
app.UseAuthorization();

app.MapBlazorHub();
app.MapFallbackToPage("/_Host");

app.Run();

HttpClient GetHttpClient()
{
    string s;
    var clientHandler = new HttpClientHandler
    {
        UseDefaultCredentials = true,
        // Игнорируем проблемы с устаревшим сертификатом
        ServerCertificateCustomValidationCallback = (_, _, _, _) => true
    };
    var client = new HttpClient(clientHandler);
    client.DefaultRequestHeaders.Accept.Clear();
    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue(contentType));
    return client;
}