USE [mdm_integ]
GO


INSERT INTO  [nkhtk].[Worksheet]
	  (
		  [WorksheetId], 
		  [WorksheetName],
		  [TemplateId]
	  )

  --  ТК РФ
    SELECT 
		15001					AS [WorksheetId], 
		N'ТК РФ'				AS [WorksheetName],
		15001					AS [TemplateId]
	UNION
	SELECT 
		15002,				
		N'ТК РФ  Биклянь Форвард ТС',
		15001					
    
	GO