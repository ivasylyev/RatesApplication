USE [mdm_integ]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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
	[Description]			= N'Копирует колонку "Тариф" или "Тариф РЖД" или "Тариф по РЖД" из шаблона НХТК "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "LoadedRFSize" шаблона СВТ',
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
	[Mandatory]				= 0,  -- НЕ обзязательное правило. Оаны может и не быть.
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Прибавляет колонку "Охрана груза." (если она есть) из шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" к текущему значению колонки "LoadedRFSize" шаблона СВТ',
	[Order]					= 410
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R


 
--     // 4 - НБ-1 - МТБЭ Сахалин
--      // Применяем третье преобразование только для вкладки "МТБЭ Сахалин"
--       // Добавляем значение из колонки "Тариф Сахалин"
	UNION
 SELECT
 Id = [MatrixId] * 10000 + 1100 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
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
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Прибавляет колонку "Тариф Сахалин" из шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" к текущему значению колонки "LoadedRFSize" шаблона СВТ',
	[Order]					= 420
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE ws.WorksheetId = 6004 -- НБ-1 - МТБЭ Сахалин
 ) AS R

 

  --          // 4 - 06 – КАУЧУКи с ВС             +                 06 ПЭ-ПП  с ВС  ИНДИКАТИВ
  --          // делим на "Вес груза, брутто, т"
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
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'Вес груза'),
	[RuleDictionaryId]		= NULL,
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('Divide'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Делит на колонку "Вес груза, брутто, т" из шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" текущее значение колонки "LoadedRFSize" шаблона СВТ',
	[Order]					= 430

	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'Kauchuk', N'PE-PP')
 ) AS R



 ----------------------------------------------------------------------------
 GO
 ----------------------------------------------------------------------------
 -- 5
 

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
 	-- // 5  - all LoadedRFCurrency - RUB
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
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует константу "RUB" в колонку "LoadedRFCurrency" шаблона СВТ',
	[Order]					= 500
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R


 

 ----------------------------------------------------------------------------
 GO
 ----------------------------------------------------------------------------
 -- 8

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
    --        // 8 - СУГ
    --        // Применяем первое преобразование - копирование из колонки исходного шаблона "ВС со СЗ Реализация"
    --        // в колонку СВТ "EmptyRFSize"

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
	[Description]			= N'Копирует колонку "ВС со СЗ" или "ВС со СЗ Реализация" из шаблона НХТК "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "EmptyRFSize" шаблона СВТ (первое преобразование)',
	[Order]					= 800
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'SUG-1',N'SUG-2',N'SUG-3-1', N'SUG-3-2',N'SHFLU')
 ) AS R


 UNION

     --        // 8 - СУГ
     --       // Применяем второе преобразование - вычитаение из колонки СВТ "EmptyRFSize"
     --       // Словарное значение, зависящее от "S, км"
 SELECT
 [RuleId] = [MatrixId] * 10000 + 100+ ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
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
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" вычитаение из колонки СВТ "EmptyRFSize" словарного значения, зависящего от "S, км" (второе преобразование)',
	[Order]					= 810
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'SUG-1',N'SUG-2',N'SUG-3-1', N'SUG-3-2',N'SHFLU')
 ) AS R

  UNION
 -- // 8 - НБ
  --          // + СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен
   --         // +  СПТ Тобольск ТК + БГС
   --         // Применяем первое преобразование - копирование из колонки исходного шаблона "ВС или Вагонная составляющая"
    --        // в колонку СВТ "EmptyRFSize"
  SELECT
 [RuleId] = [MatrixId] * 10000 + 2000+ ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 8 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'EmptyRFSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'Вагонная составляющая'), -- 
	[RuleDictionaryId]		= NULL,
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Копирует колонку "Вагонная составляющая" или "ВС" из шаблона НХТК "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "EmptyRFSize" шаблона СВТ (первое преобразование)',
	[Order]					= 820
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'HB-1', N'HB-2-1', N'HB-2-2', N'HB-3', N'HB-5', N'HB-7', N'HB-8',N'SPBT-1',N'SPT-1' ) 
 ) AS R


 -- // 8 - НБ
 --           // Применяем второе преобразование - вычитаение из колонки СВТ "EmptyRFSize"
 --           // Словарное значение, зависящее от "S, км"
  UNION
 SELECT
 [RuleId] = [MatrixId] * 10000 + 2200+ ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 8 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'`',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'S, км'), -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'NbDistance'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'Minus'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 1,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" вычитаение из колонки СВТ "EmptyRFSize" словарного значения, зависящего от "S, км" (второе преобразование)',
	[Order]					= 830
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
WHERE t.TemplateEnglishName IN (N'HB-1', N'HB-2-1', N'HB-2-2', N'HB-3', N'HB-5', N'HB-7', N'HB-8' ) 
 ) AS R


  UNION

     --        // - 06 СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен лист Бутадиен
     --       // Применяем второе преобразование - вычитаение из колонки СВТ "EmptyRFSize"
     --       // Словарное значение, зависящее от "S, км"
 SELECT
 [RuleId] = [MatrixId] * 10000 + 2300+ ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 8 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'EmptyRFSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'S, км'), -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'SpbtButadienDistance'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'Minus'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 1,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" вычитаение из колонки СВТ "EmptyRFSize" словарного значения, зависящего от "S, км" (второе преобразование)',
	[Order]					= 840
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'SPBT-1')
	AND ws.[WorksheetId] = 20004--//2022 Бутадиен
 ) AS R

  UNION

     --        // 8 - 06 СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен лист Бутилен
     --       // Применяем второе преобразование - вычитаение из колонки СВТ "EmptyRFSize"
     --       // Словарное значение, зависящее от "S, км"
 SELECT
 [RuleId] = [MatrixId] * 10000 + 2301+ ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 8 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'EmptyRFSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'S, км'), -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'SpbtButilenDistance'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'Minus'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 1,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" вычитаение из колонки СВТ "EmptyRFSize" словарного значения, зависящего от "S, км" (второе преобразование)',
	[Order]					= 850
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
WHERE t.TemplateEnglishName IN (N'SPBT-1')
AND ws.[WorksheetId] =   20005 -- // 22022 Бутилен (Бутен)
 ) AS R

 UNION

     --        // 8 - 06 СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - - Бутен ПБТ +  Пропилен
     --       // Применяем второе преобразование - вычитаение из колонки СВТ "EmptyRFSize"
     --       // Словарное значение, зависящее от "S, км"
 SELECT
 [RuleId] = [MatrixId] * 10000 + 2302+ ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 8 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'EmptyRFSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'S, км'), -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'SpbtPbtPropilenDistance'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'Minus'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 1,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" вычитаение из колонки СВТ "EmptyRFSize" словарного значения, зависящего от "S, км" (второе преобразование)',
	[Order]					= 860
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
WHERE t.TemplateEnglishName IN (N'SPBT-1')
AND ws.[WorksheetId] IN (20001,-- //2022 ПБТ
                        20002, --//2022 Пропилен
                        20003 --//2022  Пропилен экспорт
						)  
 ) AS R


 UNION

     --        // 8- 06 СПТ Тобольск ТК + БГС
     --       // Применяем второе преобразование - вычитаение из колонки СВТ "EmptyRFSize"
     --       // Словарное значение, зависящее от "S, км"
 SELECT
 [RuleId] = [MatrixId] * 10000 + 2400 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 8 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'EmptyRFSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'S, км'), -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'SptTkBgsDistance'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'Minus'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 1,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" вычитаение из колонки СВТ "EmptyRFSize" словарного значения, зависящего от "S, км" (второе преобразование)',
	[Order]					= 870
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
WHERE t.TemplateEnglishName IN (N'SPT-1')
 ) AS R


 UNION
  --        // 8 - ТК РФ + Каучуки + ПЭ П
    --        // первое преобразование - копирование из колонки "Возврат" исходного шаблона  в колонку СВТ "EmptyRFSize"

 SELECT
 [RuleId] = [MatrixId] * 10000 + 3000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 8 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'EmptyRFSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'Возврат'), -- 
	[RuleDictionaryId]		= NULL,
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Копирует колонку "Возврат" или "Возврат по РЖД" из шаблона НХТК "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "EmptyRFSize" шаблона СВТ (первое преобразование)',
	[Order]					= 880
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'TK_RF',	N'Kauchuk', N'PE-PP')
 ) AS R


  --          // 8  - 06 – КАУЧУКи с ВС             +                 06 ПЭ-ПП  с ВС  ИНДИКАТИВ
  --          // второе преобразование  - делим на "Вес груза, брутто, т"
	UNION
 SELECT
 Id = [MatrixId] * 10000 + 3100 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 8 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('Number'), 
	[DestinationColumn]		= N'EmptyRFSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'Вес груза'),
	[RuleDictionaryId]		= NULL,
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('Divide'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Делит на колонку "Вес груза, брутто, т" из шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" текущее значение колонки "EmptyRFSize" шаблона СВТ',
	[Order]					= 890

	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'Kauchuk', N'PE-PP')
 ) AS R



	GO


	 -- 9 - all
 

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
 	-- // 9  - all EmptyRFCurrency - RUB
 SELECT
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 9 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'EmptyRFCurrency',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'RUB'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует константу "RUB" в колонку "EmptyRFCurrency" шаблона СВТ',
	[Order]					= 900
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R

 GO




  -- 12

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
 
     --        // 12 - СУГ

 SELECT
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 12 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'ProvisionTransportSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'S, км'), -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'SugDistance'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 1,
	[Description]			= N'Копирует словарное значение, зависящее от колонки "S, км" из шаблона НХТК "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "ProvisionTransportSize" шаблона СВТ',
	[Order]					= 1000
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'SUG-1',N'SUG-2',N'SUG-3-1', N'SUG-3-2',N'SHFLU')
 ) AS R


 -- // 12 - НБ

  UNION
 SELECT
 [RuleId] = [MatrixId] * 10000 + 1000+ ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 12 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'ProvisionTransportSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'S, км'), -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'NbDistance'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 1,
	[Description]			= N'Копирует словарное значение, зависящее от колонки "S, км" из шаблона НХТК "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "ProvisionTransportSize" шаблона СВТ',
	[Order]					= 1100
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
WHERE t.TemplateEnglishName IN (N'HB-1', N'HB-2-1', N'HB-2-2', N'HB-3', N'HB-5', N'HB-7', N'HB-8' ) 
 ) AS R


    --   // 12 - 06 СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен лист Бутадиен

  UNION
 SELECT
 [RuleId] = [MatrixId] * 10000 + 2000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 12 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'ProvisionTransportSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'S, км'), -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'SpbtButadienDistance'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 1,
	[Description]			= N'Копирует словарное значение, зависящее от колонки "S, км" из шаблона НХТК "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "ProvisionTransportSize" шаблона СВТ',
	[Order]					= 1200
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'SPBT-1')
	AND ws.[WorksheetId] = 20004--//2022 Бутадиен 
 ) AS R

    --   // 12 - 06 СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен лист Бутилен
  UNION
 SELECT
 [RuleId] = [MatrixId] * 10000 + 2001 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 12 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'ProvisionTransportSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'S, км'), -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'SpbtButilenDistance'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 1,
	[Description]			= N'Копирует словарное значение, зависящее от колонки "S, км" из шаблона НХТК "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "ProvisionTransportSize" шаблона СВТ',
	[Order]					= 1201
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'SPBT-1')
	AND ws.[WorksheetId] =   20005 -- // 22022 Бутилен (Бутен)
 ) AS R


     --   // 12 - 06 СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен лист  Бутен ПБТ +  Пропилен
  UNION
 SELECT
 [RuleId] = [MatrixId] * 10000 + 2002 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 12 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'ProvisionTransportSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'S, км'), -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'SpbtPbtPropilenDistance'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 1,
	[Description]			= N'Копирует словарное значение, зависящее от колонки "S, км" из шаблона НХТК "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "ProvisionTransportSize" шаблона СВТ',
	[Order]					= 1202
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'SPBT-1')
	AND ws.[WorksheetId] IN (20001,-- //2022 ПБТ
                        20002, --//2022 Пропилен
                        20003 --//2022  Пропилен экспорт
						) 
 ) AS R

 -- 12 -  СПТ Тобольск ТК + БГС
  UNION
 SELECT
 [RuleId] = [MatrixId] * 10000 + 2100 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 12 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'ProvisionTransportSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'S, км'), -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'SptTkBgsDistance'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 1,
	[Description]			= N'Копирует словарное значение, зависящее от колонки "S, км" из шаблона НХТК "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "ProvisionTransportSize" шаблона СВТ',
	[Order]					= 1202
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'SPT-1')
 ) AS R

     --     // 12 - ТК РФ
      --      // +  КАУЧУКи с ВС             +                 06 ПЭ-ПП  с ВС  ИНДИКАТИВ
      --      // Применяем первое преобразование - копирование из колонки исходного шаблона "Услуга" или  "Вагонная составляющая."
      --      // в колонку СВТ "ProvisionTransportSize"


