
-- =============================================
-- Author:		Ivan Vasilev
-- Create date: 2022-07-12
-- Description:	Возвращает все шаблоны со вкладками
-- =============================================

CREATE  OR ALTER    PROCEDURE [nkhtk].[GetTemplates]

AS
SELECT t.[TemplateId]
      ,t.[TemplateEnglishName]
      ,t.[TemplateRussianName]
	  ,ws.[WorksheetId]
	  ,t.[TemplateId]
	  ,ws.[WorksheetName]
  FROM [nkhtk].[Template] t
  INNER JOIN  [nkhtk].[Worksheet] ws ON ws.[TemplateId] = t.[TemplateId]
  ORDER BY t.[TemplateId]

