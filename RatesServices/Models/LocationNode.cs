namespace RatesServices.Models;

public class LocationNode
{
    public LocationNode(long id, string code, string name)
    {
        Id = id;
        Code = code;
        Name = name;
    }

    public long Id { get; }

    public string Code { get; }

    public string Name { get; }
    public override string ToString()
    {
        return $"{Id} {Code} {Name}";
    }
}