UNION
	   SELECT
 [RuleId] = [MatrixId] * 10000 + 3000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 12 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'ProvisionTransportSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'Вагонная составляющая'), -- 
	[RuleDictionaryId]		= NULL,
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Копирует колонку "Услуга" или "Вагонная составляющая." из шаблона НХТК "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "ProvisionTransportSize" шаблона СВТ (первое преобразование)',
	[Order]					= 1300
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'TK_RF',N'Kauchuk',N'PE-PP')
 ) AS R


 UNION

     --       // 12 - ТК РФ
     --       // Применяем второе преобразование - добавляем к  колонке СВТ "ProvisionTransportSize"
     --       // значение из колонки НХТК  "Рентабельность"
 SELECT
 [RuleId] = [MatrixId] * 10000 + 3100+ ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
      SELECT
	[MatrixId]				= 12 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'ProvisionTransportSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'Рентабельность'), -- 
	[RuleDictionaryId]		= NULL,
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'Plus'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Добавляет колонку "Рентабельность" из шаблона НХТК "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "ProvisionTransportSize" шаблона СВТ (второе преобразование)',
	[Order]					= 1310
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'TK_RF')
 ) AS R



    --// 12  - 06 – КАУЧУКи с ВС             +                 06 ПЭ-ПП  с ВС  ИНДИКАТИВ
            --// второе преобразование  - делим на "Вес груза, брутто, т"
 UNION

 SELECT
 [RuleId] = [MatrixId] * 10000 + 3200+ ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
      SELECT
	[MatrixId]				= 12 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'ProvisionTransportSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'Вес груза'), -- 
	[RuleDictionaryId]		= NULL,
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'Divide'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Делит на колонку "Вес груза, брутто, т" из шаблона НХТК "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" колонку "ProvisionTransportSize" шаблона СВТ (второе преобразование)',
	[Order]					= 1320
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'Kauchuk',N'PE-PP')
 ) AS R

 GO


 	 -- 13 - all
 

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
 	-- // 13  - all ProvisionTransportCurrency - RUB
 SELECT
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 13 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'ProvisionTransportCurrency',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'RUB'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует константу "RUB" в колонку "ProvisionTransportCurrency" шаблона СВТ',
	[Order]					= 1400
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R

 GO


  -- 16 - all
 


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
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 16 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'TEFromSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ГО отправления'), -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ZeroToEmpty'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Копирует колонку "ГО отправления" или "ТЭ отправления" из шаблона НХТК "'+t.[TemplateRussianName] + N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "TEFromSize" шаблона СВТ',
	[Order]					= 1600
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R


  UNION

 SELECT
 [RuleId] = [MatrixId] * 10000 + 1000+ ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
      SELECT
	[MatrixId]				= 16 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'TEFromSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'Вес груза'), -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ZeroToEmpty'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'Divide'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Делит на колонку "Вес груза, брутто, т" из шаблона НХТК "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" колонку "TEFromSize" шаблона СВТ (второе преобразование)',
	[Order]					= 1610
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'Kauchuk',N'PE-PP')
 ) AS R


  GO



 	 -- 17 - all
 

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
 	-- // 17  - all TEFromCurrency - RUB
 SELECT
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 17 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'TEFromCurrency',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'RUB'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует константу "RUB" в колонку "TEFromCurrency" шаблона СВТ',
	[Order]					= 1700
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R

 UNION
      --     // 17  - all - затирает пустой строкой те значения в колонке валюты, для которых число в
      --      // колонке SourceEntities равно нулю. Это происходит потому что для нулевого числа есть словарное значение ""
      --      // и при применении оператора IsNull к значению  "" и "RUB" берется ""
      --      // Для ненулевого числа нет словарных значений, и поэтому, по логике обработке RuleKind.SourceColumnCopyDictionaryOnly
      --      // при отсутсвии словарных значений берется NULL, и резултат применнения
      --      // оператора IsNull к значению  NULL и "RUB" берется "RUB"

 SELECT
 [RuleId] = [MatrixId] * 10000 + 1000+ ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 17 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopyDictionaryOnly'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'TEFromCurrency',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ГО отправления'), -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ZeroToEmpty'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'IsNull'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" затирает пустой строкой те значения в колонке валюты "TEFromCurrency" шаблона СВТ, для которых число в "ГО отправления" или "ТЭ отправления" равно нулю',
	[Order]					= 1710
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R



 GO

  -- 18 - all
 


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
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 18 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'PNPFromSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ПНП отправления'), -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ZeroToEmpty'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Копирует колонку "ПНП отправления" из шаблона НХТК "'+t.[TemplateRussianName] + N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "PNPFromSize" шаблона СВТ',
	[Order]					= 1800
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R


  UNION

 SELECT
 [RuleId] = [MatrixId] * 10000 + 1000+ ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
      SELECT
	[MatrixId]				= 18 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'PNPFromSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'Вес груза'), -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ZeroToEmpty'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'Divide'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Делит на колонку "Вес груза, брутто, т" из шаблона НХТК "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" колонку "PNPFromSize" шаблона СВТ (второе преобразование)',
	[Order]					= 1810
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'Kauchuk',N'PE-PP')
 ) AS R


  GO


   -- 19 - all
 

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
 	-- // 19  - all PNPFromCurrency - RUB
 SELECT
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 19 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'PNPFromCurrency',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'RUB'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует константу "RUB" в колонку "PNPFromCurrency" шаблона СВТ',
	[Order]					= 1900
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R

 UNION
      --     // 19  - all - затирает пустой строкой те значения в колонке валюты, для которых число в
      --      // колонке SourceEntities равно нулю. Это происходит потому что для нулевого числа есть словарное значение ""
      --      // и при применении оператора IsNull к значению  "" и "RUB" берется ""
      --      // Для ненулевого числа нет словарных значений, и поэтому, по логике обработке RuleKind.SourceColumnCopyDictionaryOnly
      --      // при отсутсвии словарных значений берется NULL, и резултат применнения
      --      // оператора IsNull к значению  NULL и "RUB" берется "RUB"

 SELECT
 [RuleId] = [MatrixId] * 10000 + 1000+ ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 19 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopyDictionaryOnly'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'PNPFromCurrency',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ПНП отправления'), -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ZeroToEmpty'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'IsNull'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" затирает пустой строкой те значения в колонке валюты "PNPFromCurrency" шаблона СВТ, для которых число в "ПНП отправления" равно нулю',
	[Order]					= 1910
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R



 GO

  -- 20 - all
 


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
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 20 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'TEToSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ГО назначения'), -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ZeroToEmpty'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Копирует колонку "ГО назначения" или "ТЭ назначения" из шаблона НХТК "'+t.[TemplateRussianName] + N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "TEToSize" шаблона СВТ',
	[Order]					= 2000
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R


  UNION

 SELECT
 [RuleId] = [MatrixId] * 10000 + 1000+ ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
      SELECT
	[MatrixId]				= 20 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'TEToSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'Вес груза'), -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ZeroToEmpty'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'Divide'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Делит на колонку "Вес груза, брутто, т" из шаблона НХТК "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" колонку "TEToSize" шаблона СВТ (второе преобразование)',
	[Order]					= 2010
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'Kauchuk',N'PE-PP')
 ) AS R


  GO

  	-- // 21  - all TEToCurrency - RUB


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
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 21 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'TEToCurrency',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'RUB'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует константу "RUB" в колонку "TEToCurrency" шаблона СВТ',
	[Order]					= 2100
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R

 UNION
      --     // 21  - all - затирает пустой строкой те значения в колонке валюты, для которых число в
      --      // колонке SourceEntities равно нулю. Это происходит потому что для нулевого числа есть словарное значение ""
      --      // и при применении оператора IsNull к значению  "" и "RUB" берется ""
      --      // Для ненулевого числа нет словарных значений, и поэтому, по логике обработке RuleKind.SourceColumnCopyDictionaryOnly
      --      // при отсутсвии словарных значений берется NULL, и резултат применнения
      --      // оператора IsNull к значению  NULL и "RUB" берется "RUB"

 SELECT
 [RuleId] = [MatrixId] * 10000 + 1000+ ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 21 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopyDictionaryOnly'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'TEToCurrency',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ГО назначения'), -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ZeroToEmpty'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'IsNull'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" затирает пустой строкой те значения в колонке валюты "TEToCurrency" шаблона СВТ, для которых число в "ГО назначения" или "ТЭ назначения" равно нулю',
	[Order]					= 2110
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R



 GO

   -- 22 - all
 


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
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 22 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'PNPToSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ПНП назначения'), -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ZeroToEmpty'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Копирует колонку "ПНП назначения" из шаблона НХТК "'+t.[TemplateRussianName] + N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "PNPToSize" шаблона СВТ',
	[Order]					= 2200
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R


  UNION

 SELECT
 [RuleId] = [MatrixId] * 10000 + 1000+ ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
      SELECT
	[MatrixId]				= 22 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number'), 
	[DestinationColumn]		= N'PNPToSize',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'Вес груза'), -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ZeroToEmpty'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'Divide'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Делит на колонку "Вес груза, брутто, т" из шаблона НХТК "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" колонку "PNPToSize" шаблона СВТ (второе преобразование)',
	[Order]					= 2210
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'Kauchuk',N'PE-PP')
 ) AS R


  GO

  
   -- 23 - all
 

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
 	-- // 23  - all PNPToCurrency - RUB
 SELECT
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 23 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'PNPToCurrency',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'RUB'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует константу "RUB" в колонку "PNPToCurrency" шаблона СВТ',
	[Order]					= 2300
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R

 UNION
      --     // 23  - all - затирает пустой строкой те значения в колонке валюты, для которых число в
      --      // колонке SourceEntities равно нулю. Это происходит потому что для нулевого числа есть словарное значение ""
      --      // и при применении оператора IsNull к значению  "" и "RUB" берется ""
      --      // Для ненулевого числа нет словарных значений, и поэтому, по логике обработке RuleKind.SourceColumnCopyDictionaryOnly
      --      // при отсутсвии словарных значений берется NULL, и резултат применнения
      --      // оператора IsNull к значению  NULL и "RUB" берется "RUB"

 SELECT
 [RuleId] = [MatrixId] * 10000 + 1000+ ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 23 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopyDictionaryOnly'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'PNPToCurrency',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ПНП назначения'), -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ZeroToEmpty'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'IsNull'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" затирает пустой строкой те значения в колонке валюты "PNPToCurrency" шаблона СВТ, для которых число в "ПНП назначения" равно нулю',
	[Order]					= 2310
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R



 GO


 ------------------------------------------ 44
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

	-- // 44  - all
 SELECT
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 44 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'RateCalcType',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'RateCalcTypeTonne'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает код типа расчетов "За тонну" в  "RateCalcType" шаблона СВТ',
	[Order]					= 4400
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R


 GO

 ------------------------------------------ 45
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

	-- // 45  - all
 SELECT
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 45 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'RateType',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'RateTypeIndicative'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает код типа расчетов "Индикативная" в  "RateType" шаблона СВТ',
	[Order]					= 4500
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R

 GO


  GO
 ----------------------------------------------------------------------------
 -- 47

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
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 47 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'NodeFrom',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'Станция отправления'), -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'NodesDictionary'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 1,
	[Description]			= N'Копирует колонку "Станция отправления" из шаблона НХТК "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "NodeFrom" шаблона СВТ',
	[Order]					= 4700
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R

 GO
 ----------------------------------------------------------------------------

 GO
 ----------------------------------------------------------------------------
 -- 48

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
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 48 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'NodeTo',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'Станция назначения'), -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'NodesDictionary'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 1,
	[Description]			= N'Копирует колонку "Станция назначения" из шаблона НХТК "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "NodeTo" шаблона СВТ',
	[Order]					= 4800
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R

 GO
 ----------------------------------------------------------------------------



  ------------------------------------------ 49
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

	-- // 49  - all
 SELECT
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 49 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'TransportKind',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'TransportKindRail'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает код типа расчетов "Rail" в  "TransportKind" шаблона СВТ',
	[Order]					= 4900
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R

 GO


   ------------------------------------------ 50
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

	-- // 50-  TransportType - СУГ + НБ
 SELECT
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 50 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'TransportType',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'TransportTypeRail_VC_other'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает код типа расчетов "Rail_VC_other" в  "TransportType" шаблона СВТ',
	[Order]					= 5000
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'SUG-1',N'SUG-2',N'SUG-3-1', N'SUG-3-2',N'SHFLU',
									N'HB-1', N'HB-2-1', N'HB-2-2', N'HB-3', N'HB-5', N'HB-7', N'HB-8')
 ) AS R


 UNION

 	-- // 50-  TransportType - СПТ Тобольск ТК + БГС       СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен
 SELECT
 [RuleId] = [MatrixId] * 10000 + 1000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 50 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'TransportType',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'TransportTypeRail_TK_20'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает код типа расчетов "Rail_TK_20" в  "TransportType" шаблона СВТ',
	[Order]					= 5010
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'TK_RF', N'SPBT-1', N'SPT-1')
 ) AS R

 
 UNION

 

 	-- // 50-  TransportType КАУЧУКи  +  ПЭ-ПП  с ВС ИНДИКАТИВ
 SELECT
 [RuleId] = [MatrixId] * 10000 + 2000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 50 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'TransportType',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'TransportType_Rail_KV'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает код типа расчетов "Rail_KV" в  "TransportType" шаблона СВТ',
	[Order]					= 5020
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'Kauchuk', N'PE-PP')
 ) AS R


 GO


  	-- // 51-  SUG-1
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
 [RuleId] = [MatrixId] * 10000 + 100 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 51 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'EffectiveLoadOfTransportType',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'EffectiveLoadOfTransportType_SUG-1'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает константу в "EffectiveLoadOfTransportType" шаблона СВТ',
	[Order]					= 5110
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'SUG-1')
 ) AS R


 GO

 	-- // 51-  SUG-2
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
 [RuleId] = [MatrixId] * 10000 + 200 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 51 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'EffectiveLoadOfTransportType',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'EffectiveLoadOfTransportType_SUG-2'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает константу в "EffectiveLoadOfTransportType" шаблона СВТ',
	[Order]					= 5120
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'SUG-2')
 ) AS R


 GO

 
 	-- // 51-  СУГ-3 - бутадиен 
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
 [RuleId] = [MatrixId] * 10000 + 300 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 51 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'EffectiveLoadOfTransportType',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'EffectiveLoadOfTransportType_SUG-3-1'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает константу в "EffectiveLoadOfTransportType" шаблона СВТ',
	[Order]					= 5130
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'SUG-3-1')
 ) AS R


 GO
 	-- // 51-  СУГ-3 - пропилен, (изо-)бутилен, изопрен,БДФ 
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
 [RuleId] = [MatrixId] * 10000 + 350 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 51 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'EffectiveLoadOfTransportType',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'EffectiveLoadOfTransportType_SUG-3-2'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает константу в "EffectiveLoadOfTransportType" шаблона СВТ',
	[Order]					= 5140
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'SUG-3-2')
 ) AS R



 GO

 	 --         // 51  - 06 – ШФЛУ + ТК РФ +
     --      // СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен
      --     //+ СПТ Тобольск ТК + БГС
      --     // + КАУЧУКи с ВС
     --      //+ ПЭ-ПП с ВС ИНДИКАТИВ
 
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
 [RuleId] = [MatrixId] * 10000 + 400 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 51 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'EffectiveLoadOfTransportType',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'Загрузка'), -- 
	[RuleDictionaryId]		= NULL,
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Копирует колонку "Загрузка" или "Расчетный вес, т" или "Вес груза, брутто, т" из шаблона НХТК "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "EffectiveLoadOfTransportType" шаблона СВТ',
	[Order]					= 5160
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'SHFLU', N'TK_RF', N'SPBT-1', N'SPT-1', N'Kauchuk', N'PE-PP' ) 
 ) AS R

 	-- // 51  – НБ-1 - Бензол эфир спирт и т.д. с 01.06.2022
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
 [RuleId] = [MatrixId] * 10000 + 1000 + 100 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 51 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'EffectiveLoadOfTransportType',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'EffectiveLoadOfTransportType_HB-1'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает константу в "EffectiveLoadOfTransportType" шаблона СВТ',
	[Order]					= 5150
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'HB-1')
 ) AS R


 GO

 	-- // 51  НБ-2 - ЖПП СПТ и т.д
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
 [RuleId] = [MatrixId] * 10000 + 1000 + 200 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 51 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'EffectiveLoadOfTransportType',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'EffectiveLoadOfTransportType_HB-2-1'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает константу в "EffectiveLoadOfTransportType" шаблона СВТ',
	[Order]					= 5160
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'HB-2-1')
 ) AS R


 GO
 GO

 	-- // 51  НБ-2 - химия
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
 [RuleId] = [MatrixId] * 10000 + 1000 + 250 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 51 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'EffectiveLoadOfTransportType',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'EffectiveLoadOfTransportType_HB-2-2'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает константу в "EffectiveLoadOfTransportType" шаблона СВТ',
	[Order]					= 5170
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'HB-2-2')
 ) AS R

 GO

 	-- // 51  НБ-3 - БГС
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
 [RuleId] = [MatrixId] * 10000 + 1000 + 300 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 51 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'EffectiveLoadOfTransportType',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'EffectiveLoadOfTransportType_HB-3'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает константу в "EffectiveLoadOfTransportType" шаблона СВТ',
	[Order]					= 5180
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'HB-3')
 ) AS R

 
 GO

 	-- // 51  НБ-5 Натрия гидроксид, каустики
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
 [RuleId] = [MatrixId] * 10000 + 1000 + 500 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 51 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'EffectiveLoadOfTransportType',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'EffectiveLoadOfTransportType_HB-5'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает константу в "EffectiveLoadOfTransportType" шаблона СВТ',
	[Order]					= 5181
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'HB-5')
 ) AS R

 GO

 	-- // 51  НБ-7
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
 [RuleId] = [MatrixId] * 10000 + 1000 + 700 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 51 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'EffectiveLoadOfTransportType',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'EffectiveLoadOfTransportType_HB-7'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает константу в "EffectiveLoadOfTransportType" шаблона СВТ',
	[Order]					= 5182
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'HB-7')
 ) AS R

