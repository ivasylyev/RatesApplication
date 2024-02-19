namespace Sibur.Digital.Svt.Nkhtk.UI.Models;

public class SvtSelectListItem
{
    public int Value { get; set; }
    public string? Text { get; set; }

    public SvtSelectListItem(int value, string? text)
    {
        Value = value;
        Text = text;
    }
}