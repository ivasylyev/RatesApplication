USE mdm_integ
GO
-- =============================================
-- Author:		Ivan Vasilev
-- Create date: 2022-07-12
-- Description:	Возвращает все шаблоны со вкладками
-- Пример
--  EXEC [nkhtk].[GetTemplates] 2
-- =============================================

CREATE  OR ALTER    PROCEDURE [nkhtk].[GetTemplates]
(
  @TemplateTypeId INT = 1
)
AS
SELECT t.[TemplateId]
	  ,t.[TemplateTypeId]
      ,t.[TemplateEnglishName]
      ,t.[TemplateRussianName]
	  ,ws.[WorksheetId]
	  ,t.[TemplateId]
	  ,ws.[WorksheetName]
  FROM [nkhtk].[Template] t
  INNER JOIN  [nkhtk].[Worksheet] ws ON ws.[TemplateId] = t.[TemplateId]
  WHERE t.[TemplateTypeId] = @TemplateTypeId
  ORDER BY t.[TemplateId]