GO

 	-- // 51  НБ-8
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
 [RuleId] = [MatrixId] * 10000 + 1000 + 800 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 51 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'EffectiveLoadOfTransportType',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'EffectiveLoadOfTransportType_HB-8'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает константу в "EffectiveLoadOfTransportType" шаблона СВТ',
	[Order]					= 5183
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'HB-8')
 ) AS R

 GO

 --- 53  СУГ-1

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
 	-- // 53  СУГ-1- "Ставки"
SELECT
 Id = [MatrixId] * 10000 + 100 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_SUG-1-01'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5300
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE ws.WorksheetId = 1001 -- "Ставки"
 ) AS R

 -- СУГ-1 - "Ставки без охраны"
 UNION 
 SELECT
 Id = [MatrixId] * 10000 + 110 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_SUG-1-02'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5301
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE ws.WorksheetId =  1002 --// "Ставки без охраны"
 ) AS R

 -- СУГ-1 - "Спецставка"
 UNION 
 SELECT
 Id = [MatrixId] * 10000 + 120 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_SUG-1-03'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5302
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE ws.WorksheetId =  1003 --// "Спецставка"
 ) AS R

 GO



GO

-- СУГ-2 - фракция пент изопент

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
 	-- // 53  СУГ-2
SELECT
 Id = [MatrixId] * 10000 + 200 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_SUG-2-01'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5321
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'SUG-2')

 ) AS R


 GO

