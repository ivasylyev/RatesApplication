using Sibur.Digital.Svt.Infrastructure.Models;
using Sibur.Digital.Svt.Nkhtk.Converter.Model;

namespace Sibur.Digital.Svt.Nkhtk.Converter.Interfaces;

/// <summary>
/// Служит для работы с Excel файлами
/// </summary>
public interface IExcelDecorator
{
    /// <summary>
    /// Загружает Excel файл из потока 
    /// </summary>
    /// <param name="stream">Поток с Excel файлом</param>
    void LoadSimple(Stream stream);

    /// <summary>
    /// Возвращает список имен вкладок Excel файла
    /// </summary>
    /// <returns></returns>
    List<string> GetWorksheetNames();

    /// <summary>
    /// Загружает вкладку Excel файл из потока и производит первичную очистку
    /// </summary>
    /// <param name="stream">Поток с Excel файлом</param>
    /// <param name="excelWorksheetIndex">
    /// Порядковый номер (индекс) вкладки Excel файл
    /// </param>
    /// <param name="columnNames">
    /// Одно или несколько имен столбцов, или заголовков.
    /// Все, что находится ниже заголовков, будет считаться данными
    /// </param>
    void Load(Stream stream, int excelWorksheetIndex, params string[] columnNames);

    /// <summary>
    /// Возвращает значение ячейки под или рядом (в зависимости от <see cref="CellValueOrientation" />) с
    /// первым найденным заголовком внутри Excel.
    /// </summary>
    /// <param name="orientation">Ориентация (вертикальная или горизонтальная) между заголовком и значением</param>
    /// <param name="columnNames">Список заголовков.</param>
    /// <returns>Значение ячейки</returns>
    string? GetCellValue(CellValueOrientation orientation, params string[] columnNames);

    /// <summary>
    /// Возвращает все значения в столбце под первым найденным заголовком внутри Excel.
    /// </summary>
    /// <param name="columnNames">Список заголовков.</param>
    /// <returns>Список значений ячеек</returns>
    ColumnValues GetColumnValues(params string[] columnNames);

    /// <summary>
    /// Выполняет копирование и вставку всех данных ниже линии заголовка.
    /// </summary>
    /// <param name="count">Количество раз копирования и вставки. Допустимые значения: 2 и больше. </param>
    /// <param name="columnNames">Список заголовков.</param>
    void MultiplyAllColumnsValues(int count, params string[] columnNames);

    /// <summary>
    /// Вставляет список значений под данным заголовком
    /// </summary>
    /// <param name="ruleDataType">Тип данных в ячейках</param>
    /// <param name="columnName">Заголовок</param>
    /// <param name="columnValues">Вставляемые значения</param>
    void SetColumnValues(RuleType ruleDataType, string columnName, ColumnValues columnValues);

    /// <summary>
    /// Количество строк с непустыми значениями в файле ниже линии заголовка
    /// </summary>
    /// <returns>Количество значений</returns>
    int ColumnValuesCount();

    /// <summary>
    /// Сохраняет Excel файл в поток
    /// </summary>
    /// <returns>Поток</returns>
    Stream Save();

    /// <summary>
    ///  Удаляем все строчки, в которых находятся ячейки, удовлетворяющие предикату
    /// </summary>
    /// <param name="mustBeDeleted">предикат, определяющий, нужно ли удалять строчку, содержащую ячейку с данным значением</param>
    /// <param name="columnNames">Список заголовков, под которыми выполняется поиск ячеек с нужным значением</param>
    /// <returns>Количество удаленных строк</returns>
    public int DeleteGarbageRows(Func<string, bool> mustBeDeleted, params string[] columnNames);
}