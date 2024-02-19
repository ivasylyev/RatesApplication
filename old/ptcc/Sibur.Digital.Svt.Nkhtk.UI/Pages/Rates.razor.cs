using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Forms;
using Microsoft.Extensions.Options;
using Microsoft.JSInterop;
using Sibur.Digital.Svt.Infrastructure.Exceptions;
using Sibur.Digital.Svt.Nkhtk.UI.Config;
using Sibur.Digital.Svt.Nkhtk.UI.Models;

namespace Sibur.Digital.Svt.Nkhtk.UI.Pages;

public class Rates : ComponentBase
{
    [Inject]
    private IJSRuntime JsRuntime { get; set; } = default!;

    [Inject]
    protected ILogger<Rates> Logger { get; set; } = default!;

    [Inject]
    private IOptions<UiOptions> Options { get; set; } = default!;

    protected virtual FileModel Model
        => throw new NotImplementedException("The property Model must be overriden in child class");

    protected EditContext? EditContext { get; set; }

    protected override void OnInitialized()
        => EditContext = new EditContext(Model);

    protected void TemplateValueChanged(int templateId)
        => Model.TemplateId = templateId;

    protected void StartDateValueChanged(DateTime? date)
        => Model.StartDate = date;

    protected void EndDateValueChanged(DateTime? date)
        => Model.EndDate = date;

    /// <summary>
    /// Загрузка файла excel и списка его вкладок
    /// </summary>
    /// <param name="file">загружаемый файл</param>
    /// <returns></returns>
    protected async Task LoadFileAsync(IBrowserFile file)
    {
        try
        {
            Model.ClearFileAsync();
            if (!Model.FileExceededMaxSize(file.Size))
            {
                Model.SetInfo("Файл загружается...");
                await Model.LoadFileAsync(file)
                    .ConfigureAwait(false);
                Model.SetInfo($"Загружен файл: '{file.Name}'({file.Size / 1024}) Кб)");
            }
            else
            {
                Model.SetError($"Размер файла превышает {Options.Value.MaxFileSizeMb} Мб");
            }
        }
        catch (Exception ex)
        {
            Logger.LogError(ex, "Failed to load file");
            Model.SetError(ex.Message);
        }
    }

    /// <summary>
    /// Обработчик конвертации исходного excel файла в формат СВТ
    /// </summary>
    /// <returns></returns>
    protected async Task HandleConvert()
    {
        try
        {
            Model.Submitted = true;
            Model.SetInfo("Файл конвертируется...");
            if (EditContext != null && EditContext.Validate())
            {
                var (streamRef, fileName) = await Model.ConvertFileAsync()
                    .ConfigureAwait(false);
                await JsRuntime.InvokeVoidAsync("downloadFileFromStream", fileName, streamRef);
                Model.SetInfo("Файл сконвертирован и скачан.");
            }
            else
            {
                Model.SetError("Заполните все обязательные поля");
            }
        }
        catch (ConvertException ex)
        {
            Logger.LogError(ex, "Failed to convert file");
            Model.SetError(ex.ProblemDetails?.Detail ?? ex.Message);
        }
        catch (Exception ex)
        {
            Logger.LogError(ex, "Failed to convert file");
            Model.SetError(ex.Message);
        }
    }
}