namespace Sibur.Digital.Svt.Nkhtk.Converter.Model;

public record ColumnValueAddress
{
    public ColumnValueAddress(int headerRowNumber, int columnNumber, int rowNumber)
    {
        HeaderRowNumber = headerRowNumber;
        ColumnNumber = columnNumber;
        RowNumber = rowNumber;
    }

    public int HeaderRowNumber { get;  }
    public int ColumnNumber { get;  }
    public int RowNumber { get;  }
}