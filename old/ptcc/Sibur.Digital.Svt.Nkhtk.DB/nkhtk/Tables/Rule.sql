CREATE TABLE [nkhtk].[Rule] (
    [RuleId]                             INT             NOT NULL,
    [MatrixId]                           INT             NULL,
    [WorksheetId]                        INT             NOT NULL,
    [DestinationColumn]                  NVARCHAR (4000) NOT NULL,
    [RuleEntityId]                       INT             NULL,
    [RuleDictionaryId]                   INT             NULL,
    [RuleKindId]                         INT             NOT NULL,
    [RuleDataTypeId]                     INT             NOT NULL,
    [RuleOperatorId]                     INT             NOT NULL,
    [Mandatory]                          BIT             NOT NULL,
    [TreatMissingDictionaryValueAsError] BIT             NOT NULL,
    [Description]                        NVARCHAR (MAX)  NULL,
    [Order]                              INT             NOT NULL,
    CONSTRAINT [PK_Rule_Id] PRIMARY KEY CLUSTERED ([RuleId] ASC),
    CONSTRAINT [FK_Rule_RuleDataTypeId] FOREIGN KEY ([RuleDataTypeId]) REFERENCES [nkhtk].[RuleDataType] ([RuleDataTypeId]),
    CONSTRAINT [FK_Rule_RuleDictionaryId] FOREIGN KEY ([RuleDictionaryId]) REFERENCES [nkhtk].[RuleDictionary] ([RuleDictionaryId]),
    CONSTRAINT [FK_Rule_RuleEntityId] FOREIGN KEY ([RuleEntityId]) REFERENCES [nkhtk].[RuleEntity] ([RuleEntityId]),
    CONSTRAINT [FK_Rule_RuleKindId] FOREIGN KEY ([RuleKindId]) REFERENCES [nkhtk].[RuleKind] ([RuleKindId]),
    CONSTRAINT [FK_Rule_RuleOperatorId] FOREIGN KEY ([RuleOperatorId]) REFERENCES [nkhtk].[RuleOperator] ([RuleOperatorId]),
    CONSTRAINT [FK_Rule_WorksheetId] FOREIGN KEY ([WorksheetId]) REFERENCES [nkhtk].[Worksheet] ([WorksheetId])
);






GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Порядок, в котором правило будет выполняться', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'Rule', @level2type = N'COLUMN', @level2name = N'Order';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N' Русскоязычное описание  правила', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'Rule', @level2type = N'COLUMN', @level2name = N'Description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'В случае установки этого флага отсутсвие значения в словаре для правила считается ошибкой', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'Rule', @level2type = N'COLUMN', @level2name = N'TreatMissingDictionaryValueAsError';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Является ли правило обязательным. ', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'Rule', @level2type = N'COLUMN', @level2name = N'Mandatory';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Бинарный оператор для правила. Первый операнд - значение, хранящееся в шаблоне назначения "DestinationColumn" как результат выполнения предыдущего правила. Второй операнд - результат данного правила. Применяется только к числовым значениям', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'Rule', @level2type = N'COLUMN', @level2name = N'RuleOperatorId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Тип данных, обрабатываемый правилом.', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'Rule', @level2type = N'COLUMN', @level2name = N'RuleDataTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Категория правила: применяется ли правило к excel файлу, листу, колонке, ячейке и т.д.', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'Rule', @level2type = N'COLUMN', @level2name = N'RuleKindId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Коллекция сущностей, соответсвующее столбцу или ячейке исходном шаблоне назначения (в данной реализации - НХТК)', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'Rule', @level2type = N'COLUMN', @level2name = N'RuleEntityId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Англоязычное человеко-читаемое уникальное имя, соответсвующее столбцу в шаблоне назначения (в данной реализации - СВТ)', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'Rule', @level2type = N'COLUMN', @level2name = N'DestinationColumn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Неуникальный необязательный идентификатор правила в матрице соответствия. Создан для удобства работы с требованими, описанными в матрице', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'Rule', @level2type = N'COLUMN', @level2name = N'WorksheetId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Идентификатор вкладки шаблона, к которой принадлежит правило', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'Rule', @level2type = N'COLUMN', @level2name = N'MatrixId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Уникальный идентификатор правила', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'Rule', @level2type = N'COLUMN', @level2name = N'RuleId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Бизнес-правило для преобразования шаблонов из НХТК в СВТ', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'Rule';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Словарь для маппинга между значениями исходного шаблона (НХТК) и шаблона назначени (СВТ)', @level0type = N'SCHEMA', @level0name = N'nkhtk', @level1type = N'TABLE', @level1name = N'Rule', @level2type = N'COLUMN', @level2name = N'RuleDictionaryId';


GO
CREATE NONCLUSTERED INDEX [IX_Rule_WorksheetId]
    ON [nkhtk].[Rule]([WorksheetId] ASC)
    INCLUDE([RuleDictionaryId], [RuleEntityId]);

