using System.Globalization;
using ClosedXML.Excel;
using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Infrastructure.Utils;
using Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;
using Sibur.Digital.Svt.Nkhtk.Converter.Model;

namespace Sibur.Digital.Svt.Nkhtk.Converter.DataProviders;

/// <inheritdoc />
public class ExcelDecorator : IExcelDecorator
{
    private const int MaxRowNumberForHeader = 15;
    private readonly ILogger<IExcelDecorator> _logger;

    private string[]? _columnNames;
    private XLWorkbook? _workbook;
    private IXLWorksheet? _worksheet;

    public ExcelDecorator(ILogger<IExcelDecorator> logger)
    {
        _logger = logger;
    }

    public XLWorkbook Workbook
    {
        get => _workbook ?? throw new InvalidOperationException($"Workbook is not initialized. Call {nameof(Load)} first.");
        set => _workbook = value ?? throw new ArgumentNullException(nameof(value));
    }

    internal IXLWorksheet Worksheet
    {
        get => _worksheet ?? throw new InvalidOperationException($"Worksheet is not initialized. Call {nameof(Load)} first.");
        set => _worksheet = value ?? throw new ArgumentNullException(nameof(value));
    }

    internal string[] ColumnNames
    {
        get => _columnNames ?? throw new InvalidOperationException($"ColumnNames are not initialized. Call {nameof(Load)} first.");
        set => _columnNames = value ?? throw new ArgumentNullException(nameof(value));
    }

    /// <inheritdoc />
    public Stream Save()
    {
        var stream = new MemoryStream();
        Workbook.SaveAs(stream, new SaveOptions
        {
            EvaluateFormulasBeforeSaving = false,
            GenerateCalculationChain = false
        });
        stream.Seek(0, SeekOrigin.Begin);
        return stream;
    }

    /// <inheritdoc />
    public ColumnValues GetColumnValues(params string[] columnNames)
    {
        columnNames.ThrowIfNull(nameof(columnNames));

        var headerAddress = GetHeaderCellAddress(Worksheet, columnNames);

        var columnNumber = headerAddress.ColumnNumber;
        var headerRowNumber = headerAddress.RowNumber;

        return GetColumnValues(Worksheet, headerRowNumber, columnNumber);
    }

    /// <inheritdoc />
    public void MultiplyAllColumnsValues(int count, params string[] columnNames)
    {
        columnNames.ThrowIfNull(nameof(columnNames));

        if (count < 1)
        {
            return;
        }

        var headerAddress = GetHeaderCellAddress(Worksheet, columnNames);

        var lastColumnNumber = Worksheet.LastColumnUsed().ColumnNumber();
        var lastRowNumber = Worksheet.LastRowUsed().RowNumber();
        var headerRowNumber = headerAddress.RowNumber;

        var allColumnValues = new List<ColumnValues>(lastColumnNumber);
        for (var columnNumber = 1; columnNumber <= lastColumnNumber; columnNumber++)
        {
            allColumnValues.Add(GetColumnValues(Worksheet, headerRowNumber, columnNumber));
        }

        var step = lastRowNumber - headerAddress.RowNumber;
        for (var columnNumber = 1; columnNumber <= lastColumnNumber; columnNumber++)
        {
            var columnValues = allColumnValues[columnNumber - 1];

            for (var index = 1; index < count; index++)
            {
                var address = new ColumnValueAddress(headerAddress.RowNumber, columnNumber, step * index + headerAddress.RowNumber + 1);

                // todo: Изменить RuleType.General, получать реальный тип данных в GetColumnValues и использовать здесь для копирования.
                // использование  RuleType.General, то есть текста, чревато неверным форматом (напримре для дат)
                SetColumnValues(Worksheet, RuleType.General, columnValues, address);
            }
        }
    }

    /// <inheritdoc />
    public void SetColumnValues(RuleType ruleDataType, string columnName, ColumnValues columnValues)
    {
        columnName.ThrowIfNullOrEmpty(nameof(columnName));
        columnValues.ThrowIfNull(nameof(columnValues));
        if (Worksheet is null)
        {
            throw new InvalidOperationException($"Worksheet is not initialized. Call {nameof(Load)} first.");
        }

        var headerAddress = GetHeaderCellAddress(Worksheet, columnName);
        var address = new ColumnValueAddress(headerAddress.RowNumber, headerAddress.ColumnNumber, headerAddress.RowNumber + 1);
        SetColumnValues(Worksheet, ruleDataType, columnValues, address);
    }

    /// <inheritdoc />
    public int ColumnValuesCount()
    {
        var headerAddress = GetHeaderCellAddress(Worksheet, ColumnNames);
        var lastRowNumber = Worksheet.LastRowUsed().RowNumber();

        var count = 0;
        for (var rowNumber = headerAddress.RowNumber + 1; rowNumber <= lastRowNumber; rowNumber++)
        {
            if (!Worksheet.Row(rowNumber).IsHidden)
            {
                count++;
            }
        }

        return count;
    }

