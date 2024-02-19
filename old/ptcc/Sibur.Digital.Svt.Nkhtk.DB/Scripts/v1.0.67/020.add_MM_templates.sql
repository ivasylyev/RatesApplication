USE [mdm_integ]
GO

INSERT INTO   [nkhtk].[Template]
 ([TemplateId], [TemplateTypeId], [TemplateEnglishName], [TemplateRussianName] )

SELECT 
		30001	AS [TemplateId],
		2		AS [TemplateTypeId],
		N'MM-Land-Sea'	AS [TemplateEnglishName],
		N'ММ-перевозки Суша-Море. Тендер. 2 плеча.'	AS [TemplateRussianName]

UNION
SELECT 
		30002	AS [TemplateId],
		3		AS [TemplateTypeId],
		N'MM-Land-Sea-Special'	AS [TemplateEnglishName],
		N'ММ-перевозки Суша-Море. Тендер. 2 плеча. Спецставки'	AS [TemplateRussianName]


GO