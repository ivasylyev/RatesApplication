USE [mdm_integ]
GO

/****** Object:  Table [nkhtk].[RuleKind]    Script Date: 07.07.2022 14:53:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [nkhtk].[RuleKind](
	[RuleKindId] [int] NOT NULL,
	[RuleKindName] [nvarchar](700) NOT NULL,
	[RuleKindDescription] [nvarchar](4000) NOT NULL,
	 CONSTRAINT [PK_RuleKind_Id] PRIMARY KEY CLUSTERED 
	(
		[RuleKindId] ASC
	),
	CONSTRAINT UC_RuleKind_Name UNIQUE 
	(
		[RuleKindName]
	)
)
GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Вид бизнес-правила для преобразования шаблонов из НХТК в СВТ' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'RuleKind'
GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Уникальный идентификатор вида бизнес-правила.' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'RuleKind', @level2type=N'COLUMN',@level2name=N'RuleKindId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Имя вида бизнес-правила.' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'RuleKind', @level2type=N'COLUMN',@level2name=N'RuleKindName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Описание вида бизнес-правила.' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'RuleKind', @level2type=N'COLUMN',@level2name=N'RuleKindDescription'
GO


  

INSERT INTO   [nkhtk].[RuleKind]
 ([RuleKindId],[RuleKindName], [RuleKindDescription] )

SELECT 
		0				AS [RuleKindId], 
		N'None'			AS [RuleKindName],
		N'Вид бизнес-правила не установлен'				AS  [RuleKindDescription]
				UNION
	SELECT 
		20,
		N'SheetConstant',
		N'Правило копирует в каждую строчку колонки шаблона назначения одну и ту же константу, единую для данной страницы шаблона источника'
				UNION

	SELECT 
		21,
		N'SheetParameter',
		N'Правило копирует в каждую строчку колонки шаблона назначения одно и то же значения параметра, переданного извне'
				UNION
	SELECT 
		22,
		N'SheetMultiplier',
		N'Правило копирует в колонку шаблона назначения ряд констант,
для каждой константы создавая копию ВСЕХ существующих данных в других колонках.
Например, если а шаблоне назначения было 3 строки с данными, а ряд констант состоит из двух значений,
после применения правила в шаблоне назначения будет 6 строк с данными, по 3 для каждого значения из ряда констант'

				UNION
	SELECT 
		30,
		N'SourceColumnCopy',
		N'Правило копирует в колонку шаблона назначения данные из колонки исходного шаблона либо напрямую, либо, если у правила существует словарь - подменяет значениями из словаря'
				UNION
	SELECT 
		31,
		N'SourceColumnCopyDictionaryOnly',
		N'Правило копирует в колонку шаблона назначения данные из из словаря. В качестве ключа берется значение исходного шаблона. Если в словаре ключ не найден - копируется пустое значение'
				UNION
	SELECT 
		32,
		N'DestinationColumnCopy',
		N'Правило копирует в колонку шаблона назначения данные из другой колонки этого же шаблона. Данные копируеются либо напрямую, либо, если у правила существует словарь - подменяет значениями из словаря'
				UNION
	SELECT 
		40,
		N'VerticalCellCopy',
		N'Правило копирует в каждую строчку колонки шаблона назначения одно и то же значение, Находящееся по вертикали снизу под ячейкой с заголовком'
				UNION
	SELECT 
		50,
		N'HorizontalCellCopy',
		N'Правило копирует в каждую строчку колонки шаблона назначения одно и то же значение, Находящееся по горизонтаи сбоку ячейки с заголовком'
		


GO

-- =============================================
-- Author:		Ivan Vasilev
-- Create date: 2022-07-12
-- Description:	Возвращает идентификатор вида правила по его имени
-- =============================================

CREATE OR ALTER FUNCTION [nkhtk].[fnRuleKindByName] 
(
	@name nvarchar(700)
)
RETURNS int
AS
BEGIN
	DECLARE @Id int

	SELECT @id = [RuleKindId]
	FROM [nkhtk].[RuleKind]
	WHERE [RuleKindName] = @name

	IF (@id IS NULL)
		DECLARE @i INT = CAST((N'Не найден идентификатор для "' + ISNULL(@name, '') + '"') AS INT)


	RETURN @id
END

GO
