USE [mdm_integ]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE [nkhtk].[RuleDictionary](
	[RuleDictionaryId] [int] NOT NULL,
	[RuleDictionaryName] [nvarchar](700) NOT NULL,
	[RuleDictionaryDescription] [nvarchar](4000)  NULL,
	 CONSTRAINT [PK_RuleDictionary_Id] PRIMARY KEY CLUSTERED 
	(
		[RuleDictionaryId] ASC
	),
	CONSTRAINT UC_Dictionar_Name UNIQUE 
	(
		[RuleDictionaryName]
	),
)
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Словарь шаблона который используется бизнес-правилами при преобразовании шаблонов' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'RuleDictionary'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Уникальный идентификатор словаря шаблона' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'RuleDictionary', @level2type=N'COLUMN',@level2name=N'RuleDictionaryId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Уникальное имя словаря шаблона' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'RuleDictionary', @level2type=N'COLUMN',@level2name=N'RuleDictionaryName'
GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Описаине словаря шаблона' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'RuleDictionary', @level2type=N'COLUMN',@level2name=N'RuleDictionaryDescription'
GO

CREATE TABLE [nkhtk].[RuleDictionaryItem](
	[RuleDictionaryItemId] [int] NOT NULL,
	[RuleDictionaryId] [int] NOT NULL,
	[SourceValue] [nvarchar](max)  NULL,
	[DestinationValue] [nvarchar](max) NOT NULL,
	 CONSTRAINT [PK_RuleDictionaryItem_Id] PRIMARY KEY CLUSTERED 
	(
		[RuleDictionaryItemId] ASC
	)
)
GO

ALTER TABLE [nkhtk].[RuleDictionaryItem]  WITH CHECK ADD  CONSTRAINT [FK_RuleDictionary_RuleDictionaryId] FOREIGN KEY([RuleDictionaryId])
REFERENCES [nkhtk].[RuleDictionary] ([RuleDictionaryId])
GO

ALTER TABLE [nkhtk].[RuleDictionaryItem] CHECK CONSTRAINT [FK_RuleDictionary_RuleDictionaryId]
GO



EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Уникальный идентификатор элемента словаря' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'RuleDictionaryItem', @level2type=N'COLUMN',@level2name=N'RuleDictionaryItemId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ключ элемента словаря' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'RuleDictionaryItem', @level2type=N'COLUMN',@level2name=N'SourceValue'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение элемента словаря' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'RuleDictionaryItem', @level2type=N'COLUMN',@level2name=N'DestinationValue'
GO

--- TODO : Add dictionaries






INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )


    SELECT 
		50001								AS [RuleDictionaryId],
		N'RUB'								AS [RuleDictionaryItemName],
		N'Столбцы с валютой RUB'			AS [RuleDictionaryDescription]
		
UNION
	SELECT 
		81001,
		N'SugDistance',
		N'Словарь с зависимостью "Предоставление ТС" для СУГ-1, ШФЛУ 95, СУГ-3, СУГ-3Б, СУГ-2 от дистанции в км'

				
UNION
	SELECT 
		82001,
		N'NbDistance',
		N'Словарь с зависимостью "Предоставление ТС" для НБ-1, НБ-2 Хим, НБ-2 НП, НБ-3, НБ-4, НБ-5, НБ-6, НБ-7, НБ-8 от дистанции в км'	
	GO


	
INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [SourceValue],
		  [DestinationValue]
	  )


    SELECT
	    5000101			AS [RuleDictionaryItemId],
		50001			AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL			AS [SourceValue],  
		N'RUB'			AS [DestinationValue]

GO



		
	
INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [SourceValue],
		  [DestinationValue]
	  )

 SELECT
 [RuleDictionaryItemId] = 81001 * 10000 + ROW_NUMBER() OVER(ORDER BY RD.SourceValue ASC),
 [RuleDictionaryId] = 81001,
 RD.[SourceValue],
 RD.[DestinationValue]

 from
 (
    SELECT

		[SourceValue] = CAST ([S] AS nvarchar(max)),
		[DestinationValue] = CAST ([SUG] AS nvarchar(max))
	from [nkhtk].[TmpDistanceDictionary] 
 ) AS RD





GO

	
INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [SourceValue],
		  [DestinationValue]
	  )

 SELECT
 [RuleDictionaryItemId] = 82001 * 10000 + ROW_NUMBER() OVER(ORDER BY RD.SourceValue ASC),
 [RuleDictionaryId] = 82001,
 RD.[SourceValue],
 RD.[DestinationValue]

 from
 (
    SELECT

		[SourceValue] = CAST ([S] AS nvarchar(max)),
		[DestinationValue] = CAST ([NB] AS nvarchar(max))
	from [nkhtk].[TmpDistanceDictionary] 
 ) AS RD




GO

-- =============================================
-- Author:		Ivan Vasilev
-- Create date: 2022-07-12
-- Description:	Возвращает идентификатор словаря по его имени
-- =============================================

CREATE OR ALTER FUNCTION [nkhtk].[fnRuleDictionaryByName] 
(
	@name nvarchar(700)
)
RETURNS int
AS
BEGIN
	DECLARE @Id int

	SELECT @id = [RuleDictionaryId]
	FROM [nkhtk].[RuleDictionary]
	WHERE [RuleDictionaryName] = @name

	IF (@id IS NULL)
		DECLARE @i INT = CAST((N'Не найден идентификатор для "' + ISNULL(@name, '') + '"') AS INT)


	RETURN @id
END

GO
