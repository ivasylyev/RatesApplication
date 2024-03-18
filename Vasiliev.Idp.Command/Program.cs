using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Serilog;
using Vasiliev.Idp.Command.Config;
using Vasiliev.Idp.Command.Repository;
using Vasiliev.Idp.Command.Services;

HostApplicationBuilder builder = Host.CreateApplicationBuilder(args);

builder.Services.Configure<KafkaOptions>(builder.Configuration.GetSection(KafkaOptions.Kafka));
builder.Services.Configure<DbOptions>(builder.Configuration.GetSection(DbOptions.Db));
builder.Services.AddHostedService<ConsumerWorker>();
builder.Services.AddSingleton<IMessageProcessor, MessageProcessor>();
builder.Services.AddSingleton<IRateRepository, RateRepository>();


var logger = new LoggerConfiguration()
    .ReadFrom.Configuration(builder.Configuration)
    .Enrich.FromLogContext()
    .CreateLogger();
builder.Logging.AddSerilog(logger);

using IHost host = builder.Build();

await host.RunAsync();