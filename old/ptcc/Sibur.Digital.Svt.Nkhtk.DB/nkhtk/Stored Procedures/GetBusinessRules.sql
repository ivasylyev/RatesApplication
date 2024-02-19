CREATE   PROCEDURE [nkhtk].[GetBusinessRules]
(
	@templateId int = NULL
)
AS

BEGIN

  SELECT 
	  [Id], 
	  [Name],
	  [RuleType],
	  [Category],
	  [TemplateId]
  FROM
  (
    SELECT 
		1				AS [Id], 
		'Rule1'			AS [Name],
		1				AS [RuleType],
		1				AS [Category],
		1				AS [TemplateId] 
	UNION
	SELECT 
		2				AS [Id], 
		'Rule2'			AS [Name],
		2				AS [RuleType],
		2				AS [Category],
		1				AS [TemplateId]
    UNION
	SELECT 
		3				AS [Id], 
		'Rule3'			AS [Name],
		1				AS [RuleType],
		3				AS [Category],
		2				AS [TemplateId]
    UNION
	SELECT 
		4				AS [Id], 
		'Rule4'			AS [Name],
		2				AS [RuleType],
		4				AS [Category],
		2				AS [TemplateId]
	) R
	WHERE @templateId IS NULL OR R.[TemplateId] = @templateId

END