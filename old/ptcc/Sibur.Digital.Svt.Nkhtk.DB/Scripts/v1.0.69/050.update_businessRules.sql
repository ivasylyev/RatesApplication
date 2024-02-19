USE [mdm_integ]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


BEGIN TRY

    DECLARE @LocalTran BIT = IIF(@@TRANCOUNT = 0, 1, 0)

    IF @LocalTran = 1
        BEGIN TRAN





	--------------------------------------------------------------------------------------------
	-- // ??  - TotalCostTransport -- Ставка за ТС (эталон) - удаление
	--------------------------------------------------------------------------------------------

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
	 SELECT
	 [RuleId] = [MatrixId] * 1000  + 1 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 97 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceSheetDeleteRows'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'TotalCostTransport',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Суша Total rate, including 7 days of free storage, usd (Цена)'), -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Суша 9'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, -- наличие в словаре является критерием для удаления. отсутсвие - критерием, чтобы строку оставить. и трактовать отсутствие словарного значения как ошибку не нужно
		[Description]			= N'Удаляет строки в исходном шаблоне, если их Total rate содержит 0, пустоту, 99, 999, 9999 и тд',
		[Order]					= 99
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Land')
	 ) AS R


	

	--------------------------------------------------------------------------------------------
	-- // 34  - Nomination -- Номинация
	--------------------------------------------------------------------------------------------


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
	 SELECT
	 [RuleId] = [MatrixId] * 1000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 234 ,  -- на самом деле это 34-ая колонка. Но чтобы отличать от других шаблонов, добавляем двоечку ))
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
		[DestinationColumn]		= N'Nomination',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Суша Номинация'), -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Суша Номинация 0'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, -- а раз словаря нет, то и трактовать отсутствие словарного значения как ошибку не нужно
		[Description]			= N'Копирует колонку "Номинация" из шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "Nomination" шаблона СВТ',
		[Order]					= 23400
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Land')
	 ) AS R


	--------------------------------------------------------------------------------------------
	-- // 35  - Counterparty -- Контрагент (транспортная компания)
	--------------------------------------------------------------------------------------------


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
	 SELECT
	 [RuleId] = [MatrixId] * 1000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 235 ,  
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'Counterparty',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Суша Номер КА'), -- 
		[RuleDictionaryId]		= NULL, -- словаря нет, простое копирование
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, -- а раз словаря нет, то и трактовать отсутствие словарного значения как ошибку не нужно
		[Description]			= N'Копирует колонку "Номер КА" из шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "Counterparty" шаблона СВТ',
		[Order]					= 23500
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Land')
	 ) AS R

	 --------------------------------------------------------------------------------------------
	-- // 36  - RateTenderServicePack -- Пакет услуг
	--------------------------------------------------------------------------------------------


	-----------------------------------------------------------------------------
	--- ВНИМАНИЕ НА ПОРЯДОК [Order]! ЭТО ПРЕОБРАЗОВАНИЕ ДОЛЖНО БЫТЬ ВТОРЫМ ПО СПИСКУ, после удаления лишних строк
	--- потому что конвертер берет столбец из первого правила, и преобразует все строки пока не наткнется на пустую ячейку в этом столбце
	--- то есть надо выбрать в качестве первого преобразования то правило, котрое оперирует с обязательным столбцом (желательно, ключевым)
	-----------------------------------------------------------------------------


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
	---   преобразование - копирование  колонки "Пакет услуг"
	 SELECT
	 [RuleId] = [MatrixId] * 1000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 236,  
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'RateTenderServicePack',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Суша Пакет услуг'), -- 
		[RuleDictionaryId]		= NULL, -- словаря нет, простое копирование
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, 
		[Description]			= N'Копирует колонку "Пакет услуг" из шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "RateTenderServicePack" шаблона СВТ',
		[Order]					= 2361
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Land')
	 ) AS R

	 

	 --------------------------------------------------------------------------------------------
	-- // 44  - RateCalcType -- Способ расчёта ставки
	--------------------------------------------------------------------------------------------



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

	 SELECT
	 [RuleId] = [MatrixId] * 1000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 244 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'DestinationSheetConstant'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'RateCalcType',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Суша ТС'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует константу "ТС" в колонку "RateCalcType" шаблона СВТ',
		[Order]					= 24400
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Land')
	 ) AS R



 
	 --------------------------------------------------------------------------------------------
	-- // 45  - RateType -- Тип ставки
	--------------------------------------------------------------------------------------------


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
	 SELECT
	 [RuleId] = [MatrixId] * 1000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 245 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'DestinationSheetConstant'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'RateType',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Суша 2'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует константу "2" в колонку "RateType" шаблона СВТ',
		[Order]					= 214500
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Land')
	 ) AS R


	--------------------------------------------------------------------------------------------
	-- // 46  - NodeFrom -- Узел отправления 
	--------------------------------------------------------------------------------------------


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
	 SELECT
	 [RuleId] = [MatrixId] * 1000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 246 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'NodeFrom',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Суша Узел отправления'), -- 
		[RuleDictionaryId]		= NULL, -- словаря нет, простое копирование
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, -- а раз словаря нет, то и трактовать отсутствие словарного значения как ошибку не нужно
		[Description]			= N'Копирует колонку "Узел отправления" из шаблона Суша-Суша "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "NodeFrom" шаблона СВТ',
		[Order]					= 24600 --
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Land')
	 ) AS R





	--------------------------------------------------------------------------------------------
	-- // 47  - NodeTo -- Узел назначения 
	--------------------------------------------------------------------------------------------

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
	 SELECT
	 [RuleId] = [MatrixId] * 1000 + 1 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 247 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'NodeTo',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Суша Узел назначения'), -- 
		[RuleDictionaryId]		= NULL, -- словаря нет, простое копирование
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, -- а раз словаря нет, то и трактовать отсутствие словарного значения как ошибку не нужно
		[Description]			= N'Копирует колонку "Узел назначения" для второго плеча из шаблона Суша-Суша "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "NodeTo" шаблона СВТ',
		[Order]					= 24700
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Land')
	 ) AS R



	 --------------------------------------------------------------------------------------------
	-- // 48  - TransportKind -- Вид транспорта
	--------------------------------------------------------------------------------------------

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

	 SELECT
	 [RuleId] = [MatrixId] * 1000 + 1 +ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 248 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'DestinationSheetConstant'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'TransportKind',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Суша Mix'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует константу "Mix" в колонку "TransportKind" шаблона СВТ',
		[Order]					= 24800
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Land')
	 ) AS R

 

	 --------------------------------------------------------------------------------------------
	-- // 49  - TransportType -- Тип транспорта 
	--------------------------------------------------------------------------------------------

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

	 SELECT
	 [RuleId] = [MatrixId] * 1000 + 1 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 249 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceSheetConstant'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'TransportType',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Суша Mix_40'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует константу "Mix_40" в колонку "TransportType" шаблона СВТ',
		[Order]					= 24900
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Land')
	 ) AS R



 
	--------------------------------------------------------------------------------------------
	-- // 50  - EffectiveLoadOfTransportType -- Эффективная загрузка типа транспорта (в тоннах)
	--------------------------------------------------------------------------------------------

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

	 SELECT
	 [RuleId] = [MatrixId] * 1000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 250 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SheetParameter'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'EffectiveLoadOfTransportType',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Суша EffectiveLoadOfTransportType'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  Суша-Суша "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает полученные от пользователя данные в колонку "EffectiveLoadOfTransportType" шаблона СВТ',
		[Order]					= 25000
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Land')
	 ) AS R


 
	--------------------------------------------------------------------------------------------
	-- // 51  - ProductGroup -- Группа продуктов
	--------------------------------------------------------------------------------------------

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

	 SELECT
	 [RuleId] = [MatrixId] * 1000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 251 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SheetParameter'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'ProductGroup',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Суша ProductGroup'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  Суша-Суша "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает полученные от пользователя данные в колонку "ProductGroup" шаблона СВТ',
		[Order]					= 25100
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Land')
	 ) AS R



	--------------------------------------------------------------------------------------------
	-- // 52  - Product -- Продукт
	--------------------------------------------------------------------------------------------

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

	 SELECT
	 [RuleId] = [MatrixId] * 1000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 252 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SheetParameter'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'Product',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Суша Product'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  Суша-Суша "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает полученные от пользователя данные в колонку "Product" шаблона СВТ',
		[Order]					= 25200
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Land')
	 ) AS R



 
	--------------------------------------------------------------------------------------------
	-- // 53  - StartDate -- Период действия с
	--------------------------------------------------------------------------------------------

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

	 SELECT
	 [RuleId] = [MatrixId] * 1000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 253 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SheetParameter'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'DateTime'), 
		[DestinationColumn]		= N'StartDate',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Суша StartDate'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  Суша-Суша "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает полученную от пользователя дату в колонку "StartDate" шаблона СВТ',
		[Order]					= 25300
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Land')
	 ) AS R



	--------------------------------------------------------------------------------------------
	-- // 54  - EndDate -Период действия по
	--------------------------------------------------------------------------------------------

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

	 SELECT
	 [RuleId] = [MatrixId] * 1000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 254 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SheetParameter'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'DateTime'), 
		[DestinationColumn]		= N'EndDate',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Суша EndDate'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  Суша-Суша "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает полученную от пользователя дату в колонку "EndDate" шаблона СВТ',
		[Order]					= 25400
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Land')
	 ) AS R




  

 
	--------------------------------------------------------------------------------------------
	-- // 55  - TotalCostTransport --Общая стоимость за транспортное средство 
	--------------------------------------------------------------------------------------------


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
	 SELECT
	 [RuleId] = [MatrixId] * 1000 + 1 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 255 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'TotalCostTransport',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Суша Total rate, including 7 days of free storage, usd (Цена)'), -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Суша 9'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, -- словарь подменяет девятки на [нет данных], и трактовать отсутствие словарного значения как ошибку не нужно
		[Description]			= N'Для шаблона  "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует колонку "ММ Суша-Суша Total rate, including 7 days of free storage, usd (Цена)" в колонку "TotalCostTransport" шаблона СВТ',
		[Order]					= 25500
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Land')
	 ) AS R







	--------------------------------------------------------------------------------------------
	-- // 56  - GeneralCurrency  -- Общая валюта затрат
	--------------------------------------------------------------------------------------------


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
 		-- // 56  - all GeneralCurrency - RUB
	 SELECT
	 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	from
	 (
		SELECT
		[MatrixId]				= 256 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SheetParameter'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'GeneralCurrency',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Суша GeneralCurrency'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает полученную от пользователя валюту в колонку "GeneralCurrency" шаблона СВТ',
		[Order]					= 25600
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Land')
	 ) AS R




	--------------------------------------------------------------------------------------------
	-- // 58  - stg_Operation  -- Тип операции
	--------------------------------------------------------------------------------------------


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
 		-- // 58  - all stg_Operation - 1
	 SELECT
	 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 258 , 
		[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'DestinationSheetConstant'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'stg_Operation',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Суша stg_Operation_1'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует константу "1" в колонку "stg_Operation" шаблона СВТ',
		[Order]					= 25800
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Land')
	 ) AS R









	 
	 	--------------------------------------------------------------------------------------------
	-- // ??  - 60 -- преобразование - добавление  колонки "Описание строки"
	--------------------------------------------------------------------------------------------


	
	 

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
	 ---  преобразование - добавление  колонки "Описание строки"
	 SELECT
	 [RuleId] = [MatrixId] * 1000 + 100 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 260,  
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'TechNumLine',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Суша Описание строки'), -- 
		[RuleDictionaryId]		= NULL, -- словаря нет, простое копирование
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 0,
		[TreatMissingDictionaryValueAsError] = 0, 
		[Description]			= N'Копирует колонку "Описание строки" из шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "RateTenderServicePack" шаблона СВТ',
		[Order]					= 2600
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Land')
	 ) AS R








    IF @LocalTran = 1 AND XACT_STATE() = 1
        COMMIT TRAN

END TRY

BEGIN CATCH

DECLARE
    @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE() + ISNULL(', PROC: ' + ERROR_PROCEDURE(), '') + ', LINE: ' + CAST(ERROR_LINE() AS VARCHAR(10)),
    @ErrorSeverity INT = ERROR_SEVERITY(),
    @ErrorState INT = ERROR_STATE()

IF @LocalTran = 1 AND XACT_STATE() <> 0
    ROLLBACK TRAN

RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH