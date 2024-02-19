using Microsoft.Extensions.Logging;
namespace RatesKafkaAdapter;

public class KafkaService
{
    protected KafkaService(ILogger<KafkaService> logger)
    {
        Logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }

    protected ILogger<KafkaService> Logger { get; }
}