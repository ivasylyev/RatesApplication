namespace Sibur.Digital.Svt.Infrastructure.Models;

/// <summary>
/// Тип данных бизнес-правила.
/// </summary>
public enum RuleType
{
    General = 0,

    Text = 1,
    Number = 2,
    Boolean = 3,
    DateTime = 4,
    TimeSpan = 5
}