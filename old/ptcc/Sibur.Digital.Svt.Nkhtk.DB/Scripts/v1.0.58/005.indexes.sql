USE [mdm_integ]

GO

	IF  EXISTS (SELECT * 
		FROM sys.indexes 
		WHERE name='IX_Rule_WorksheetId' AND object_id = OBJECT_ID('nkhtk.Rule'))
	BEGIN
		DROP INDEX [IX_Rule_WorksheetId] ON [nkhtk].[Rule]
	END 

GO
	CREATE NONCLUSTERED INDEX IX_Rule_WorksheetId
	ON [nkhtk].[Rule] ([WorksheetId])
	INCLUDE (RuleDictionaryId, RuleEntityId)


GO

	IF  EXISTS (SELECT * 
		FROM sys.indexes 
		WHERE name='IX_RuleDictionaryItem_RuleDictionaryId' AND object_id = OBJECT_ID('nkhtk.RuleDictionaryItem'))
	BEGIN
		DROP INDEX [IX_RuleDictionaryItem_RuleDictionaryId] ON [nkhtk].[RuleDictionaryItem]
	END 

GO
	CREATE NONCLUSTERED INDEX IX_RuleDictionaryItem_RuleDictionaryId
	ON [nkhtk].[RuleDictionaryItem]  ([RuleDictionaryId])
	INCLUDE ([RuleDictionaryItemId], [SourceValue], [DestinationValue])


GO


GO

	IF  EXISTS (SELECT * 
		FROM sys.indexes 
		WHERE name='IX_RuleEntityItem_RuleEntityId' AND object_id = OBJECT_ID('nkhtk.RuleEntityItem'))
	BEGIN
		DROP INDEX [IX_RuleEntityItem_RuleEntityId] ON [nkhtk].[RuleEntityItem]
	END 

GO
	CREATE NONCLUSTERED INDEX IX_RuleEntityItem_RuleEntityId
	ON [nkhtk].[RuleEntityItem]  ([RuleEntityId])
	INCLUDE ([RuleEntityItemId], [RuleEntityItemName])


GO