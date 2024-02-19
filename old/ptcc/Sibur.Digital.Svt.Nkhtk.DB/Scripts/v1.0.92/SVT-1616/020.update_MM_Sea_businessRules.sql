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
	 [RuleId] = [MatrixId] * 1100 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
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
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-New')
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
	 [RuleId] = [MatrixId] * 1100 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
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
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-New')
	 ) AS R

	 --------------------------------------------------------------------------------------------
	-- // 36  - RateTenderServicePack -- Пакет услуг
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
	---  Первое преобразование - копирование  колонки "Матрица"
	 SELECT
	 [RuleId] = [MatrixId] * 1100 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
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
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-New')
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
	 [RuleId] = [MatrixId] * 1100 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
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
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-New')
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
	 [RuleId] = [MatrixId] * 1100 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
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
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-New')
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
	 [RuleId] = [MatrixId] * 1100 + 1+ ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 146 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'ProxyNode',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море КОД  порта отправления'), -- 
		[RuleDictionaryId]		= NULL, -- словаря нет, простое копирование
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, -- а раз словаря нет, то и трактовать отсутствие словарного значения как ошибку не нужно
		[Description]			= N'Копирует колонку "КОД  порта отправления" для второго плеча из шаблона Суша-Море "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "ProxyNode" шаблона СВТ',
		[Order]					= 14600
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-New')
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
	 [RuleId] = [MatrixId] * 1100 + 1 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
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
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-New')
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
	 [RuleId] = [MatrixId] * 1100 + 1 +ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
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
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-New')
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
	 [RuleId] = [MatrixId] * 1100 + 1 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 149 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceSheetConstant'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'Leg2_TransportType',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море mix_sea'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  для второго плеча "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует константу "mix_sea" в колонку "Leg2_TransportType" шаблона СВТ',
		[Order]					= 14900
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-New')
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
	 [RuleId] = [MatrixId] * 1100 + 1 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 156 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'Leg2_TotalCostTransport',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море Стоимость морской перевозки, включая экспедирование в порту РФ, USD/ктк (Цена) (Цена)'), -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море 9'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, -- словарь подменяет девятки на [нет данных], и трактовать отсутствие словарного значения как ошибку не нужно
		[Description]			= N'Для второго плеча копирует колонку "Стоимость морской перевозки, включая экспедирование в порту РФ, USD/ктк (Цена) (Цена)" из шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "Leg2_TotalCostTransport" шаблона СВТ',
		[Order]					= 15600
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-New')
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
	 [RuleId] = [MatrixId] * 1100 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
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
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-New')
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
	 [RuleId] = [MatrixId] * 1100 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 149 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceSheetConstant'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'Leg1_TransportType',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море mix_rail_cont_40'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для первого плеча шаблона "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует константу "mix_rail_cont_40" в колонку "Leg1_TransportType" шаблона СВТ',
		[Order]					= 24900
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-New')
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
	 [RuleId] = [MatrixId] * 1100 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 150 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SheetParameter'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'Leg1_EffectiveLoad',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море EffectiveLoadOfTransportType'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для первого плеча шаблона  Суша-Море "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает полученные от пользователя данные в колонку "Leg1_EffectiveLoad" шаблона СВТ',
		[Order]					= 25000
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-New')

		UNION

		SELECT
		[MatrixId]				= 150 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SheetParameter'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'Leg2_EffectiveLoad',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море EffectiveLoadOfTransportType'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для второго плеча шаблона  Суша-Море "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает полученные от пользователя данные в колонку "Leg2_EffectiveLoad" шаблона СВТ',
		[Order]					= 25000
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-New')
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
	 [RuleId] = [MatrixId] * 1100 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
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
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-New')
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
	 [RuleId] = [MatrixId] * 1100 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
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
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-New')
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
	 [RuleId] = [MatrixId] * 1100 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
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
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-New')
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
	 [RuleId] = [MatrixId] * 1100 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
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
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-New')
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
	 [RuleId] = [MatrixId] * 1100  + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 156 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'Leg1_TotalCostTransport',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море Стоимость  ЖД перевозки по территории РФ включая все расходы  Перевозчика.в USD/ктк (Цена) (Цена)'), -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море 9'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, -- словарь подменяет девятки на [нет данных], и трактовать отсутствие словарного значения как ошибку не нужно
		[Description]			= N'Для первого плеча копирует колонку "Стоимость  ЖД перевозки по территории РФ включая все расходы  Перевозчика.в USD/ктк (Цена) (Цена)" из шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "Leg2_TotalCostTransport" шаблона СВТ',
		[Order]					= 25600
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-New')
	 ) AS R



	--------------------------------------------------------------------------------------------
	-- // 57  - Leg1_BaseCurrency  Leg2_BaseCurrency -- Общая валюта затрат
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
 		-- // 57  - all Leg1_BaseCurrency and Leg2_BaseCurrency - RUB
	 SELECT
	 [RuleId] = [MatrixId] * 11000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	from
	 (
		SELECT
		[MatrixId]				= 157 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SheetParameter'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'Leg1_BaseCurrency',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море GeneralCurrency'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает полученную от пользователя валюту в колонку "Leg1_BaseCurrency" шаблона СВТ',
		[Order]					= 25700
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-New')


        UNION

        SELECT
		[MatrixId]				= 157 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SheetParameter'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'Leg2_BaseCurrency',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море GeneralCurrency'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает полученную от пользователя валюту в колонку "Leg2_BaseCurrency" шаблона СВТ',
		[Order]					= 25700
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-New')

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
	 [RuleId] = [MatrixId] * 11000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
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
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-New')
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