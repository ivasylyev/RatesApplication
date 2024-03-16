
using Serilog;
using Vasiliev.Idp.Orchestrator.Components;
using Vasiliev.Idp.Orchestrator.Config;
using Vasiliev.Idp.Orchestrator.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorComponents()
    .AddInteractiveServerComponents();
builder.Services.Configure<KafkaOptions>(builder.Configuration.GetSection(KafkaOptions.Kafka));
builder.Services.Configure<DbOptions>(builder.Configuration.GetSection(DbOptions.Db));
builder.Services.AddSingleton<IQueryService, QueryService>();
builder.Services.AddSingleton<IKafkaProducerService, KafkaProducerService>();
builder.Services.AddSingleton<CalculatorFacadeService>();

var logger = new LoggerConfiguration()
    .ReadFrom.Configuration(builder.Configuration)
    .Enrich.FromLogContext()
    .CreateLogger();
builder.Logging.AddSerilog(logger);

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error", true);
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();

app.UseStaticFiles();
app.UseAntiforgery();

app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode();

app.Run();