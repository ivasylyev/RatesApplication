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
  

    IF @LocalTran = 1 AND XACT_STATE() = 1
        COMMIT TRAN


	DECLARE @RuleDictionaryId INT = 9901 -- ""

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId					AS [RuleDictionaryId],
			N'ММ Суша-Море пустая строка'					AS [RuleDictionaryItemName],
			N'Словарь с константой ""'			AS [RuleDictionaryDescription]
	
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
			N''				AS [DestinationValue]



	--------------------------------------------------------------------------------------------
	--  TotalCostTransport -
	--------------------------------------------------------------------------------------------

	SET @RuleDictionaryId = 15605 -- 


	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 100000 + 15	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			N''				    AS [SourceValue],  
			N'[Нет данных]'		AS [DestinationValue]
	
	


	UPDATE [nkhtk].[RuleDictionaryItem]
	SET [SourceValue] = '0'
	WHERE [RuleDictionaryItemId] = 1560500001
		AND [SourceValue] = '9'
	 


	





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
