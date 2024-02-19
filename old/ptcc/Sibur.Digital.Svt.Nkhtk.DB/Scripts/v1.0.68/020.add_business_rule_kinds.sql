USE [mdm_integ]
GO
  

INSERT INTO   [nkhtk].[RuleKind]
 ([RuleKindId], [RuleKindName], [RuleKindDescription] )


	SELECT 
		60,
		N'SourceSheetDeleteRows',
		N'Правило удаляет из шаблона-источника строки. Критерий удаления - наличие значений в соответсвующем словаре'

GO