--  СУГ-3 - бутадиен

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
 	-- // 53  СУГ-3 - бутадиен
SELECT
 Id = [MatrixId] * 10000 + 300 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_SUG-3-11'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5332
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'SUG-3-1')

 ) AS R


  GO

--  СУГ-3 - 2

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
 	-- // 53   СУГ-3 - пропилен, (изо-)бутилен, изопрен,БДФ  -- "Пропилен, изобутилен "
SELECT
 Id = [MatrixId] * 10000 + 350 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_SUG-3-21'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5333
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE ws.WorksheetId =  3201 --// "Пропилен, изобутилен "

 ) AS R

 UNION
  --СУГ-3 - пропилен, (изо-)бутилен, изопрен,БДФ --  "изобутилен до 720 км со скидкой"
 SELECT
 Id = [MatrixId] * 10000 + 360 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_SUG-3-22'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5334
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE ws.WorksheetId =   3202 --// "изобутилен до 720 км со скидкой"

 ) AS R

 UNION
  --СУГ-3 - пропилен, (изо-)бутилен, изопрен,БДФ --  "Бутилен, изопрен, БДФ "
 SELECT
 Id = [MatrixId] * 10000 + 370 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_SUG-3-23'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5335
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE ws.WorksheetId =    3203-- // "Бутилен, изопрен, БДФ "

 ) AS R


 GO

 
