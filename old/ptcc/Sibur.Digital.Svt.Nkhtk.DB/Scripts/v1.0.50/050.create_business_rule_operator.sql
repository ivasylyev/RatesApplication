USE [mdm_integ]
GO

/****** Object:  Table [nkhtk].[RuleOperator]    Script Date: 07.07.2022 14:53:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [nkhtk].[RuleOperator](
	[RuleOperatorId] [int] NOT NULL,
	[RuleOperatorName] [nvarchar](700) NOT NULL,
	[RuleOperatorDescription] [nvarchar](4000) NOT NULL,
	 CONSTRAINT [PK_RuleOperator_Id] PRIMARY KEY CLUSTERED 
	(
		[RuleOperatorId] ASC
	),
	CONSTRAINT UC_RuleOperator_Name UNIQUE 
	(
		[RuleOperatorName]
	)
)
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Оператор, применяемы к данным, которыми оперируют бизнес-правила для преобразования шаблонов из НХТК в СВТ' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'RuleOperator'
GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Уникальный идентификатор оператора.' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'RuleOperator', @level2type=N'COLUMN',@level2name=N'RuleOperatorId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Имя оператора.' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'RuleOperator', @level2type=N'COLUMN',@level2name=N'RuleOperatorName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Описание оператора.' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'RuleOperator', @level2type=N'COLUMN',@level2name=N'RuleOperatorDescription'
GO


  

INSERT INTO   [nkhtk].[RuleOperator]
 ([RuleOperatorId], [RuleOperatorName], [RuleOperatorDescription] )

SELECT 
		0								AS [RuleOperatorId], 
		N'None'							AS [RuleOperatorName],
		N'Оператор не применяется'		AS  [Description]
				UNION

SELECT 
		1				, 
		N'Plus'			,
		N'Оператор сложения'			
				UNION

SELECT 
		2				,
		N'Minus'			,
		N'Оператор вычитания'		
				UNION

SELECT 
		3				,
		N'Multiply'			,
		N'Оператор умножения'		
				UNION

SELECT 
		4				,
		N'Divide'			,
		N'Оператор деления'		
				UNION

SELECT 
		5				,
		N'IsNull'			,
		N'Оператор замены значение NULL указанным замещающим значением. условной замены. Возвращает  первый аргумент, если он не равен NULL. Иначе возвращает второй аргумент.'				AS  [Description]
				
		GO


		
-- =============================================
-- Author:		Ivan Vasilev
-- Create date: 2022-07-12
-- Description:	Возвращает идентификатор оператора, применяемый к данным, которыми оперирует правло, по его имени
-- =============================================
CREATE OR ALTER FUNCTION [nkhtk].[fnRuleOperatorByName] 
(
	@name nvarchar(700)
)
RETURNS int
AS
BEGIN
	DECLARE @Id int

	SELECT @id = [RuleOperatorId]
	FROM [nkhtk].[RuleOperator]
	WHERE [RuleOperatorName] = @name

	IF (@id IS NULL)
		DECLARE @i INT = CAST((N'Не найден идентификатор для "' + ISNULL(@name, '') + '"') AS INT)

	RETURN @id
END

	GO
