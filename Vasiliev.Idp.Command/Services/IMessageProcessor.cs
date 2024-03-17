namespace Vasiliev.Idp.Command.Services;

public interface IMessageProcessor
{
    void Process(string? message, CancellationToken ct);
}