--  06 – ШФЛУ

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
 	-- // 53   06 – ШФЛУ
SELECT
 Id = [MatrixId] * 10000 + 400 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_SHFLU'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5340
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'SHFLU')

 ) AS R

 GO

 
--  НБ-1 - Бензол эфир спирт и т.д. с 01.06.2022 

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
 	-- // НБ-1 - Бензол эфир спирт и т.д. с 01.06.2022  - Ставки
SELECT
 Id = [MatrixId] * 10000 + 510 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_HB-11'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5350
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE ws.WorksheetId =     6001 --//Ставки

 ) AS R

 UNION

 	-- // НБ-1 - Бензол эфир спирт и т.д. с 01.06.2022  - Ставки со скидкой на 720 км
SELECT
 Id = [MatrixId] * 10000 + 520 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_HB-12'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5351
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
WHERE ws.WorksheetId =       6002 --// Ставки со скидкой на 720 км

 ) AS R


  UNION

 	-- // НБ-1 - Бензол эфир спирт и т.д. с 01.06.2022  -  МТБЭ Сургут
SELECT
 Id = [MatrixId] * 10000 + 530 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_HB-13'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5352
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
WHERE ws.WorksheetId =        6003 --//МТБЭ Сургут

 ) AS R



 UNION

 	-- // НБ-1 - Бензол эфир спирт и т.д. с 01.06.2022  -  МТБЭ Сахалин МАЙ 2022
