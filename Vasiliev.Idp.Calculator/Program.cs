using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Serilog;
using Vasiliev.Idp.Calculator.Config;
using Vasiliev.Idp.Calculator.Repository;
using Vasiliev.Idp.Calculator.Services;

HostApplicationBuilder builder = Host.CreateApplicationBuilder(args);

builder.Services.Configure<KafkaOptions>(builder.Configuration.GetSection(KafkaOptions.Kafka));
builder.Services.AddHostedService<ConsumerWorker>();
builder.Services.AddSingleton<IMessageProcessor, MessageProcessor>();
builder.Services.AddSingleton<IRateRepository, RateRepository>();
builder.Services.AddSingleton<IProducerService, ProducerService>();


var logger = new LoggerConfiguration()
    .ReadFrom.Configuration(builder.Configuration)
    .Enrich.FromLogContext()
    .CreateLogger();
builder.Logging.AddSerilog(logger);

using IHost host = builder.Build();

await host.RunAsync();