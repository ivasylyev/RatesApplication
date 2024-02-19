USE [mdm_integ]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [nkhtk].[RuleEntity](
	[RuleEntityId] [int] NOT NULL,
	[RuleEntityName] [nvarchar](700) NOT NULL,
	[RuleEntityDescription] [nvarchar](4000)  NULL,
	 CONSTRAINT [PK_RuleEntity_Id] PRIMARY KEY CLUSTERED 
	(
		[RuleEntityId] ASC
	),
	CONSTRAINT UC_RuleEntity_Name UNIQUE 
	(
		[RuleEntityName]
	),
)
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Коллекция элементов шаблона (колонок или столбцов) которыми оперируют бизнес-правила преобразования шаблонов' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'RuleEntity'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Уникальный идентификатор коллекции элементов шаблона' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'RuleEntity', @level2type=N'COLUMN',@level2name=N'RuleEntityId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Имя коллекции элементов шаблона' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'RuleEntity', @level2type=N'COLUMN',@level2name=N'RuleEntityName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Описание коллекции элементов шаблона' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'RuleEntity', @level2type=N'COLUMN',@level2name=N'RuleEntityDescription'
GO


CREATE TABLE [nkhtk].[RuleEntityItem](
	[RuleEntityItemId] [int] NOT NULL,
	[RuleEntityId] [int] NOT NULL,
	[RuleEntityItemName] [nvarchar](4000) NOT NULL,
	 CONSTRAINT [PK_RuleEntityItem_Id] PRIMARY KEY CLUSTERED 
	(
		[RuleEntityItemId] ASC
	)
)
GO

ALTER TABLE [nkhtk].[RuleEntityItem]  WITH CHECK ADD  CONSTRAINT [FK_RuleEntity_RuleEntityId] FOREIGN KEY([RuleEntityId])
REFERENCES [nkhtk].[RuleEntity] ([RuleEntityId])
GO

ALTER TABLE [nkhtk].[RuleEntityItem] CHECK CONSTRAINT [FK_RuleEntity_RuleEntityId]
GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Элемент шаблона (столбец или ячейка) которым оперируют бизнес-правила преобразования шаблонов' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'RuleEntityItem'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Уникальный идентификатор исходного элемента шаблона (столбца или ячейки)' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'RuleEntityItem', @level2type=N'COLUMN',@level2name=N'RuleEntityItemId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Описаине исходного элемента шаблона (столбца или ячейки)' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'RuleEntityItem', @level2type=N'COLUMN',@level2name=N'RuleEntityItemName'
GO



INSERT INTO  [nkhtk].[RuleEntity]
	  (
		  [RuleEntityId],
		  [RuleEntityName],
		  [RuleEntityDescription]
	  )


    SELECT 
		40001									AS [RuleEntityId],
		N'Тариф'									AS [RuleEntityItemName],
		N'Столбцы "Тариф" шаблона НХТК'			AS [RuleEntityDescription]
UNION
	SELECT 
		40002,
		N'Охрана груза',
		N'Столбцы "Охрана груза" шаблона НХТК'	
UNION
	SELECT 
		 
		40003,
		N'Тариф Сахалин',
		N'Столбцы "Тариф Сахалин"  шаблона НХТК - только для НБ-1 - МТБЭ Сахалин'		
 UNION  
   	SELECT 		 
		80001,
		N'ВС со СЗ',
		N'Столбцы "ВС со СЗ" шаблона НХТК'		
UNION  
   	SELECT 		 
		80002,
		N'S, км',
		N'Столбцы "S, км" шаблона НХТК'
UNION
	SELECT 		 
		80003,
		N'Вагонная составляющая',
		N'Столбцы "Вагонная составляющая" шаблона НХТК'
UNION
	SELECT 		 
		160001,
		N'ГО отправления',
		N'Столбцы "ГО отправления" или "ТЭ отправления" шаблона НХТК'	
UNION
	SELECT 		 
		190001,
		N'ПНП отправления',
		N'Столбцы "ПНП отправления" шаблона НХТК'
UNION
		SELECT 		 
		200001,
		N'ГО назначения',
		N'Столбцы "ТЭ назнач." или "ГО назнач." шаблона НХТК'

UNION
		SELECT 		 
		230001,
		N'ПНП назначения',
		N'Столбцы "ПНП назнач." шаблона НХТК'

UNION
		SELECT 		 
		470001,
		N'Станция отправления',
		N'Столбцы "Станция отправления" шаблона НХТК'
UNION
		SELECT 		 
		480001,
		N'Станция назначения',
		N'Столбцы "Станция назначения" шаблона НХТК'

