using Microsoft.Extensions.Diagnostics.HealthChecks;
using Newtonsoft.Json;

namespace Sibur.Digital.Svt.Infrastructure.Models;

public class SiburHealthCheckResult
{
    /// <summary>
    /// Cоздает экземляр <see cref="SiburHealthCheckResult" />
    /// </summary>
    /// <remarks>
    /// Конструктор без параметров нужен для десериализации из JSON
    /// </remarks>
    [JsonConstructor]
    private SiburHealthCheckResult()
    {
    }

    /// <summary>
    /// Cоздает экземляр <see cref="SiburHealthCheckResult" /> со статусом <see cref="HealthStatus" />,
    /// необязательным описанием, сообщением об ошибке и стек трейсом
    /// </summary>
    /// <param name="status">Статус проверки здоровья</param>
    /// <param name="description">Описание</param>
    /// <param name="exceptionMessage">Сообщение из исключения, возникшего при проверки здоровья </param>
    /// <param name="exceptionStackTrace">Стек трейс исключения, возникшего при проверки здоровья</param>
    public SiburHealthCheckResult(HealthStatus status, string? description, string? exceptionMessage, string? exceptionStackTrace)
    {
        Status = status;
        Description = description;
        ExceptionMessage = exceptionMessage;
        ExceptionStackTrace = exceptionStackTrace;
    }

    // ReSharper disable once UnusedMember.Global.
    // Несмотря на то, что в явном виде свойствва не используются, они вызываются неявно при десериализации
    // И пожтому удалять set нельзя


    /// <summary>
    /// Состояние здоровья
    /// </summary>
    [JsonProperty("status")]
    public HealthStatus Status { get; set; }

    /// <summary>
    /// Описание состояния здоровья
    /// </summary>
    [JsonProperty("description")]
    public string? Description { get; set; }

    /// <summary>
    /// Сообщение об ошибке, если таковая возникла
    /// </summary>
    /// <remarks>
    /// Само исключение хранить нельзя, потому что при передачи по сети оно может не сериализоваться.
    /// </remarks>
    [JsonProperty("exceptionMessage")]
    public string? ExceptionMessage { get; set; }

    /// <summary>
    /// StackTrace исключения, если таковое возникло
    /// </summary>
    /// <remarks>
    /// Само исключение хранить нельзя, потому что при передачи по сети оно может не сериализоваться.
    /// </remarks>
    [JsonProperty("exceptionStackTrace")]
    public string? ExceptionStackTrace { get; set; }
}