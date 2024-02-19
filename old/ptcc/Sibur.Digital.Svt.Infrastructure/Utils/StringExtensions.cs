namespace Sibur.Digital.Svt.Infrastructure.Utils;

/// <summary>
/// Вспомогательный класс для проверки строковых параметров на NULL и пустоту
/// </summary>
public static class StringExtensions
{
    /// <summary>
    /// Бросает <see cref="NullReferenceException" /> если строковый параметер равен NULL или пустой
    /// </summary>
    /// <param name="str">параметер</param>
    /// <param name="paramName">имя параметра</param>
    /// <exception cref="ArgumentException"></exception>
    public static void ThrowIfNullOrEmpty(this string str, string paramName)
    {
        if (string.IsNullOrEmpty(str))
        {
            throw new ArgumentException("Parameter is null or empty.", paramName);
        }
    }
}