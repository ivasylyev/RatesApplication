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
	-- // 17  - TotalCostTransportTmp -- Промежуточный расчет средневзвеса - первое преобразование ПОСЛЕ TotalCostTransport
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
		[MatrixId]				= 117 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'DestinationColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'TotalCostTransportTmp',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море TotalCostTransport'), -- 
		[RuleDictionaryId]		= NULL, -- словаря нет, простое копирование
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, -- а раз словаря нет, то и трактовать отсутствие словарного значения как ошибку не нужно
		[Description]			= N'Для шаблона спецставок заполняет колонку "TotalCostTransportTmp" шаблона СВТ в зависимости от ранее заполненной колонки "TotalCostTransport"  шаблона СВТ. Применять можно только после правила "Ставка за т (эталон)!" (TotalCostTonStandard)',
		[Order]					= 21700  -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  ПОСЛЕ TotalCostTransport  
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-Special')
	 ) AS R





	 
	 	--------------------------------------------------------------------------------------------
-- // 17  - TotalCostTransportTmp -- Промежуточный расчет средневзвеса - второе преобразование ПОСЛЕ TotalCostTransport
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
	 [RuleId] = [MatrixId] * 1000 + 20 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 117 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'TotalCostTransportTmp',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море Номинация СВТ'), -- 
		[RuleDictionaryId]		= NULL, -- словаря нет, простое копирование
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'Multiply'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, -- а раз словаря нет, то и трактовать отсутствие словарного значения как ошибку не нужно
		[Description]			= N'Умножает на колонку "Номинация СВТ" из шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" текущее значение колонки "TotalCostTransportTmp" шаблона СВТ',
		[Order]					= 21702  -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  ПОСЛЕ TotalCostTransport  и ПОСЛЕ первого преобразования 
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-Special')
	 ) AS R





	 
	--------------------------------------------------------------------------------------------
	--  TotalCostTransportTmp -- 
	--------------------------------------------------------------------------------------------

	DECLARE @RuleDictionaryId INT = 11705 -- "_"

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId					AS [RuleDictionaryId],
			N'ММ Суша-Море 100'					AS [RuleDictionaryItemName],
			N'Словарь с константой "100"'		AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL				AS [SourceValue],  
			N'100'				AS [DestinationValue]





	 
	 	--------------------------------------------------------------------------------------------
-- // 17  - TotalCostTransportTmp -- Промежуточный расчет средневзвеса - третье преобразование ПОСЛЕ TotalCostTransport
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
	 [RuleId] = [MatrixId] * 1000 + 30 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 117 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'DestinationSheetConstant'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'TotalCostTransportTmp',
		[RuleEntityId]			= NULL, -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море 100'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'Divide'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, 
		[Description]			= N'Делит на 100 для шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" текущее значение колонки "TotalCostTransportTmp" шаблона СВТ',
		[Order]					= 21704  -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  ПОСЛЕ TotalCostTransport  и ПОСЛЕ первого преобразования 
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