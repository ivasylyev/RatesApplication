CREATE TABLE [nkhtk].[RuleEntity] (
    [RuleEntityId]          INT             NOT NULL,
    [RuleEntityName]        NVARCHAR (700)  NOT NULL,
    [RuleEntityDescription] NVARCHAR (4000) NULL,
    CONSTRAINT [PK_RuleEntity_Id] PRIMARY KEY CLUSTERED ([RuleEntityId] ASC),
    CONSTRAINT [UC_RuleEntity_Name] UNIQUE NONCLUSTERED ([RuleEntityName] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Описание коллекции элементов шаблона', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'RuleEntity', @level2type = N'COLUMN', @level2name = N'RuleEntityDescription';




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Уникальный идентификатор коллекции элементов шаблона', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'RuleEntity', @level2type = N'COLUMN', @level2name = N'RuleEntityId';




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Коллекция элементов шаблона (колонок или столбцов) которыми оперируют бизнес-правила преобразования шаблонов', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'RuleEntity';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Имя коллекции элементов шаблона', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'RuleEntity', @level2type = N'COLUMN', @level2name = N'RuleEntityName';

