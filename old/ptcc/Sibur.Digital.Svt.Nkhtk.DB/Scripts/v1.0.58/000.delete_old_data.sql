USE [mdm_integ]

GO

DROP TABLE IF EXISTS  [nkhtk].[TmpDistanceDictionary]
GO
DROP TABLE IF EXISTS  [nkhtk].[TmpNodeDictionary]
GO
DROP TABLE IF EXISTS  [nkhtk].[TmpProductDictionary]
GO



DELETE FROM [nkhtk].[Rule]
GO

DELETE FROM [nkhtk].[RuleEntityItem]
GO
DELETE FROM [nkhtk].[RuleEntity]
GO

DELETE FROM [nkhtk].[RuleDictionaryItem]
GO
DELETE FROM [nkhtk].[RuleDictionary]
GO

