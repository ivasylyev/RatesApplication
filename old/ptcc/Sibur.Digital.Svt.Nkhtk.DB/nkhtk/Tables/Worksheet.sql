CREATE TABLE [nkhtk].[Worksheet] (
    [WorksheetId]   INT             NOT NULL,
    [TemplateId]    INT             NOT NULL,
    [WorksheetName] NVARCHAR (4000) NOT NULL,
    CONSTRAINT [PK_Worksheet_Id] PRIMARY KEY CLUSTERED ([WorksheetId] ASC),
    CONSTRAINT [FK_Worksheet_Template_Id] FOREIGN KEY ([TemplateId]) REFERENCES [nkhtk].[Template] ([TemplateId])
);








GO



GO



GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Имя вкладки шаблона', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'Worksheet', @level2type = N'COLUMN', @level2name = N'WorksheetName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Уникальный идентификатор вкладки шаблона', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'Worksheet', @level2type = N'COLUMN', @level2name = N'WorksheetId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Идентификатор шаблона-источника, к которому принадлежит вкладка', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'Worksheet', @level2type = N'COLUMN', @level2name = N'TemplateId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Вкладка excel файла исходного шаблона НХТК для последующего преобразования в шаблон СВТ', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'Worksheet';

