USE [mdm_integ]
GO


BEGIN TRY

    DECLARE @LocalTran BIT = IIF(@@TRANCOUNT = 0, 1, 0)

    IF @LocalTran = 1
        BEGIN TRAN








        INSERT INTO   [nkhtk].[Template]
         ([TemplateId], [TemplateTypeId], [TemplateEnglishName], [TemplateRussianName] )

        SELECT 
		        30011	AS [TemplateId],
		        2		AS [TemplateTypeId],
		        N'MM-Land-Land'	AS [TemplateEnglishName],
		        N'ММ-перевозки Суша-Суша. Тендер. 2 плеча.'	AS [TemplateRussianName]




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