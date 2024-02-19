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
   -- 36
   -- удаляем склеивание "матрицы" с "описаинем строки"
		DELETE R
		FROM [nkhtk].[Rule] r
		INNER JOIN [nkhtk].[Worksheet] ws ON r.WorksheetId = ws.WorksheetId
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea')
		AND DestinationColumn = N'RateTenderServicePack'
		AND ([RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море _'))
			OR [RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море Описание строки')

     -- удаляем подчеркивание между склеиваемыеми "матрицой" с "описаинем строки"
	 DELETE FROM [nkhtk].[RuleDictionaryItem]
	 WHERE [RuleDictionaryId] = [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море _')

	 DELETE FROM [nkhtk].[RuleDictionary]
	 WHERE [RuleDictionaryId] = [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море _')



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
		[MatrixId]				= 160,  
		[RuleKindId]			= [nkhtk].[fnRuleKindByName](N'SourceColumnCopy'),
		[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'General'), 
		[DestinationColumn]		= N'TechNumLine',
		[RuleEntityId]			= [nkhtk].[fnRuleEntityByName](N'ММ Суша-Море Описание строки'), -- 
		[RuleDictionaryId]		= NULL, -- словаря нет, простое копирование
		[WorksheetId]			= ws.WorksheetId,	
		[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'None'), 
		[Mandatory]				= 1,
		[TreatMissingDictionaryValueAsError] = 0, 
		[Description]			= N'Копирует колонку "Описание строки" из шаблона "'+t.[TemplateRussianName]+N'" из вкладки "' + ws.[WorksheetName] + N'" в колонку "RateTenderServicePack" шаблона СВТ',
		[Order]					= 1600
		FROM [nkhtk].[Worksheet] ws
		INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
		WHERE t.TemplateEnglishName IN (N'MM-Land-Sea')
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