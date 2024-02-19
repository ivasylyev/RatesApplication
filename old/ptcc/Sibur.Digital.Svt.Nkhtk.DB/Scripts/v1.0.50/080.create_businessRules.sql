USE [mdm_integ]
GO

/****** Object:  Table [nkhtk].[Rule]    Script Date: 07.07.2022 14:53:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [nkhtk].[Rule](
	[RuleId] int NOT NULL,
	[MatrixId] int NULL,
	[WorksheetId] int NOT NULL,
	[DestinationColumn] nvarchar(4000) NOT NULL,
	[RuleEntityId] int NULL,
	[RuleDictionaryId] int NULL,
	[RuleKindId] int NOT NULL,
	[RuleDataTypeId] int NOT NULL,
	[RuleOperatorId] int NOT NULL,
	[Mandatory] bit NOT NULL,
	[TreatMissingDictionaryValueAsError] bit NOT NULL,
	[Description] nvarchar(max)  NULL,
	[Order] int NOT NULL

	 CONSTRAINT [PK_Rule_Id] PRIMARY KEY CLUSTERED 
	(
		[RuleId] ASC
	)
)
GO


ALTER TABLE [nkhtk].[Rule]  WITH CHECK ADD  CONSTRAINT [FK_Rule_WorksheetId] FOREIGN KEY([WorksheetId])
REFERENCES [nkhtk].[Worksheet] ([WorksheetId])
GO

ALTER TABLE [nkhtk].[Rule] CHECK CONSTRAINT [FK_Rule_WorksheetId]
GO


ALTER TABLE [nkhtk].[Rule]  WITH CHECK ADD  CONSTRAINT [FK_Rule_RuleEntityId] FOREIGN KEY([RuleEntityId])
REFERENCES [nkhtk].[RuleEntity] ([RuleEntityId])
GO

ALTER TABLE [nkhtk].[Rule] CHECK CONSTRAINT [FK_Rule_RuleEntityId]
GO

ALTER TABLE [nkhtk].[Rule]  WITH CHECK ADD  CONSTRAINT [FK_Rule_RuleDictionaryId] FOREIGN KEY([RuleDictionaryId])
REFERENCES [nkhtk].[RuleDictionary] ([RuleDictionaryId])
GO

ALTER TABLE [nkhtk].[Rule] CHECK CONSTRAINT [FK_Rule_RuleDictionaryId]
GO


ALTER TABLE [nkhtk].[Rule]  WITH CHECK ADD  CONSTRAINT [FK_Rule_RuleKindId] FOREIGN KEY([RuleKindId])
REFERENCES [nkhtk].[RuleKind] ([RuleKindId])
GO

ALTER TABLE [nkhtk].[Rule] CHECK CONSTRAINT [FK_Rule_RuleKindId]
GO

ALTER TABLE [nkhtk].[Rule]  WITH CHECK ADD  CONSTRAINT [FK_Rule_RuleDataTypeId] FOREIGN KEY([RuleDataTypeId])
REFERENCES [nkhtk].[RuleDataType] ([RuleDataTypeId])
GO

ALTER TABLE [nkhtk].[Rule] CHECK CONSTRAINT [FK_Rule_RuleDataTypeId]
GO

ALTER TABLE [nkhtk].[Rule]  WITH CHECK ADD  CONSTRAINT [FK_Rule_RuleOperatorId] FOREIGN KEY([RuleOperatorId])
REFERENCES [nkhtk].[RuleOperator] ([RuleOperatorId])
GO

ALTER TABLE [nkhtk].[Rule] CHECK CONSTRAINT [FK_Rule_RuleOperatorId]
GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Бизнес-правило для преобразования шаблонов из НХТК в СВТ' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'Rule'
GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Уникальный идентификатор правила' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'Rule', @level2type=N'COLUMN',@level2name=N'RuleId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Неуникальный необязательный идентификатор правила в матрице соответствия. Создан для удобства работы с требованими, описанными в матрице' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'Rule', @level2type=N'COLUMN',@level2name=N'WorksheetId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор вкладки шаблона, к которой принадлежит правило' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'Rule', @level2type=N'COLUMN',@level2name=N'MatrixId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Англоязычное человеко-читаемое уникальное имя, соответсвующее столбцу в шаблоне назначения (в данной реализации - СВТ)' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'Rule', @level2type=N'COLUMN',@level2name=N'DestinationColumn'
GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Коллекция сущностей, соответсвующее столбцу или ячейке исходном шаблоне назначения (в данной реализации - НХТК)' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'Rule', @level2type=N'COLUMN',@level2name=N'RuleEntityId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Словарь для маппинга между значениями исходного шаблона (НХТК) и шаблона назначени (СВТ)' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'Rule', @level2type=N'COLUMN',@level2name=N'RuleDictionaryId'
GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Категория правила: применяется ли правило к excel файлу, листу, колонке, ячейке и т.д.' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'Rule', @level2type=N'COLUMN',@level2name=N'RuleKindId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Тип данных, обрабатываемый правилом.' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'Rule', @level2type=N'COLUMN',@level2name=N'RuleDataTypeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Бинарный оператор для правила. Первый операнд - значение, хранящееся в шаблоне назначения "DestinationColumn" как результат выполнения предыдущего правила. Второй операнд - результат данного правила. Применяется только к числовым значениям' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'Rule', @level2type=N'COLUMN',@level2name=N'RuleOperatorId'

    
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Является ли правило обязательным. ' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'Rule', @level2type=N'COLUMN',@level2name=N'Mandatory'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'В случае установки этого флага отсутсвие значения в словаре для правила считается ошибкой' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'Rule', @level2type=N'COLUMN',@level2name=N'TreatMissingDictionaryValueAsError'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' Русскоязычное описание  правила' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'Rule', @level2type=N'COLUMN',@level2name=N'Description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Порядок, в котором правило будет выполняться' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'Rule', @level2type=N'COLUMN',@level2name=N'Order'
GO






INSERT INTO  [nkhtk].[Rule]
 (
	[RuleId]
	,[MatrixId]			
	,[RuleKindId]			
	,[RuleDataTypeId]		
	,[DestinationColumn]
	,[RuleEntityId]
	,[RuleDictionaryId]
	,[WorksheetId] 
	,[RuleOperatorId]		
	,[Mandatory]			
	,[TreatMissingDictionaryValueAsError]
	,[Description]		
	,[Order]				
)

	-- // 4  - all
 SELECT
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 4 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'LoadedRFSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'Тариф'), -- 
	[RuleDictionaryId]		= NULL,
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Копирует колонку "Тариф" или "Тариф РЖД" или "Тариф по РЖД" из шаблона НХТК "'+t.[TemplateRussianName]+'" из вкладки "' + ws.[WorksheetName] + '" в колонку "LoadedRFSize" шаблона СВТ',
	[Order]					= 400
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R


     --        // 4 - all
     --       // Добавляем значение из колонки "Охрана груза."
 UNION
 SELECT
 Id = [MatrixId] * 10000 + 1000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 4 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('Number'), 
	[DestinationColumn]		= N'LoadedRFSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'Охрана груза'),
	[RuleDictionaryId]		= NULL,
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('Plus'), 
	[Mandatory]				= 0,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Прибавляет колонку "Охрана груза." (если она есть) из шаблона "'+t.[TemplateRussianName]+'" из вкладки "' + ws.[WorksheetName] + '" к текущему значению колонки "LoadedRFSize" шаблона СВТ',
	[Order]					= 410
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R


 
--     // 4 - НБ-1 - МТБЭ Сахалин
--      // Применяем третье преобразование только для вкладки "МТБЭ Сахалин"
--       // Добавляем значение из колонки "Тариф Сахалин"
	UNION
 SELECT
 Id = [MatrixId] * 10000 + 2000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 4 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('Number'), 
	[DestinationColumn]		= N'LoadedRFSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'Тариф Сахалин'),
	[RuleDictionaryId]		= NULL,
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('Plus'), 
	[Mandatory]				= 0,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Прибавляет колонку "Тариф Сахалин" из шаблона "'+t.[TemplateRussianName]+'" из вкладки "' + ws.[WorksheetName] + '" к текущему значению колонки "LoadedRFSize" шаблона СВТ',
	[Order]					= 420
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE ws.WorksheetId = 6004 -- НБ-1 - МТБЭ Сахалин
 ) AS R



 	-- // 4  - all LoadedRFCurrency - RUB
UNION
 SELECT
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 5 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'LoadedRFCurrency',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'RUB'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+'" для вкладки "' + ws.[WorksheetName] + '" Копирует константу "RUB" в колонку "LoadedRFCurrency" шаблона СВТ',
	[Order]					= 500
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R


    --        // 8 - СУГ
    --        // Применяем первое преобразование - копирование из колонки исходного шаблона "ВС со СЗ Реализация"
    --        // в колонку СВТ "EmptyRFSize"
 UNION

 SELECT
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 8 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'EmptyRFSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ВС со СЗ'), -- 
	[RuleDictionaryId]		= NULL,
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Копирует колонку "ВС со СЗ" или "ВС со СЗ Реализация" из шаблона НХТК "'+t.[TemplateRussianName]+'" из вкладки "' + ws.[WorksheetName] + '" в колонку "EmptyRFSize" шаблона СВТ (первое преобразование)',
	[Order]					= 800
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN ('SUG-1','SUG-2','SUG-3-1', 'SUG-3-2','SHFLU')
 ) AS R


 UNION

     --        // 8 - СУГ
     --       // Применяем второе преобразование - вычитаение из колонки СВТ "EmptyRFSize"
     --       // Словарное значение, зависящее от "S, км"
 SELECT
 [RuleId] = [MatrixId] * 10000 + 1000+ ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 8 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'EmptyRFSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'S, км'), -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'SugDistance'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'Minus'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 1,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+'" из вкладки "' + ws.[WorksheetName] + '" вычитаение из колонки СВТ "EmptyRFSize" словарного значения, зависящего от "S, км" (второе преобразование)',
	[Order]					= 810
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN ('SUG-1','SUG-2','SUG-3-1', 'SUG-3-2','SHFLU')
 ) AS R



	GO