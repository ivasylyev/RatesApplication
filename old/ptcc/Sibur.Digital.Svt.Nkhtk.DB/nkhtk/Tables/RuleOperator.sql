CREATE TABLE [nkhtk].[RuleOperator] (
    [RuleOperatorId]          INT             NOT NULL,
    [RuleOperatorName]        NVARCHAR (700)  NOT NULL,
    [RuleOperatorDescription] NVARCHAR (4000) NOT NULL,
    CONSTRAINT [PK_RuleOperator_Id] PRIMARY KEY CLUSTERED ([RuleOperatorId] ASC),
    CONSTRAINT [UC_RuleOperator_Name] UNIQUE NONCLUSTERED ([RuleOperatorName] ASC)
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Описание оператора.', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'RuleOperator', @level2type = N'COLUMN', @level2name = N'RuleOperatorDescription';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Имя оператора.', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'RuleOperator', @level2type = N'COLUMN', @level2name = N'RuleOperatorName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Уникальный идентификатор оператора.', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'RuleOperator', @level2type = N'COLUMN', @level2name = N'RuleOperatorId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Оператор, применяемы к данным, которыми оперируют бизнес-правила для преобразования шаблонов из НХТК в СВТ', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'RuleOperator';

