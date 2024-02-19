CREATE TABLE [nkhtk].[RuleDataType] (
    [RuleDataTypeId]   INT            NOT NULL,
    [RuleDataTypeName] NVARCHAR (700) NOT NULL,
    CONSTRAINT [PK_RuleDataType_Id] PRIMARY KEY CLUSTERED ([RuleDataTypeId] ASC),
    CONSTRAINT [UC_RuleDataType_Name] UNIQUE NONCLUSTERED ([RuleDataTypeName] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Имя типа данных бизнес-правила.', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'RuleDataType', @level2type = N'COLUMN', @level2name = N'RuleDataTypeName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Уникальный идентификатор типа данных бизнес-правила.', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'RuleDataType', @level2type = N'COLUMN', @level2name = N'RuleDataTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Типа данных бизнес-правила для преобразования шаблонов из НХТК в СВТ', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'RuleDataType';

