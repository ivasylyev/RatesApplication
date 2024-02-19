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
	-- // 34  - Nomination -- Номинация по результатам тендера (%)
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
		[MatrixId]				= 134 ,  -- на самом деле это 34-ая колонка. Но чтобы отличать от НХТК добавляем единичку ))
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
		[DestinationColumn]		= N'Nomination',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море Номинация СВТ'), -- 
		[RuleDictionaryId]		= NULL, -- словаря нет, простое копирование
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, -- а раз словаря нет, то и трактовать отсутствие словарного значения как ошибку не нужно
		[Description]			= N'Копирует колонку "Номинация СВТ" или "%" из шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "Nomination" шаблона СВТ',
		[Order]					= 13400
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea')
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
		[MatrixId]				= 135 ,  -- на самом деле это 35-ая колонка. Но чтобы отличать от НХТК добавляем единичку ))
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'Counterparty',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море Контрагент'), -- 
		[RuleDictionaryId]		= NULL, -- словаря нет, простое копирование
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, -- а раз словаря нет, то и трактовать отсутствие словарного значения как ошибку не нужно
		[Description]			= N'Копирует колонку "Код контрагента" или "Код КА" из шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "Counterparty" шаблона СВТ',
		[Order]					= 13500
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea')
	 ) AS R

	 --------------------------------------------------------------------------------------------
	-- // 36  - RateTenderServicePack -- Пакет услуг
	--------------------------------------------------------------------------------------------


	-----------------------------------------------------------------------------
	--- ВНИМАНИЕ НА ПОРЯДОК [Order]! ЭТО ПРЕОБРАЗОВАНИЕ ДОЛЖНО БЫТЬ ПЕРВЫМ ПО СПИСКУ,
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
	---  Первое преобразование - копирование  колонки "Матрица"
	 SELECT
	 [RuleId] = [MatrixId] * 1000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 136,  
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'RateTenderServicePack',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море Матрица'), -- 
		[RuleDictionaryId]		= NULL, -- словаря нет, простое копирование
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, 
		[Description]			= N'Копирует колонку "Матрица" из шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "RateTenderServicePack" шаблона СВТ',
		[Order]					= 1361
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea')
	 ) AS R

	 ---  Второе преобразование - добавление "_"
	 UNION
	 SELECT
	 Id = [MatrixId] * 1000 + 100 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 136 , 
		[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'DestinationSheetConstant'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'RateTenderServicePack',
		[RuleEntityId]			= NULL,
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море _'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('Concat'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Прибавляет знак подчеркивания "_" к текущему значению колонки "RateTenderServicePack" шаблона СВТ',
		[Order]					= 1362
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea')
	 ) AS R
 
	 UNION
	 ---  Третье преобразование - добавление  колонки "Описание строки"
	 SELECT
	 [RuleId] = [MatrixId] * 1000 + 200+ ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 136,  
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'RateTenderServicePack',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море Описание строки'), -- 
		[RuleDictionaryId]		= NULL, -- словаря нет, простое копирование
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'Concat'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, 
		[Description]			= N'Добавляет колонку "Описание строки" из шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "RateTenderServicePack" шаблона СВТ',
		[Order]					= 1363
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea')
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
		[MatrixId]				= 144 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'DestinationSheetConstant'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'RateCalcType',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море ТС'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует константу "ТС" в колонку "RateCalcType" шаблона СВТ',
		[Order]					= 14400
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea')
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
		[MatrixId]				= 145 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'DestinationSheetConstant'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'RateType',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море 2'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует константу "2" в колонку "RateType" шаблона СВТ',
		[Order]					= 14500
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea')
	 ) AS R




	--------------------------------------------------------------------------------------------
	-- // 46  - NodeFrom -- Узел отправления - Второе плечо
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
	 [RuleId] = [MatrixId] * 1000 + 1+ ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 146 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'NodeFrom',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море КОД  порта отправления'), -- 
		[RuleDictionaryId]		= NULL, -- словаря нет, простое копирование
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, -- а раз словаря нет, то и трактовать отсутствие словарного значения как ошибку не нужно
		[Description]			= N'Копирует колонку "КОД  порта отправления" для второго плеча из шаблона Суша-Море "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "NodeFrom" шаблона СВТ',
		[Order]					= 14600
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea')
	 ) AS R



	--------------------------------------------------------------------------------------------
	-- // 47  - NodeTo -- Узел назначения - Второе плечо
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
		[MatrixId]				= 147 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'NodeTo',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море Узел назначения'), -- 
		[RuleDictionaryId]		= NULL, -- словаря нет, простое копирование
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, -- а раз словаря нет, то и трактовать отсутствие словарного значения как ошибку не нужно
		[Description]			= N'Копирует колонку "Узел назначения" для второго плеча из шаблона Суша-Море "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "NodeTo" шаблона СВТ',
		[Order]					= 14700
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea')
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
		[MatrixId]				= 148 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'DestinationSheetConstant'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'TransportKind',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море Mix'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует константу "Mix" в колонку "TransportKind" шаблона СВТ',
		[Order]					= 14800
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea')
	 ) AS R





 

	 --------------------------------------------------------------------------------------------
	-- // 49  - TransportType -- Тип транспорта - второе плечо
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
		[MatrixId]				= 149 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceSheetConstant'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'TransportType',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море mix_sea'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  для второго плеча "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует константу "mix_sea" в колонку "TransportType" шаблона СВТ',
		[Order]					= 14900
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea')
	 ) AS R





 
	--------------------------------------------------------------------------------------------
	-- // 56  - TotalCostTransport --Общая стоимость за транспортное средство - второе плечо
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
		[MatrixId]				= 156 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'TotalCostTransport',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море Стоимость морской перевозки, включая экспедирование в порту РФ, USD/ктк (Цена) (Цена)'), -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море 9'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, -- словарь подменяет девятки на [нет данных], и трактовать отсутствие словарного значения как ошибку не нужно
		[Description]			= N'Для второго плеча копирует колонку "Стоимость морской перевозки, включая экспедирование в порту РФ, USD/ктк (Цена) (Цена)" из шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "TotalCostTransport" шаблона СВТ',
		[Order]					= 15600
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea')
	 ) AS R




	 -----------!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!-------------------

	 --------------------------------------------------------------------------------------------
	-- // Мультипликатор, который просто дублирует все записи. Первая половина записей будет переписана правилами
	-- которые применяются только к первому плечу. Вторая половина записей останется со значениями для второго плеча.
	--------------------------------------------------------------------------------------------


	-- Внимание на порядок правил! мультипликатор должен быть строго после всех общих правил и правил второго плеча, но перед правилами первого плеча.
	-- Для того,  чтобы первое плечо потом перезатерло уже заполненные данные второго плеча в начале страницы
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
	 Id = [MatrixId] * 1000  + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 101 , 
		[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
		[DestinationColumn]		= N'Code',
		[RuleEntityId]			= NULL,
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море Мультипликатор'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Дублирует все записи в шаблоне СВТ Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName],
		[Order]					= 20000
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea')
	 ) AS R


 
	--------------------------------------------------------------------------------------------
	-- // 46  - NodeFrom -- Узел отправления - Первое плечо
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
		[MatrixId]				= 146 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'NodeFrom',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море Узел отправления'), -- 
		[RuleDictionaryId]		= NULL, -- словаря нет, простое копирование
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, -- а раз словаря нет, то и трактовать отсутствие словарного значения как ошибку не нужно
		[Description]			= N'Копирует колонку "Узел отправления" для первого плеча из шаблона Суша-Море "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "NodeFrom" шаблона СВТ',
		[Order]					= 24600 -- чтобы было после мультипликатора
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea')
	 ) AS R


 

	--------------------------------------------------------------------------------------------
	-- // 47  - NodeTo -- Узел назначения - первое плечо
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
		[MatrixId]				= 147 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'NodeTo',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море КОД  порта отправления'), -- 
		[RuleDictionaryId]		= NULL, -- словаря нет, простое копирование
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, -- а раз словаря нет, то и трактовать отсутствие словарного значения как ошибку не нужно
		[Description]			= N'Копирует колонку "КОД  порта отправления" для первого плеча из шаблона Суша-Море "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "NodeTo" шаблона СВТ',
		[Order]					= 24700
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea')
	 ) AS R





	 --------------------------------------------------------------------------------------------
	-- // 49  - TransportType -- Тип транспорта - первое плечо
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
		[MatrixId]				= 149 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceSheetConstant'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'TransportType',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море mix_rail_cont_40'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  для первого плеча "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует константу "mix_rail_cont_40" в колонку "TransportType" шаблона СВТ',
		[Order]					= 24900
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea')
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
		[MatrixId]				= 150 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SheetParameter'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'EffectiveLoadOfTransportType',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море EffectiveLoadOfTransportType'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  Суша-Море "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает полученные от пользователя данные в колонку "EffectiveLoadOfTransportType" шаблона СВТ',
		[Order]					= 25000
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea')
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
		[MatrixId]				= 151 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SheetParameter'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'ProductGroup',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море ProductGroup'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  Суша-Море "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает полученные от пользователя данные в колонку "ProductGroup" шаблона СВТ',
		[Order]					= 25100
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea')
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
		[MatrixId]				= 152 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SheetParameter'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'Product',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море Product'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  Суша-Море "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает полученные от пользователя данные в колонку "Product" шаблона СВТ',
		[Order]					= 25200
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea')
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
		[MatrixId]				= 153 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SheetParameter'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'DateTime'), 
		[DestinationColumn]		= N'StartDate',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море StartDate'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  Суша-Море "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает полученную от пользователя дату в колонку "StartDate" шаблона СВТ',
		[Order]					= 25300
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea')
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
		[MatrixId]				= 154 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SheetParameter'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'DateTime'), 
		[DestinationColumn]		= N'EndDate',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море EndDate'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  Суша-Море "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает полученную от пользователя дату в колонку "EndDate" шаблона СВТ',
		[Order]					= 25400
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea')
	 ) AS R




  
	--------------------------------------------------------------------------------------------
	-- // 56  - TotalCostTransport --Общая стоимость за транспортное средство - первое плечо
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
	 [RuleId] = [MatrixId] * 1000  + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 156 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'TotalCostTransport',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море Стоимость  ЖД перевозки по территории РФ включая все расходы  Перевозчика.в USD/ктк (Цена) (Цена)'), -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море 9'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, -- словарь подменяет девятки на [нет данных], и трактовать отсутствие словарного значения как ошибку не нужно
		[Description]			= N'Для первого плеча копирует колонку "Стоимость  ЖД перевозки по территории РФ включая все расходы  Перевозчика.в USD/ктк (Цена) (Цена)" из шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "TotalCostTransport" шаблона СВТ',
		[Order]					= 25600
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea')
	 ) AS R



	--------------------------------------------------------------------------------------------
	-- // 57  - GeneralCurrency  -- Общая валюта затрат
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
 		-- // 57  - all GeneralCurrency - RUB
	 SELECT
	 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	from
	 (
		SELECT
		[MatrixId]				= 157 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SheetParameter'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'GeneralCurrency',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море GeneralCurrency'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает полученную от пользователя валюту в колонку "GeneralCurrency" шаблона СВТ',
		[Order]					= 25700
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea')
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
		[MatrixId]				= 158 , 
		[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'DestinationSheetConstant'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'stg_Operation',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море stg_Operation_1'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона"'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует константу "1" в колонку "stg_Operation" шаблона СВТ',
		[Order]					= 25800
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea')
	 ) AS R



	 --------------------------------------------------------------------------------------------
	 --------------------------------------------------------------------------------------------
	 --------------------------------------------------------------------------------------------
	 --------------------------------------------------------------------------------------------
	 --------------------------------------------------------------------------------------------
	 --------------------------------------------------------------------------------------------

 	 --------------------------------------------------------------------------------------------
	 -- СПЕЦСТАВКИ
	 --------------------------------------------------------------------------------------------
	 --------------------------------------------------------------------------------------------
	 --------------------------------------------------------------------------------------------
	 --------------------------------------------------------------------------------------------
	 --------------------------------------------------------------------------------------------
	 --------------------------------------------------------------------------------------------
	 --------------------------------------------------------------------------------------------

 
 
 
	--------------------------------------------------------------------------------------------
	-- // 2  - StartDate -- Дата начала
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
		[MatrixId]				= 102 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SheetParameter'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'DateTime'), 
		[DestinationColumn]		= N'StartDate',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море StartDate'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  спецставок "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает полученную от пользователя дату в колонку "StartDate" шаблона СВТ',
		[Order]					= 202300  ---!!!!!! ПОРЯДОК нужно указывать такой, чтобы эти правила выполнялись ПОСЛЕ ВСЕХ. Иначе неизвестно в результирующем шаблоне строк нет, а если строк нет - то и вставлять даты некуда
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-Special')
	 ) AS R


	--------------------------------------------------------------------------------------------
	-- // 3  - EndDate -Дата окончания
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
		[MatrixId]				= 103 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SheetParameter'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'DateTime'), 
		[DestinationColumn]		= N'EndDate',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море EndDate'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  спецставок "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает полученную от пользователя дату в колонку "EndDate" шаблона СВТ',
		[Order]					= 20300  ---!!!!!! ПОРЯДОК нужно указывать такой, чтобы эти правила выполнялись ПОСЛЕ ВСЕХ. Иначе неизвестно в результирующем шаблоне строк нет, а если строк нет - то и вставлять даты некуда
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-Special')
	 ) AS R


	 --------------------------------------------------------------------------------------------
	-- // 4  - StartNode -- Начальная точка - спецставки
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
	 [RuleId] = [MatrixId] * 1000 + 1+ ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 104 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'StartNode',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море Узел отправления'), -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море Узел отправления'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 1, -- трактовать отсутствие словарного значения как ошибку  !!!
		[Description]			= N'Копирует колонку "Узел отправления" для спецставок "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "StartNode" шаблона СВТ',
		[Order]					= 20400
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-Special')
	 ) AS R



	--------------------------------------------------------------------------------------------
	-- // 5  - NodeFrom -- Узел отправления - спецставки
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
	 [RuleId] = [MatrixId] * 1000 + 1+ ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 105 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'NodeFrom',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море КОД  порта отправления'), -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море Промежуточный узел'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 1, -- трактовать отсутствие словарного значения как ошибку  !!!
		[Description]			= N'Копирует колонку "КОД  порта отправления" для спецставок "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "NodeFrom" шаблона СВТ',
		[Order]					= 10500
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-Special')
	 ) AS R



	--------------------------------------------------------------------------------------------
	-- // 06  - NodeTo -- Узел назначения - спецставки
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
		[MatrixId]				= 106 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'NodeTo',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море Узел назначения'), -- 
		[RuleDictionaryId]		= NULL, -- словаря нет, простое копирование
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, -- а раз словаря нет, то и трактовать отсутствие словарного значения как ошибку не нужно
		[Description]			= N'Копирует колонку "Узел назначения" для спецставок "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "NodeTo" шаблона СВТ',
		[Order]					= 10600
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-Special')
	 ) AS R




	 
 
	--------------------------------------------------------------------------------------------
	-- // 07  - ProductGroup -- Группа продуктов
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
		[MatrixId]				= 107 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SheetParameter'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'ProductGroup',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море ProductGroup'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона спецставок "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает полученные от пользователя данные в колонку "ProductGroup" шаблона СВТ',
		[Order]					= 10700
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-Special')
	 ) AS R



	--------------------------------------------------------------------------------------------
	-- // 8  - Product -- Продукт
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
		[MatrixId]				= 108 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SheetParameter'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'Product',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море Product'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  спецставок "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает полученные от пользователя данные в колонку "Product" шаблона СВТ',
		[Order]					= 10800
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-Special')
	 ) AS R




	 

	 --------------------------------------------------------------------------------------------
	-- // 9  - TransportKind -- Вид транспорта
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
		[MatrixId]				= 109 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'DestinationSheetConstant'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'TransportKind',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море Mix'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  спецставок"'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует константу "Mix" в колонку "TransportKind" шаблона СВТ',
		[Order]					= 10900
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-Special')
	 ) AS R





 

	 --------------------------------------------------------------------------------------------
	-- // 10  - TransportType -- Тип транспорта - второе плечо
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
		[MatrixId]				= 110 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'DestinationSheetConstant'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'TransportType',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море mix_sea'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона спецставок "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует константу "mix_sea" в колонку "TransportType" шаблона СВТ',
		[Order]					= 11000
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-Special')
	 ) AS R




  
 
	--------------------------------------------------------------------------------------------
	-- // 11  - EffectiveLoadOfTransportType -- Эффективная загрузка типа транспорта (в тоннах)
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
		[MatrixId]				= 111 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SheetParameter'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'EffectiveLoadOfTransportType',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море EffectiveLoadOfTransportType'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона спецставок "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает полученные от пользователя данные в колонку "EffectiveLoadOfTransportType" шаблона СВТ',
		[Order]					= 11100
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-Special')
	 ) AS R




	 
	--------------------------------------------------------------------------------------------
	-- // 12  - Basis -- Базис поставки - подстановка пользовательского значения - первое преобразование
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
		[MatrixId]				= 112 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SheetParameter'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'Basis',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море Basis'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона спецставок "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает полученные от пользователя данные в колонку "Basis" шаблона СВТ',
		[Order]					= 11200
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-Special')
	 ) AS R


	 
	 
	--------------------------------------------------------------------------------------------
	-- // 12  - Basis -- Базис поставки - маппинг - второе преобразование
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
	 [RuleId] = [MatrixId] * 1000 + 10 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 112 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'DestinationColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'Basis',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море Basis'), 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море Basis Mapping'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 1,
		[Description]			= N'Для шаблона спецставок подменяет колонку "Basis" шаблона СВТ в зависимости от маппинга из имени в код',
		[Order]					= 11202
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-Special')
	 ) AS R


	 	--------------------------------------------------------------------------------------------
	-- // 14  - TotalCostTransport -- Ставка за ТС (эталон) - первое преобразование
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
		[MatrixId]				= 114 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'TotalCostTransport',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море Стоимость морской перевозки, включая экспедирование в порту РФ, USD/ктк (Цена) (Цена)'), -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море 9'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, -- словарь подменяет девятки на [нет данных], и трактовать отсутствие словарного значения как ошибку не нужно
		[Description]			= N'Для шаблона спецставок копирует колонку "Стоимость морской перевозки, включая экспедирование в порту РФ, USD/ктк (Цена) (Цена)" из шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "TotalCostTransport" шаблона СВТ',
		[Order]					= 11400
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-Special')
	 ) AS R




	--------------------------------------------------------------------------------------------
