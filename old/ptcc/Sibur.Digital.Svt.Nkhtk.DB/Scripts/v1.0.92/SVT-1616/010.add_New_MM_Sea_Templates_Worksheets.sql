USE [mdm_integ]
GO


BEGIN TRY

    DECLARE @LocalTran BIT = IIF(@@TRANCOUNT = 0, 1, 0)

    IF @LocalTran = 1
        BEGIN TRAN




        

        INSERT INTO   [nkhtk].[Template]
         ([TemplateId], [TemplateTypeId], [TemplateEnglishName], [TemplateRussianName] )

		 /*
		 SELECT 
		        31011	AS [TemplateId],
		        2		AS [TemplateTypeId],
		        N'MM-Land-Land-New'	AS [TemplateEnglishName],
		        N'Новый Подход. ММ-перевозки Суша-Суша. Тендер. 2 плеча.'	AS [TemplateRussianName]

		UNION
		*/
		SELECT 
				31001	AS [TemplateId],
				2		AS [TemplateTypeId],
				N'MM-Land-Sea-New'	AS [TemplateEnglishName],
				N'Новый Подход. ММ-перевозки Суша-Море. Тендер. 2 плеча.'	AS [TemplateRussianName]



        INSERT INTO  [nkhtk].[Worksheet]
	          (
		          [WorksheetId], 
		          [WorksheetName],
		          [TemplateId]
	          )

     /*
            SELECT 
		        31011				AS [WorksheetId], 
		        N'LOT'				AS [WorksheetName],      -- НЕКАЯ УСЛОВНАЯ вкладка для конвертации ставок
		        31011				AS [TemplateId]
		UNION
        */
            SELECT 
		        31001				AS [WorksheetId], 
		        N'LOT'				AS [WorksheetName],      -- НЕКАЯ УСЛОВНАЯ вкладка для конвертации ставок
		        31001				AS [TemplateId]




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