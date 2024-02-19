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
		[MatrixId]				= 99 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceSheetDeleteRows'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'TotalCostTransport',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море Стоимость морской перевозки, включая экспедирование в порту РФ, USD/ктк (Цена) (Цена)'), -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море 9'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, -- наличие в словаре является критерием для удаления. отсутсвие - критерием, чтобы строку оставить. и трактовать отсутствие словарного значения как ошибку не нужно
		[Description]			= N'Удаляет строки в исходном шаблоне, если их Стоимость  морской перевозки содержит 0, пустоту, 99, 999, 9999 и тд',
		[Order]					= 99
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea', N'MM-Land-Sea-Special')
	 ) AS R

	 UNION

	 SELECT
	 [RuleId] = [MatrixId] * 1000  + 10 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 99 , 
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceSheetDeleteRows'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'TotalCostTransport',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море Стоимость  ЖД перевозки по территории РФ включая все расходы  Перевозчика.в USD/ктк (Цена) (Цена)'), -- 
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море 9'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, -- наличие в словаре является критерием для удаления. отсутсвие - критерием, чтобы строку оставить. и трактовать отсутствие словарного значения как ошибку не нужно
		[Description]			= N'Удаляет строки в исходном шаблоне, если их Стоимость  ЖД перевозки содержит 0, пустоту, 99, 999, 9999 и тд',
		[Order]					= 100
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea', N'MM-Land-Sea-Special')
	 ) AS R

	
	--------------------------------------------------------------------------------------------
	-- // ??  - Code -- fake rule -  Служит только для того, чтобы конвертер корректно нашел первую и последнюю строки в шаблоне.
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
	 Id = [MatrixId] * 1000 + 101 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 98 , 
		[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'Code',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море Матрица'),
		[RuleDictionaryId]		= NULL,
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" копирует строку из колонки "матрица" в колонку "Code" шаблона СВТ. Служит только для того, чтобы конвертер корректно нашел первую и последнюю строки в шаблоне.',
		[Order]					= 101
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-Special')
	 ) AS R

	 UNION
	 SELECT
	 Id = [MatrixId] * 1000 + 102 + ROW_NUMBER() OVER(ORDER BY R.WorksheetId ASC),
	 R.*

	 from
	 (
		SELECT
		[MatrixId]				= 98 , 
		[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'DestinationSheetConstant'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'Code',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море Матрица'),
		[RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море пустая строка'),
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName]('None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0,
		[Description]			= N'Для шаблона  "'+t.[TemplateRussianName]+ N'" для вкладки "' + ws.[WorksheetName] + N'" Проставляет пустую строку в колонке "Code" шаблона СВТ. Служит только для того, чтобы конвертер корректно нашел первую и последнюю строки в шаблоне.',
		[Order]					= 102
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