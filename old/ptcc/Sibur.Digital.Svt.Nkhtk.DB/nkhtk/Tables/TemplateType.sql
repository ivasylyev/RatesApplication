CREATE TABLE [nkhtk].[TemplateType] (
    [TemplateTypeId]          INT            NOT NULL,
    [TemplateTypeEnglishName] NVARCHAR (700) NOT NULL,
    [TemplateTypeRussianName] NVARCHAR (700) NOT NULL,
    CONSTRAINT [PK_TemplateType_Id] PRIMARY KEY CLUSTERED ([TemplateTypeId] ASC),
    CONSTRAINT [UC_TemplateType_EnglishName] UNIQUE NONCLUSTERED ([TemplateTypeEnglishName] ASC),
    CONSTRAINT [UC_TemplateType_RussianName] UNIQUE NONCLUSTERED ([TemplateTypeRussianName] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Имя типа шаблона на русском языке', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'TemplateType', @level2type = N'COLUMN', @level2name = N'TemplateTypeRussianName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Имя типа шаблона на английском языке', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'TemplateType', @level2type = N'COLUMN', @level2name = N'TemplateTypeEnglishName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Уникальный идентификатор типа шаблона', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'TemplateType', @level2type = N'COLUMN', @level2name = N'TemplateTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Тип исходных шаблонов для последующего преобразования в шаблон СВТ', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'TemplateType';

