CREATE TABLE [nkhtk].[RuleKind] (
    [RuleKindId]          INT             NOT NULL,
    [RuleKindName]        NVARCHAR (700)  NOT NULL,
    [RuleKindDescription] NVARCHAR (4000) NOT NULL,
    CONSTRAINT [PK_RuleKind_Id] PRIMARY KEY CLUSTERED ([RuleKindId] ASC),
    CONSTRAINT [UC_RuleKind_Name] UNIQUE NONCLUSTERED ([RuleKindName] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Описание вида бизнес-правила.', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'RuleKind', @level2type = N'COLUMN', @level2name = N'RuleKindDescription';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Имя вида бизнес-правила.', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'RuleKind', @level2type = N'COLUMN', @level2name = N'RuleKindName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Уникальный идентификатор вида бизнес-правила.', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'RuleKind', @level2type = N'COLUMN', @level2name = N'RuleKindId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Вид бизнес-правила для преобразования шаблонов из НХТК в СВТ', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'RuleKind';