-- // 14  - TotalCostTransport -- Ставка за ТС (эталон) - ВТОРОЕ преобразование
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
	 [RuleId] = [MatrixId] * 1000  + 2 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 114 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'TotalCostTransport',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море Стоимость  ЖД перевозки по территории РФ включая все расходы  Перевозчика.в USD/ктк (Цена) (Цена)'), -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море 9'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'Plus'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, -- словарь подменяет девятки на [нет данных], и трактовать отсутствие словарного значения как ошибку не нужно
		[Description]			= N'Для первого плеча копирует колонку "Стоимость  ЖД перевозки по территории РФ включая все расходы  Перевозчика.в USD/ктк (Цена) (Цена)" из шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "TotalCostTransport" шаблона СВТ',
		[Order]					= 11401
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-Special')
	 ) AS R



	 

	 	--------------------------------------------------------------------------------------------
	-- // 13  - TotalCostTonStandard --Ставка за т (эталон) - первое преобразование ПОСЛЕ TotalCostTransport
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
		[MatrixId]				= 113 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'DestinationColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'TotalCostTonStandard',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море TotalCostTransport'), -- 
		[RuleDictionaryId]		= NULL, -- словаря нет, простое копирование
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, -- а раз словаря нет, то и трактовать отсутствие словарного значения как ошибку не нужно
		[Description]			= N'Для шаблона спецставок заполняет колонку "TotalCostTonStandard" шаблона СВТ в зависимости от ранее заполненной колонки "TotalCostTransport"  шаблона СВТ. Применять можно только после правила "Ставка за т (эталон)!" (TotalCostTonStandard)',
		[Order]					= 21300  -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  ПОСЛЕ TotalCostTransport  
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-Special')
	 ) AS R



	 
	 

	 	--------------------------------------------------------------------------------------------
	-- // 13  - TotalCostTonStandard --Ставка за т (эталон) - ВТОРОЕ преобразование ПОСЛЕ TotalCostTransport
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
	 [RuleId] = [MatrixId] * 1000 + 2 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 113 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'DestinationColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'TotalCostTonStandard',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море EffectiveLoadOfTransportType'), -- 
		[RuleDictionaryId]		= NULL, -- словаря нет, простое копирование
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'Divide'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, -- а раз словаря нет, то и трактовать отсутствие словарного значения как ошибку не нужно
		[Description]			= N'Делит на колонку "Загрузка, т" (EffectiveLoadOfTransportType) из шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" текущее значение колонки "TotalCostTonStandard" шаблона СВТ',
		[Order]					= 21302  -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  ПОСЛЕ TotalCostTransport  и ПОСЛЕ первого преобразования 
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-Special')
	 ) AS R


	 	 	--------------------------------------------------------------------------------------------
	-- // 15  - CurrencyStandard --Валюта-эталон
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
	 Id = [MatrixId] * 1000 + 100 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 115 , 
		[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetParameter'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'CurrencyStandard',
		[RuleEntityId]			= NULL,
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море CurrencyStandard'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" вставляет значение валюты от пользователя в колонку "CurrencyStandard" шаблона СВТ',
		[Order]					= 11501
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-Special')
	 ) AS R


	 

	--------------------------------------------------------------------------------------------
	-- // 16  - stg_Operation  -- Тип операции
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
 		-- // 16  - all stg_Operation - 1
	 SELECT
	 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 116 , 
		[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'DestinationSheetConstant'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'stg_Operation',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море stg_Operation_1'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона"'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует константу "1" в колонку "stg_Operation" шаблона СВТ',
		[Order]					= 11600
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-Special')
	 ) AS R






	 
 
	--------------------------------------------------------------------------------------------
	-- // ??  - CurrencyDate -- текущая дата
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
		[MatrixId]				= 117 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SheetParameter'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'DateTime'), 
		[DestinationColumn]		= N'CurrencyDate',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море CurrencyDate'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  Суша-Море "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает текущую  дату в колонку "CurrencyDate" шаблона СВТ',
		[Order]					= 11700
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-Special')
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