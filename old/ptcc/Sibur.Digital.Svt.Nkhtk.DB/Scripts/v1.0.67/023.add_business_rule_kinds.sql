USE [mdm_integ]
GO

  

INSERT INTO   [nkhtk].[RuleKind]
 ([RuleKindId], [RuleKindName], [RuleKindDescription] )


	SELECT 
		23,
		N'SourceSheetConstant',
		N'Правило копирует в каждую строчку колонки шаблона назначения одну и ту же константу столько раз, сколько строчек в шаблоне-источнике'

		
UPDATE [nkhtk].[RuleKind]
	SET [RuleKindName] = N'DestinationSheetConstant',
	[RuleKindDescription] = N'Правило копирует в каждую строчку колонки шаблона назначения одну и ту же константу столько раз, сколько строчек уже существует в шаблоне СВТ'
	WHERE [RuleKindId] = 20

GO