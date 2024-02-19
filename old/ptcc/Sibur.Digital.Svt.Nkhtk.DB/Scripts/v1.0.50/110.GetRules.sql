
-- =============================================
-- Author:		Ivan Vasilev
-- Create date: 2022-07-12
-- Description:	Возвращает бизнес-правила для данной вкладки шаблона по идентификатору
-- =============================================

CREATE  OR ALTER      PROCEDURE [nkhtk].[GetRules]
(
	@worksheetId int = NULL
)
AS

BEGIN

SELECT R.[RuleId]
      ,R.[MatrixId]
      ,R.[WorksheetId]
      ,R.[DestinationColumn]
      ,R.[RuleKindId]
      ,R.[RuleDataTypeId]
      ,R.[RuleOperatorId]
      ,R.[Mandatory]
      ,R.[TreatMissingDictionaryValueAsError]
      ,R.[Description]
      ,R.[Order]
	  ,Entity.[RuleEntityItemId]
	  ,Entity.[RuleEntityItemName]
  FROM [nkhtk].[Rule] R
  LEFT JOIN  
	  ( 
			SELECT 
			RE.[RuleEntityId],
			REI.[RuleEntityItemId],
			REI.[RuleEntityItemName]
			FROM [nkhtk].[RuleEntityItem] REI
			INNER JOIN  [nkhtk].[RuleEntity] RE ON REI.[RuleEntityId] = RE.[RuleEntityId]

	  ) Entity	 ON Entity.[RuleEntityId] = R.[RuleEntityId]
  WHERE @worksheetId IS NULL OR R.[WorksheetId] = @worksheetId

END