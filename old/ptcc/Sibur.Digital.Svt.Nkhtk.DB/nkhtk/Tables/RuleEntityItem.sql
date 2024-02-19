CREATE TABLE [nkhtk].[RuleEntityItem] (
    [RuleEntityItemId]   INT             NOT NULL,
    [RuleEntityId]       INT             NOT NULL,
    [RuleEntityItemName] NVARCHAR (4000) NOT NULL,
    CONSTRAINT [PK_RuleEntityItem_Id] PRIMARY KEY CLUSTERED ([RuleEntityItemId] ASC),
    CONSTRAINT [FK_RuleEntity_RuleEntityId] FOREIGN KEY ([RuleEntityId]) REFERENCES [nkhtk].[RuleEntity] ([RuleEntityId])
);






GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Описаине исходного элемента шаблона (столбца или ячейки)', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'RuleEntityItem', @level2type = N'COLUMN', @level2name = N'RuleEntityItemName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Уникальный идентификатор исходного элемента шаблона (столбца или ячейки)', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'RuleEntityItem', @level2type = N'COLUMN', @level2name = N'RuleEntityItemId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Элемент шаблона (столбец или ячейка) которым оперируют бизнес-правила преобразования шаблонов', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'RuleEntityItem';


GO
CREATE NONCLUSTERED INDEX [IX_RuleEntityItem_RuleEntityId]
    ON [nkhtk].[RuleEntityItem]([RuleEntityId] ASC)
    INCLUDE([RuleEntityItemId], [RuleEntityItemName]);