SELECT
 Id = [MatrixId] * 10000 + 540 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_HB-14'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5353
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE ws.WorksheetId =        6004 --//МТБЭ Сахалин МАЙ 2022

 ) AS R



  UNION

 	-- // НБ-1 - Бензол эфир спирт и т.д. с 01.06.2022  -  Стирол
SELECT
 Id = [MatrixId] * 10000 + 550 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_HB-15'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5354
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE ws.WorksheetId =         6005-- //Стирол

 ) AS R


  UNION

 	-- // НБ-1 - Бензол эфир спирт и т.д. с 01.06.2022  -  Гликоли
SELECT
 Id = [MatrixId] * 10000 + 560 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_HB-16'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5355
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE ws.WorksheetId IN (6006, 6007) -- Гликоли  + Гликоли КЛН  МАЙ

 ) AS R


 GO

 --  НБ-2 - ЖПП СПТ и т.д 


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
 	-- // НБ-2 - ЖПП СПТ и т.д  -- ставки 2022
SELECT
 Id = [MatrixId] * 10000 + 610 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_HB-2-1-1'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5360
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE ws.WorksheetId =    7101 -- //ставки 2022

 ) AS R

 UNION
 SELECT
 Id = [MatrixId] * 10000 + 611 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_HB-2-1-2'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5361
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE ws.WorksheetId =    7102 --//Сахалин 2022 ИНДИКАТИВ МАЙ!!!

 ) AS R

 GO


 --- НБ-2 - химия

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
 	-- // НБ-2 - химия -- ставки 2022
