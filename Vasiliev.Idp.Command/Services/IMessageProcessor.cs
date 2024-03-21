namespace Vasiliev.Idp.Command.Services;

public interface IMessageProcessor
{
    void Enqueue(string? message, CancellationToken ct);
    Task ProcessMessageQueue(CancellationToken ct);
}