namespace Vasiliev.Idp.Orchestrator.Models;

public class ProductGroup
{
    public ProductGroup(long id, string code, string name)
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