SELECT
 Id = [MatrixId] * 10000 + 620 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_HB-2-2-1'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5370
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE ws.WorksheetId =     7201-- //ставки 2022

 ) AS R

 UNION

 -- // НБ-2 - химия -- Ставки со скидкой на расст.  ап
SELECT
 Id = [MatrixId] * 10000 + 621 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_HB-2-2-2'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5371
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE ws.WorksheetId =      7202-- //Ставки со скидкой на расст.  ап

 ) AS R

 GO

 
 --- НБ-3 - БГС

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
 	-- // НБ-3 - БГС
SELECT
 Id = [MatrixId] * 10000 + 700 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_HB-3'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5373
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'HB-3')

 ) AS R

 GO



 
 
 --- НБ-5 - Натрия гидроксид, каустики

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
 	-- // НБ-5 - Натрия гидроксид, каустики
SELECT
 Id = [MatrixId] * 10000 + 800 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_HB-5'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5375
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'HB-5')

 ) AS R

 GO


 

 
 
 --- НБ-7

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
 	-- // НБ-7
SELECT
 Id = [MatrixId] * 10000 + 900 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_HB-7'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5377
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'HB-7')

 ) AS R

 GO



 
 
 --- НБ-8

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
 	-- // НБ-8
SELECT
 Id = [MatrixId] * 10000 + 1000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_HB-8'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5378
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'HB-8')

 ) AS R

 GO

 --  ТК РФ

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
 	-- // ТК РФ
SELECT
 Id = [MatrixId] * 10000 + 1100 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SourceColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			=  [nkhtk].[fnRuleEntityByName](N'Груз'),
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ProductNames_TK_RF'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 1,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5380
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'TK_RF')

 ) AS R

 GO

 --- 53 - СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен 
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
 	-- // 53 - СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен ---------  ПБТ
