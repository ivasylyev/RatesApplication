namespace Sibur.Digital.Svt.Infrastructure.Models;

public enum RuleOperator
{
    /// <summary>
    /// Оператор не применяется
    /// </summary>
    None = 0,

    /// <summary>
    /// Оператор сложения. 
    /// </summary>
    Plus = 1,

    /// <summary>
    /// Оператор вычитания. 
    /// </summary>
    Minus = 2,

    /// <summary>
    /// Оператор умножения
    /// </summary>
    Multiply = 3,

    /// <summary>
    /// Оператор деления
    /// </summary>
    Divide = 4,

    /// <summary>
    /// Оператор замены значение NULL указанным замещающим значением. условной замены.
    /// Возвращает  первый аргумент, если он не равен NULL. Иначе возвращает второй аргумент.
    /// </summary>
    IsNull = 5,

    /// <summary>
    /// Оператор конкатенации (сложения как строк). 1+1 = 11
    /// </summary>
    Concat = 6
}