    /// <inheritdoc />
    public string? GetCellValue(CellValueOrientation orientation, params string[] columnNames)
    {
        columnNames.ThrowIfNull(nameof(columnNames));

        var headerAddress = GetHeaderCellAddress(Worksheet, columnNames);

        switch (orientation)
        {
            case CellValueOrientation.Horizontal:
                var horizontalDataCell = Worksheet.Cell(headerAddress.RowNumber, headerAddress.ColumnNumber + 1);
                return horizontalDataCell?.CachedValue.ConvertToString();

            case CellValueOrientation.Vertical:
                var verticalDataCell = Worksheet.Cell(headerAddress.RowNumber + 1, headerAddress.ColumnNumber);
                return verticalDataCell.CachedValue.ConvertToString();

            default: throw new NotSupportedException($"{nameof(orientation)}={orientation} is not supported");
        }
    }

    /// <inheritdoc />
    public void LoadSimple(Stream stream)
    {
        Workbook = new XLWorkbook(stream);
        Workbook.CalculateMode = XLCalculateMode.Manual;
    }

    /// <inheritdoc />
    public List<string> GetWorksheetNames()
        => Workbook.Worksheets.Select(w => w.Name).ToList();

    /// <inheritdoc />
    public void Load(Stream stream, int excelWorksheetIndex, params string[] columnNames)
    {
        if (excelWorksheetIndex <= 0)
        {
            throw new ArgumentException($"{nameof(excelWorksheetIndex)} must be positive", nameof(excelWorksheetIndex));
        }
       
        columnNames.ThrowIfNull(nameof(columnNames));

        Workbook = new XLWorkbook(stream);
        Workbook.CalculateMode = XLCalculateMode.Manual;

        if (excelWorksheetIndex > Workbook.Worksheets.Count)
        {
            throw new ArgumentException($"{nameof(excelWorksheetIndex)} must be less than worksheet count {Workbook.Worksheets.Count}", nameof(excelWorksheetIndex));
        }

        Worksheet = Workbook.Worksheets.Skip(excelWorksheetIndex - 1).First();

        ColumnNames = columnNames;

        DeleteBottomGarbageRows();
    }

    /// <inheritdoc />
    public int DeleteGarbageRows(Func<string, bool> mustBeDeleted, params string[] columnNames)
    {
        columnNames.ThrowIfNull(nameof(columnNames));

        if (!columnNames.Any())
        {
            throw new ArgumentException("Parameter has no items", nameof(columnNames));
        }

        // Находим номера колонок, в которых будем проверять значения ячеек
        var columnNumbers = new List<int>(columnNames.Length);
        foreach (var columnName in columnNames)
        {
            try
            {
                var headerCell = GetHeaderCellAddress(Worksheet, columnName);
                columnNumbers.Add(headerCell.ColumnNumber);
            }
            catch (ExcelColumnNotFoundException)
            {
                _logger.LogDebug("Cannot find column '{columnName}' to check it for invalid data", columnName);
            }
        }

        // Вычисляем адрес строки заголовка, взяв за основу ключевые столбцы (а не те,что переданы в качестве параметра) 
        var headerAddress = GetHeaderCellAddress(Worksheet, ColumnNames);

        var headerRowNumber = headerAddress.RowNumber;

        var lastRowNumber = Worksheet.LastRowUsed().RowNumber();
        int rowNumber;

        // составляем список строк для удаления
        var rowsToDelete = new List<int>();
        for (rowNumber = headerRowNumber + 1; rowNumber <= lastRowNumber + 1; rowNumber++)
        {
            var row = Worksheet.Row(rowNumber);
            foreach (var columnNumber in columnNumbers)
            {
                var cellValue = row.Cell(columnNumber).CachedValue.ConvertToString() ?? string.Empty;
                if (mustBeDeleted(cellValue))
                {
                    rowsToDelete.Add(rowNumber);
                    break;
                }
            }
        }

        // удаляем строки
        foreach (var rowToDeleteNumber in rowsToDelete.OrderByDescending(r => r))
        {
            Worksheet.Row(rowToDeleteNumber).Hide();
        }

        return rowsToDelete.Count;
    }

    /// <summary>
    /// Удаляем все строчки, которые находятся ниже последнего занчения
    /// в ключевом столбце
    /// </summary>
    private void DeleteBottomGarbageRows()
    {
        var headerAddress = GetHeaderCellAddress(Worksheet, ColumnNames);

        var headerRowNumber = headerAddress.RowNumber;

        var lastRowNumber = Worksheet.LastRowUsed().RowNumber();
        int rowNumber;
        for (rowNumber = headerRowNumber + 1; rowNumber <= lastRowNumber + 1; rowNumber++)
        {
            var cell = Worksheet.Column(headerAddress.ColumnNumber).Cell(rowNumber);
            if (string.IsNullOrEmpty(cell.CachedValue.ConvertToString()))
            {
                break;
            }
        }

        if (rowNumber < lastRowNumber)
        {
            Worksheet.Rows(rowNumber, lastRowNumber).Delete();
        }
    }