UNION
		SELECT 		 
		510001,
		N'Загрузка',
		N'Столбцы "загрузка", "Расчетный вес, т" шаблона НХТК'
UNION
		SELECT 		 
		520001,
		N'Product',
		N'Столбцы "Product" шаблона СВТ'
	GO


	
INSERT INTO  [nkhtk].[RuleEntityItem]
	  (
			[RuleEntityItemId],
		  [RuleEntityId], 
		  [RuleEntityItemName]
	  )


    SELECT
	    4000101			AS [RuleEntityItemId],
		40001			AS [RuleEntityId], 
		N'Тариф'			AS [RuleEntityItemName]
	UNION
	SELECT 
		4000102,			
		40001,			 
		N'Тариф РЖД'			
    UNION

	SELECT 
		4000103,			
		40001,			 
		N'Тариф по РЖД'

		UNION
	SELECT 
		4000201,
		40002,	
		N'Охрана груза.'

	UNION
	SELECT 
		 
		4000301,
		40003,
		N'Тариф Сахалин'		
    UNION  
   	SELECT 		 
		8000101,
		80001,				
		N'ВС со СЗ Реализация'
		 UNION  
   	SELECT 		 
		8000102,
		80001,				
		N'ВС со СЗ'
    UNION  
   	SELECT
		8000201,	
		80002,				
		N'S, км'
	UNION  
   	SELECT
		8000202,	
		80002,				
		N'S всего, км'
	UNION  
   	SELECT
		8000203,	
		80002,				
		N'Общее расстояние , км. '
	UNION
	SELECT
		8000301,
		80003,				
		N'ВС'
		UNION
	SELECT
		8000302,	 
		80003,				
		N'Вагонная составляющая'
	 UNION
	SELECT
		16000101,
		160001,				
		N'ТЭ отправ.'
		 UNION
	SELECT
		16000102,
		160001,				
		N'ГО отправ.'
		 UNION
	SELECT
		16000103,
		160001,				
		N'ТЭ отпр.'
		 UNION
	SELECT
		16000104,
		160001,				
		N'ГО отправления'
		 UNION
	SELECT
		16000105,
		160001,				
		N'ТЭ отправления'
		 UNION
	SELECT
		16000106,
		160001,				
		N'ТЭ'
		
	UNION
	SELECT
		19000101,	
		190001,				
		N'ПНП отправ.'
		UNION
	SELECT
		19000102,	
		190001,				
		N'ПНП отправл.'
		UNION
	SELECT
		19000103,	
		190001,				
		N'ПНП отправления'
		UNION
	SELECT
		19000104,	
		190001,				
		N'ПНП'

	UNION
		SELECT
		20000101,	
		200001,				
		N'ТЭ назнач.'
	UNION
		SELECT
		20000102,	
		200001,				
		N'ГО назнач.'
	UNION
		SELECT
		20000103,	
		200001,				
		N'ТЭ назн.'
	UNION
		SELECT
		20000104,	
		200001,				
		N'ТЭ назначения'
	UNION
		SELECT
		20000105,	
		200001,				
		N'ГО назначения'
	
	UNION
SELECT
	23000101,	
		230001,				
		N'ПНП назнач.'
	UNION
SELECT
	23000102,	
		230001,				
		N'ПНП назначен.'




UNION
SELECT
		47000101,
		470001,				
		N'Станция отправления'
		UNION
SELECT
		47000102,
		470001,				
		N'Ст. отправления'
UNION
SELECT 		 
		48000101,
		480001,
		N'Станция назначения'
UNION
SELECT 		 
		48000102,
		480001,
		N'Ст. назначения'

		UNION
SELECT
		51000101,
		510001,				
		N'загрузка'

UNION
SELECT
		51000102,
		510001,				
		N'Расчетный вес, т'
UNION
		SELECT
		52000101,	
		520001,				
		N'Product'
	GO


	
-- =============================================
-- Author:		Ivan Vasilev
-- Create date: 2022-07-12
-- Description:	Возвращает идентификатор коллекции элементов шаблона по его имени
-- =============================================

CREATE OR ALTER FUNCTION [nkhtk].[fnRuleEntityByName] 
(
	@name nvarchar(700)
)
RETURNS int
AS
BEGIN
	DECLARE @Id int

	SELECT @id = [RuleEntityId]
	FROM [nkhtk].[RuleEntity]
	WHERE [RuleEntityName] = @name

	IF (@id IS NULL)
		DECLARE @i INT = CAST((N'Не найден идентификатор для "' + ISNULL(@name, '') + '"') AS INT)


	RETURN @id
END

GO
