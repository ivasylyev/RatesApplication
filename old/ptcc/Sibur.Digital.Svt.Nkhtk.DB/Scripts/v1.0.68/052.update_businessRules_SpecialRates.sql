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



	------------------------------------------------
	-- mix_sea
	------------------------------------------------

	DECLARE @RuleDictionaryId INT = 14903 -- Mix_40

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId					    AS [RuleDictionaryId],
			N'ММ Суша-Море Mix_40'					AS [RuleDictionaryItemName],
			N'Словарь с константой "Mix_40"'		AS [RuleDictionaryDescription]
	
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
			N'Mix_40'			AS [DestinationValue]

	 




	UPDATE r
	SET r.[Description] = N'Для шаблона спецставок "ММ-перевозки Суша-Море. Тендер. 2 плеча. Спецставки" для вкладки "Спецставки" Копирует константу "Mix_40" в колонку "TransportType" шаблона СВТ',
		r.[RuleDictionaryId] = [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море Mix_40')
	FROM [nkhtk].[Rule] r
			INNER JOIN [nkhtk].[Worksheet] ws ON r.WorksheetId = ws.WorksheetId
			INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
			WHERE t.TemplateEnglishName IN (N'MM-Land-Sea-Special')
			AND DestinationColumn = N'TransportType'
			AND [RuleDictionaryId]		= [nkhtk].[fnRuleDictionaryByName](N'ММ Суша-Море mix_sea')



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