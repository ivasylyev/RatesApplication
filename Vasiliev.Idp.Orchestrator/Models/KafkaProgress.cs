namespace Vasiliev.Idp.Orchestrator.Models;

public class KafkaProgress
{
    private const int HundredPercent = 100;
    public int CurrentProgress { get; private set; }
    public int CurrentCount { get; private set; }
    public int TotalCount { get; }

    public KafkaProgress(int totalCount)
    {
        if (totalCount <= 0)
            throw new ArgumentOutOfRangeException(nameof(totalCount), $"{nameof(totalCount)} must be positive");
        TotalCount = totalCount;
    }

    public bool Increment(int delta)
    {
        CurrentCount += delta;

        var newProgress = Math.Min(HundredPercent, HundredPercent * CurrentCount / TotalCount);
        var hasChanged = CurrentProgress != newProgress;

        CurrentProgress = newProgress;
        return hasChanged;
    }

    public void Reset()
    {
        CurrentProgress = 0;
        CurrentCount = 0;
    }
}