    private static IXLAddress GetHeaderCellAddress(IXLWorksheet worksheet, params string[] columnNames)
    {
        worksheet.ThrowIfNull(nameof(worksheet));
        columnNames.ThrowIfNull(nameof(columnNames));

        if (!columnNames.Any())
        {
            throw new ArgumentException("Parameter has no items", nameof(columnNames));
        }

        // Ищем заголовок только в первых MaxRowNumberForHeader строках.
        // Если искать по всему файлу - просядет производительность
        var columnNamesAddress = new Dictionary<IXLAddress, string>();
        for (var rowNumber = 1; rowNumber < MaxRowNumberForHeader; rowNumber++)
        {
            var row = worksheet.Row(rowNumber);
            foreach (var columnName in columnNames)
            {
                var headerCells = row.Search(columnName, CompareOptions.OrdinalIgnoreCase);
                var filteredHeaderCells = headerCells.Where(c => string.Equals(c.CachedValue.ConvertToString(), columnName, StringComparison.InvariantCultureIgnoreCase));
                foreach (var cell in filteredHeaderCells)
                {
                    // Собираем все найденные адреса для соответсвующих имен
                    columnNamesAddress.Add(cell.Address, columnName);
                }
            }
        }

        // Не нашли ни одного из имен в excel фале- сообщаем об ошибке
        var numberOfAddressesFound = columnNamesAddress.Count;
        if (numberOfAddressesFound == 0)
        {
            throw new ExcelColumnNotFoundException(worksheet.Name, columnNames);
        }

        // Нашли слишком много имен в excel фале- сообщаем об ошибке
        if (numberOfAddressesFound > 1)
        {
            var multipleAddressesWithNames = columnNamesAddress
                .Select(a => $"'{a.Value}' по адресу '{a.Key.ColumnLetter}{a.Key.RowNumber}'")
                .ToArray();
            throw new ExcelAmbiguousColumnException(multipleAddressesWithNames);
        }

        // возвращаем адрес единственной ячейки, содержание которой равно искомому имени
        return columnNamesAddress.Single().Key;
    }

    private static ColumnValues GetColumnValues(IXLWorksheet worksheet, int headerRowNumber, int columnNumber)
    {
        var result = new ColumnValues();

        var lastRowNumber = worksheet.LastRowUsed().RowNumber();
        for (var rowNumber = headerRowNumber + 1; rowNumber <= lastRowNumber; rowNumber++)
        {
            if (!worksheet.Row(rowNumber).IsHidden)
            {
                var dataCell = worksheet.Cell(rowNumber, columnNumber);
                result.Add(new ColumnValue(dataCell.CachedValue.ConvertToString()));
            }
        }

        return result;
    }

    private void SetColumnValues(IXLWorksheet worksheet, RuleType ruleDataType, ColumnValues columnValues, ColumnValueAddress address)
    {
        var headerErrorSet = false;
        var rowNumber = address.RowNumber;
        foreach (var columnValue in columnValues)
        {
            var hasError = columnValue.HasError;

            var currentCell = worksheet.Cell(rowNumber, address.ColumnNumber);
            try
            {
                if (ruleDataType == RuleType.General || string.IsNullOrEmpty(columnValue.Value))
                {
                    currentCell.Value = columnValue.Value;
                }
                else
                {
                    currentCell.DataType = ConvertDataType(ruleDataType);
                    currentCell.Value = ConvertDataValue(columnValue.Value, ruleDataType);
                }
            }
            catch (Exception ex)
            {
                var value = columnValue.Value.ConvertToString();
                _logger.LogDebug("Cannot convert '{val}' to the type {t}. Exception: {ex}",
                    value, ruleDataType, ex);

                hasError = true;
                currentCell.DataType = XLDataType.Text;
                currentCell.Value = value;
            }

            if (hasError)
            {
                currentCell.Style.Fill.BackgroundColor = XLColor.Red;
                if (!headerErrorSet)
                {
                    var headerCell = worksheet.Cell(address.HeaderRowNumber, address.ColumnNumber);
                    headerCell.Style.Fill.BackgroundColor = XLColor.Red;
                    headerErrorSet = true;
                }
            }

            rowNumber++;
        }
    }

    private static XLDataType ConvertDataType(RuleType ruleDataType) =>
        ruleDataType switch
        {
            RuleType.Boolean => XLDataType.Boolean,
            RuleType.DateTime => XLDataType.DateTime,
            RuleType.Number => XLDataType.Number,
            RuleType.TimeSpan => XLDataType.TimeSpan,
            _ => XLDataType.Text
        };

    private static object ConvertDataValue(string value, RuleType ruleDataType)
    {
        // Числовые значения округляем до 2-х знаков после запятой
        const int digits = 2;
        return ruleDataType switch
        {
            RuleType.Boolean => bool.Parse(value),
            RuleType.DateTime => DateTime.Parse(value, CultureInfo.InvariantCulture),
            RuleType.Number => Math.Round(double.Parse(value.Replace(",", "."), CultureInfo.InvariantCulture), digits),
            RuleType.TimeSpan => TimeSpan.Parse(value, CultureInfo.InvariantCulture),
            _ => value
        };
    }
}