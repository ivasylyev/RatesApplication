using System.Globalization;

namespace Sibur.Digital.Svt.Infrastructure.Utils;

/// <summary>
/// Вспомогательный класс для проверки параметров на NULL
/// </summary>
public static class ObjectExtensions
{
    /// <summary>
    /// Бросает <see cref="NullReferenceException" /> если параметер равен NULL
    /// </summary>
    /// <param name="obj">параметер</param>
    /// <param name="paramName">имя параметра</param>
    /// <exception cref="ArgumentNullException"></exception>
    public static void ThrowIfNull(this object? obj, string paramName)
    {
        if (obj is null)
        {
            throw new ArgumentNullException(paramName);
        }
    }
    public static string? ConvertToString(this object? obj)
        => Convert.ToString(obj, CultureInfo.InvariantCulture);
}