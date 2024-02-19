
-- =============================================
-- Author:		Ivan Vasilev
-- Create date: 2022-07-12
-- Description:	Возвращает параметры вкладки и соответсвующего шаблона по идентификатору
-- =============================================

CREATE         PROCEDURE [nkhtk].[GetWorksheet]
(
	@worksheetId int = NULL
)
AS

BEGIN

  SELECT 
	   ws.[WorksheetId] 
	  ,ws.[WorksheetName]
	  ,t.[TemplateId]
	  ,t.[TemplateTypeId]
      ,t.[TemplateEnglishName]
      ,t.[TemplateRussianName]
  FROM  [nkhtk].[Worksheet] ws
  INNER JOIN  [nkhtk].[Template] t ON t.[TemplateId] = ws.[TemplateId]
  WHERE @worksheetId  = [WorksheetId]
  OR @worksheetId IS NULL

END