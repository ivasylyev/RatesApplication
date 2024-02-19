USE [mdm_integ]
GO


INSERT INTO  [nkhtk].[Worksheet]
	  (
		  [WorksheetId], 
		  [WorksheetName],
		  [TemplateId]
	  )

  -- НЕКАЯ УСЛОВНАЯ вкладка для конвертации ставок
    SELECT 
		30001				AS [WorksheetId], 
		N'LOT'				AS [WorksheetName],
		30001				AS [TemplateId]
	

UNION
	  -- НЕКАЯ УСЛОВНАЯ вкладка для конвертации Спецставок
    SELECT 
		30002				AS [WorksheetId], 
		N'Спецставки'		AS [WorksheetName],
		30002				AS [TemplateId]
	
	GO