SELECT
 Id = [MatrixId] * 10000 + 1200 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_SpbtPbt'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5382
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE ws.WorksheetId =      20001-- //ПБТ

 ) AS R


 UNION
  	-- // 53 - СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен ---------  Пропилен
SELECT
 Id = [MatrixId] * 10000 + 1210 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_SpbtPropilen'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5383
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE ws.WorksheetId      IN ( 20002, 20003) -- //Пропилен

 ) AS R

  UNION
  	-- // 53 - СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен ---------  Бутадиен
SELECT
 Id = [MatrixId] * 10000 + 1220 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_SpbtButadien'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5384
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE ws.WorksheetId      IN ( 20004) -- //Бутадиен

 ) AS R

  UNION
  	-- // 53 - СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен ---------  Бутилен
SELECT
 Id = [MatrixId] * 10000 + 1230 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_SpbtButilen'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5385
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE ws.WorksheetId      IN ( 20005) -- //Бутилен

 ) AS R

 GO





--53 - СПТ Тобольск ТК + БГС
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
--53 - СПТ Тобольск ТК + БГС
SELECT
 Id = [MatrixId] * 10000 + 1300 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_SptTkBgs'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5387
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'SPT-1')

 ) AS R

 GO
 

--53 - КАУЧУКи
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
--53 - КАУЧУКи
SELECT
 Id = [MatrixId] * 10000 + 1400 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_Kauchuk'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5390
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'Kauchuk')

 ) AS R


 
 GO

--53 - ПЭ-ПП
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
--53 - ПЭ-ПП
SELECT
 Id = [MatrixId] * 10000 + 1500 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 53 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName]('SheetMultiplier'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName]('General'), 
	[DestinationColumn]		= N'Product',
	[RuleEntityId]			= NULL,
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'Products_PE-PP'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" выставляет словарное значение "Product" в шаблоне СВТ',
	[Order]					= 5392
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
	WHERE t.TemplateEnglishName IN (N'PE-PP')

 ) AS R

 GO



 

 -- 52
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

	-- // 52  - all
 SELECT
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 52 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'DestinationColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'ProductGroup',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'Product'), -- 
	[RuleDictionaryId]		=  [nkhtk].[fnRuleDictionaryByName](N'ProductGroup'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 1,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" заполняет колонку "ProductGroup" шаблона СВТ в зависимости от ранее заполненной колонки "Product". Применять можно только после правила продуктов!',
	[Order]					= 15200
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R

  GO

   -- 3 ETSNGCode
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

	-- // 3  - all
 SELECT
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 3 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'DestinationColumnCopy'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'ETSNGCode',
	[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'Product'), -- 
	[RuleDictionaryId]		=  [nkhtk].[fnRuleDictionaryByName](N'ETSNGCode'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 1,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" заполняет колонку "ETSNGCode" шаблона СВТ в зависимости от ранее заполненной колонки "Product". Применять можно только после правила продуктов!',
	[Order]					= 10300
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R

  GO
	



	
 ------------------------------------------ 32
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

	-- // 32  - all
 SELECT
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 32 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetParameter'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'DateTime'), 
	[DestinationColumn]		= N'CurrencyRateMonth',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'CurrencyRateMonth'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает текущую дату в колонку "CurrencyRateMonth" шаблона СВТ',
	[Order]					= 13200
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R


 GO

  ------------------------------------------ 54
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
 
	-- // 54  - all
 SELECT
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 54 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetParameter'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'DateTime'), 
	[DestinationColumn]		= N'StartDate',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'StartDate'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает полученную от пользователя дату в колонку "StartDate" шаблона СВТ',
	[Order]					= 15400
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R


 GO

 
  ------------------------------------------ 55
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
 
	-- // 55  - all
 SELECT
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 55 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetParameter'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'DateTime'), 
	[DestinationColumn]		= N'EndDate',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'EndDate'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+N'" для вкладки "' + ws.[WorksheetName] + N'" записывает полученную от пользователя дату в колонку "EndDate" шаблона СВТ',
	[Order]					= 15500
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R


 GO


 -- 58
 

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
 	-- // 59  - all GeneralCurrency - RUB
 SELECT
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 58 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'GeneralCurrency',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'RUB'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует константу "RUB" в колонку "GeneralCurrency" шаблона СВТ',
	[Order]					= 5800
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R


 

 ----------------------------------------------------------------------------

 GO


 

 -- 59
 

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
 	-- // 59  - all stg_Operation - 1
 SELECT
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 59 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'stg_Operation',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'stg_Operation_1'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует константу "1" в колонку "stg_Operation" шаблона СВТ',
	[Order]					= 5900
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R


 

 ----------------------------------------------------------------------------

 GO


 
 -- ???
 

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
 	-- // ???  - all ActualRate - 0
 SELECT
 [RuleId] = [MatrixId] * 10000 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
 R.*

 from
 (
    SELECT
	[MatrixId]				= 100 , 
	[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SheetConstant'),
	[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
	[DestinationColumn]		= N'ActualRate',
	[RuleEntityId]			= NULL, -- 
	[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ActualRate_0'),
	[WorksheetId]			= ws.WorksheetId,	
	[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
	[Mandatory]				= 1,
	[TreatMissingDictionaryValueAsError] = 0,
	[Description]			= N'Для шаблона НХТК "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Копирует константу "1" в колонку "ActualRate" шаблона СВТ',
	[Order]					= 10000
	FROM [nkhtk].[Worksheet] ws
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
 ) AS R


 

 ----------------------------------------------------------------------------

 GO
