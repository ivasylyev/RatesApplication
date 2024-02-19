using Microsoft.AspNetCore.Diagnostics.HealthChecks;
using Microsoft.OpenApi.Models;
using Serilog;
using Sibur.Digital.Svt.Infrastructure.Filters;
using Sibur.Digital.Svt.Infrastructure.Utils;
using Sibur.Digital.Svt.Nkhtk.Converter.Config;
using Sibur.Digital.Svt.Nkhtk.Converter.DataProviders;
using Sibur.Digital.Svt.Nkhtk.Converter.Extensions;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;
using Sibur.Digital.Svt.Nkhtk.Converter.Services;

var builder = WebApplication.CreateBuilder(args);
builder.Configuration.AddJsonFile("appsettings.BuildInfo.json");
builder.Configuration.AddJsonFile("appsettings.Shared.json");

// Add services to the container.

builder.Services.AddHealthChecks()
    .AddCheck<HealthCheckService>(nameof(HealthCheckService));

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var logger = new LoggerConfiguration()
    .ReadFrom.Configuration(builder.Configuration)
    .Enrich.FromLogContext()
    .CreateLogger();
builder.Logging.AddSerilog(logger);

ConfigureServices(builder);

var app = builder.Build();

app.MapHealthChecks("/hc", new HealthCheckOptions { ResponseWriter = HealthCheckResponseWriter.WriteResponseAsync });

// Configure the HTTP request pipeline.
app.UseSwagger();
app.UseSwaggerUI();

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.StartAppDomainLogger();

app.Run();

static void ConfigureServices(WebApplicationBuilder appBuilder)
{
    // Лучше использовать singletone, потому что вунтри используется HttpClient
    // не рекомендуется для каждого запроса создавать HttpClient
    // как минимум, чтобы избежать утечек памяти.
    appBuilder.Services.AddSingleton<IApiDataProvider, ApiDataProvider>();
    appBuilder.Services.AddSingleton<IHttpDecorator, HttpDecorator>();
    appBuilder.Services.AddSingleton<AppDomainAssemblyLogger>();

    appBuilder.Services.AddScoped<IRuleService, RuleService>();
    appBuilder.Services.AddScoped<ISvtTemplateService, HddSvtTemplateService>();

    appBuilder.Services.AddScoped<ITransformerService, TransformerService>();

    appBuilder.Services.AddScoped<IConverterService, ConverterService>();
    appBuilder.Services.AddScoped<IWorksheetService, WorksheetService>();
    appBuilder.Services.AddScoped<AuditFilter>();
    appBuilder.Services.AddScoped<SvtExceptionFilterAttribute>();

    // Должен быть AddTransient, т.к. при каждом новом обращении будет использоваться новый файл
    appBuilder.Services.AddTransient<IExcelDecorator, ExcelDecorator>();

    appBuilder.Services.Configure<ApiOptions>(appBuilder.Configuration.GetSection(ApiOptions.Api));

    appBuilder.Services.AddSwaggerGen(c =>
    {
        c.SwaggerDoc("v1", new OpenApiInfo
        {
            Title = "SVT Converter Api",
            Version = "v1"
        });
        c.OperationFilter<SwaggerFileOperationFilter>();
    });
}