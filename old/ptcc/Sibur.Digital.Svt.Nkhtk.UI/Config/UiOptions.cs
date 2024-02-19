namespace Sibur.Digital.Svt.Nkhtk.UI.Config
{
    public class UiOptions
    {
        public const string Api = "Api";

        public string? BaseDataUrl { get; set; }
        public string? BaseConverterUrl { get; set; }

        public string? DataTemplatesAction { get; set; }

        public string? DataWorksheetsAction { get; set; }

        public string? DataHcAction { get; set; }
        public string? ConverterHcAction{ get; set; }
        public string? ConverterFileAction { get; set; }

        public string? ConverterWorksheetNamesAction { get; set; }

        public int MaxFileSizeMb { get; set; }
    }
}