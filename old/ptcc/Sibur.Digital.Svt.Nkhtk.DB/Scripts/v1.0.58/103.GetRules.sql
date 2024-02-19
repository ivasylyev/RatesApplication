
-- =============================================
-- Author:		Ivan Vasilev
-- Create date: 2022-07-12
-- Description:	Возвращает бизнес-правила для данной вкладки шаблона по идентификатору
-- Example :  exec [nkhtk].[GetRules] 1001
-- =============================================


CREATE OR ALTER         PROCEDURE [nkhtk].[GetRules]
(
	@worksheetId int = NULL
)
AS

BEGIN

SELECT R.[RuleId]
      ,R.[MatrixId]
      ,R.[WorksheetId]
      ,R.[DestinationColumn]
      ,R.[RuleKindId]			AS [RuleKind]
      ,R.[RuleDataTypeId]		AS [RuleDataType]
      ,R.[RuleOperatorId]		AS [RuleOperator]
      ,R.[Mandatory]
      ,R.[TreatMissingDictionaryValueAsError]
      ,R.[Description]
      ,R.[Order]
	  ,R.[RuleId]
	  ,R.[RuleEntityId]
	  ,R.[RuleDictionaryId]
  FROM [nkhtk].[Rule] R
  WHERE @worksheetId IS NULL OR R.[WorksheetId] = @worksheetId
  ORDER by [Order]

END