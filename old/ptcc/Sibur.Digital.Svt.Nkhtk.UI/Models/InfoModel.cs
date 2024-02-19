namespace Sibur.Digital.Svt.Nkhtk.UI.Models;

public class InfoModel
{
    public InfoType Type { get; set; }
    public string? Text { get; set; }

    public InfoModel(string? text)
    {
        Text = text;
        Type = InfoType.Info;
    }

    public InfoModel(string text, InfoType type)
    {
        Text = text;
        Type = type;
    }
}