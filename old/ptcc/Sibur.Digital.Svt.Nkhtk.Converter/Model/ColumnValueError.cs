namespace Sibur.Digital.Svt.Nkhtk.Converter.Model;

/// <summary>
/// Ошибка значения в excel шаблоне
/// </summary>
public class ColumnValueError
{
    public ColumnValueError(string shortMessage, string message)
    {
        ShortMessage = shortMessage;
        Message = message;
    }

    /// <summary>
    /// Краткое сообщение, которое при возникновении ошибки записывается в шаблон
    /// </summary>
    public string ShortMessage { get; }

    /// <summary>
    /// Полное сообщение об ошибке для логирования
    /// </summary>
    public string Message { get; }

    public override string ToString()
        => $"{ShortMessage} ({Message})";
}