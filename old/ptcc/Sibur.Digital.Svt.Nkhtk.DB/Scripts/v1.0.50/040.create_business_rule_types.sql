USE [mdm_integ]
GO

/****** Object:  Table [nkhtk].[RuleDataType]    Script Date: 07.07.2022 14:53:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [nkhtk].[RuleDataType](
	[RuleDataTypeId] [int] NOT NULL,
	[RuleDataTypeName] [nvarchar](700) NOT NULL,
	 CONSTRAINT [PK_RuleDataType_Id] PRIMARY KEY CLUSTERED 
	(
		[RuleDataTypeId] ASC
	),
	CONSTRAINT UC_RuleDataType_Name UNIQUE 
	(
		[RuleDataTypeName]
	)
)
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Типа данных бизнес-правила для преобразования шаблонов из НХТК в СВТ' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'RuleDataType'
GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Уникальный идентификатор типа данных бизнес-правила.' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'RuleDataType', @level2type=N'COLUMN',@level2name=N'RuleDataTypeId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Имя типа данных бизнес-правила.' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'RuleDataType', @level2type=N'COLUMN',@level2name=N'RuleDataTypeName'
GO


  

INSERT INTO   [nkhtk].[RuleDataType]
 ([RuleDataTypeId],[RuleDataTypeName] )

SELECT 
		0				AS [RuleDataTypeId], 
		N'General'		AS [RuleDataTypeName]
				UNION
	SELECT 
		1	,			
		N'Text'			
				UNION

	SELECT 
		2	,			
		N'Number'		
				UNION
	SELECT 
		3		,		
		N'Boolean'		
				UNION
	SELECT 
		4		,		
		N'DateTime'		
				UNION
	SELECT 
		5	,			
		N'TimeSpan'		

		GO

-- =============================================
-- Author:		Ivan Vasilev
-- Create date: 2022-07-12
-- Description:	Возвращает идентификатор типа данных, которыми оперирует правило, по имени типа данных
-- =============================================
CREATE OR ALTER FUNCTION [nkhtk].[fnRuleDataTypeByName] 
(
	@name nvarchar(700)
)
RETURNS int
AS
BEGIN
	DECLARE @Id int

	SELECT @id = [RuleDataTypeId]
	FROM [nkhtk].[RuleDataType]
	WHERE [RuleDataTypeName] = @name

	IF (@id IS NULL)
		DECLARE @i INT = CAST((N'Не найден идентификатор для "' + ISNULL(@name, '') + '"') AS INT)


	RETURN @id
END

	GO