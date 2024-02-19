
USE [mdm_integ]

GO

UPDATE r
	SET [DestinationColumn]	= N'EmptyRFSize'
FROM [nkhtk].[Rule] r
	INNER JOIN  [nkhtk].[Worksheet] ws ON ws.WorksheetId = r.WorksheetId
	INNER JOIN [nkhtk].[Template] t ON t.TemplateId = ws.TemplateId
WHERE   r.[MatrixId]			= 8  
	AND	r.[RuleKindId]			=  [nkhtk].[fnRuleKindByName](N'SourceColumnCopy')
	AND	r.[RuleDataTypeId]		= [nkhtk].[fnRuleDataTypeByName](N'Number') 
	AND	r.[DestinationColumn]	= N'`'
	AND	r.[RuleEntityId]		= [nkhtk].[fnRuleEntityByName](N'S, км') 
	AND	r.[RuleDictionaryId]	= [nkhtk].[fnRuleDictionaryByName](N'NbDistance')	
	AND	r.[RuleOperatorId]		= [nkhtk].[fnRuleOperatorByName](N'Minus')
	AND t.TemplateEnglishName   IN (N'HB-1', N'HB-2-1', N'HB-2-2', N'HB-3', N'HB-5', N'HB-7', N'HB-8' )

GO

IF EXISTS (SELECT * FROM [nkhtk].[Rule] WHERE [DestinationColumn]	= N'`')
   RAISERROR (N'Не все правила были исправлены', 16, 1)

GO