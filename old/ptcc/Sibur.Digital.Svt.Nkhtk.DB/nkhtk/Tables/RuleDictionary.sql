CREATE TABLE [nkhtk].[RuleDictionary] (
    [RuleDictionaryId]          INT             NOT NULL,
    [RuleDictionaryName]        NVARCHAR (700)  NOT NULL,
    [RuleDictionaryDescription] NVARCHAR (4000) NULL,
    CONSTRAINT [PK_RuleDictionary_Id] PRIMARY KEY CLUSTERED ([RuleDictionaryId] ASC),
    CONSTRAINT [UC_Dictionar_Name] UNIQUE NONCLUSTERED ([RuleDictionaryName] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Описаине словаря шаблона', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'RuleDictionary', @level2type = N'COLUMN', @level2name = N'RuleDictionaryDescription';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Уникальное имя словаря шаблона', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'RuleDictionary', @level2type = N'COLUMN', @level2name = N'RuleDictionaryName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Уникальный идентификатор словаря шаблона', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'RuleDictionary', @level2type = N'COLUMN', @level2name = N'RuleDictionaryId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Словарь шаблона который используется бизнес-правилами при преобразовании шаблонов', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'RuleDictionary';

