
-- =============================================
-- Author:		Ivan Vasilev
-- Create date: 2022-09-02
-- Description:	Возвращает исходные сущности (столбцы или ячейки) для преобразование бизнес-правилом по идентификатору
-- Example :  exec [nkhtk].[GetRuleEntities] 1001
-- =============================================

CREATE OR ALTER         PROCEDURE [nkhtk].[GetRuleEntities]
(
	@worksheetId int
)
AS

BEGIN
	
  SELECT 
	RE.[RuleEntityId],
	RE.[RuleEntityName],
	RE.[RuleEntityDescription],
	REI.[RuleEntityItemId],
	REI.[RuleEntityItemName]
 
  FROM [nkhtk].[RuleEntity] RE
  INNER JOIN  (
	SELECT DISTINCT
		  [RuleEntityId]
	FROM  [nkhtk].[Rule] 
	WHERE [WorksheetId] = @worksheetId
  ) AS R
  ON RE.[RuleEntityId] = R.[RuleEntityId]
  INNER JOIN [nkhtk].[RuleEntityItem] REI
  ON REI.[RuleEntityId] = RE.[RuleEntityId]


END