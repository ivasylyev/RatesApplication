
-- =============================================
-- Author:		Ivan Vasilev
-- Create date: 2022-09-01
-- Description:	Возвращает словарь для бизнес-правила
-- Example :  exec [nkhtk].[GetRuleDictionaries] 1001
-- =============================================

CREATE OR ALTER         PROCEDURE [nkhtk].[GetRuleDictionaries]
(
	@worksheetId int
)
AS

BEGIN

  SELECT 
		D.[RuleDictionaryId],
		D.[RuleDictionaryName],
		D.[RuleDictionaryDescription],
		DI.[RuleDictionaryItemId],
		DI.[SourceValue],
		DI.[DestinationValue]
 
  FROM [nkhtk].[RuleDictionary] D
  INNER JOIN  (
	SELECT DISTINCT
		  [RuleDictionaryId]
	FROM  [nkhtk].[Rule] 
	WHERE [WorksheetId] = @worksheetId
  ) AS R
  ON D.[RuleDictionaryId] = R.[RuleDictionaryId]
  INNER JOIN [nkhtk].[RuleDictionaryItem] DI
  ON DI.[RuleDictionaryId] = D.[RuleDictionaryId]

END