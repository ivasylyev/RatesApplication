USE [mdm_integ]
GO

  

INSERT INTO   [nkhtk].[RuleOperator]
 ([RuleOperatorId], [RuleOperatorName], [RuleOperatorDescription] )

SELECT 
		6								AS [RuleOperatorId], 
		N'Concat'						AS [RuleOperatorName],
		N'Оператор конкатенации'		AS  [Description]
					
GO

