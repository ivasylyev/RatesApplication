using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
namespace RatesKafkaAdapter;

public class KafkaService
{
    protected KafkaService(IOptions<KafkaOptions> options, ILogger<KafkaService> logger)
    {
        Options = options.Value ?? throw new ArgumentNullException(nameof(options), $"{nameof(options)} doesn't have Value");
        Logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }

    protected KafkaOptions Options { get; }
    protected ILogger<KafkaService> Logger { get; }
}