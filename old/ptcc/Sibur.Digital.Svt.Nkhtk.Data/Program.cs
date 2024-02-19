using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Diagnostics.HealthChecks;
using Microsoft.OpenApi.Models;
using Serilog;
using Sibur.Digital.Svt.Infrastructure.Filters;
using Sibur.Digital.Svt.Infrastructure.Utils;
using Sibur.Digital.Svt.Nkhtk.Data.DataProviders;
using Sibur.Digital.Svt.Nkhtk.Data.Extensions;
using Sibur.Digital.Svt.Nkhtk.Data.Interfaces;
using Sibur.Digital.Svt.Nkhtk.Data.Repositories;
using Sibur.Digital.Svt.Nkhtk.Data.Services;

var builder = WebApplication.CreateBuilder(args);
builder.Configuration.AddJsonFile("appsettings.Shared.json");
builder.Configuration.AddJsonFile("appsettings.BuildInfo.json");

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
    appBuilder.Services.AddSingleton<AppDomainAssemblyLogger>();

    appBuilder.Services.AddScoped<IDataProvider, DapperDataProvider>();

    appBuilder.Services.AddScoped<ITemplateRepository, TemplateRepository>();
    appBuilder.Services.AddScoped<IWorksheetRepository, WorksheetRepository>();

    appBuilder.Services.AddScoped<IRuleRepository, RuleRepository>();

    appBuilder.Services.AddScoped<AuditFilter>();
    appBuilder.Services.AddScoped<SvtExceptionFilterAttribute>();

    appBuilder.Services.AddControllers().AddJsonOptions(x =>
        x.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles);

    appBuilder.Services.AddSwaggerGen(c =>
    {
        c.SwaggerDoc("v1", new OpenApiInfo
        {
            Title = "SVT Data Api",
            Version = "v1"
        });
    });
}