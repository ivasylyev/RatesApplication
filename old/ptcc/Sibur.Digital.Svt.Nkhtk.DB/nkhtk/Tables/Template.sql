CREATE TABLE [nkhtk].[Template] (
    [TemplateId]          INT            NOT NULL,
    [TemplateEnglishName] NVARCHAR (700) NOT NULL,
    [TemplateRussianName] NVARCHAR (700) NOT NULL,
    [TemplateTypeId]      INT            NULL,
    CONSTRAINT [PK_Template_Id] PRIMARY KEY CLUSTERED ([TemplateId] ASC),
    CONSTRAINT [FK_Template_TemplateType_Id] FOREIGN KEY ([TemplateTypeId]) REFERENCES [nkhtk].[TemplateType] ([TemplateTypeId]),
    CONSTRAINT [UC_Template_EnglishName] UNIQUE NONCLUSTERED ([TemplateEnglishName] ASC),
    CONSTRAINT [UC_Template_RussianName] UNIQUE NONCLUSTERED ([TemplateRussianName] ASC)
);










GO



GO



GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Имя шаблона на русском языке', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'Template', @level2type = N'COLUMN', @level2name = N'TemplateRussianName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Уникальный идентификатор шаблона', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'Template', @level2type = N'COLUMN', @level2name = N'TemplateId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Имя шаблона на английском языке', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'Template', @level2type = N'COLUMN', @level2name = N'TemplateEnglishName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Исходный шаблон НХТК для последующего преобразования в шаблон СВТ', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'Template';

