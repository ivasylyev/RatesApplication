CREATE TABLE [nkhtk].[RuleDictionaryItem] (
    [RuleDictionaryItemId] INT            NOT NULL,
    [RuleDictionaryId]     INT            NOT NULL,
    [SourceValue]          NVARCHAR (MAX) NULL,
    [DestinationValue]     NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_RuleDictionaryItem_Id] PRIMARY KEY CLUSTERED ([RuleDictionaryItemId] ASC),
    CONSTRAINT [FK_RuleDictionary_RuleDictionaryId] FOREIGN KEY ([RuleDictionaryId]) REFERENCES [nkhtk].[RuleDictionary] ([RuleDictionaryId])
);






GO



GO



GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Уникальный идентификатор элемента словаря', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'RuleDictionaryItem', @level2type = N'COLUMN', @level2name = N'RuleDictionaryItemId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ключ элемента словаря', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'RuleDictionaryItem', @level2type = N'COLUMN', @level2name = N'SourceValue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Значение элемента словаря', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'RuleDictionaryItem', @level2type = N'COLUMN', @level2name = N'DestinationValue';


GO
CREATE NONCLUSTERED INDEX [IX_RuleDictionaryItem_RuleDictionaryId]
    ON [nkhtk].[RuleDictionaryItem]([RuleDictionaryId] ASC)
    INCLUDE([RuleDictionaryItemId], [SourceValue], [DestinationValue]);

