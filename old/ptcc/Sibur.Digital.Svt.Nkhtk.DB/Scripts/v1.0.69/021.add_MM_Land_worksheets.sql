USE [mdm_integ]
GO

BEGIN TRY

    DECLARE @LocalTran BIT = IIF(@@TRANCOUNT = 0, 1, 0)

    IF @LocalTran = 1
        BEGIN TRAN


	INSERT INTO  [nkhtk].[Worksheet]
		  (
			  [WorksheetId], 
			  [WorksheetName],
			  [TemplateId]
		  )

	  -- НЕКАЯ УСЛОВНАЯ вкладка для конвертации ставок
		SELECT 
			30011				AS [WorksheetId], 
			N'LOT'				AS [WorksheetName],
			30011				AS [TemplateId]
	

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