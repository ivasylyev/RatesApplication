USE [mdm_integ]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


------------------------------------------------

DECLARE @RuleEntityId int = 40001 -- Тариф

INSERT INTO  [nkhtk].[RuleEntity]
	  (
		  [RuleEntityId],
		  [RuleEntityName],
		  [RuleEntityDescription]
	  )


    SELECT 
		@RuleEntityId							AS [RuleEntityId],
		N'Тариф'								AS [RuleEntityItemName],
		N'Столбцы "Тариф" шаблона НХТК'			AS [RuleEntityDescription]
	
INSERT INTO  [nkhtk].[RuleEntityItem]
	  (
		  [RuleEntityItemId],
		  [RuleEntityId], 
		  [RuleEntityItemName]
	  )


    SELECT
	    @RuleEntityId * 100 + 1	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'Тариф'				AS [RuleEntityItemName]

	UNION

	SELECT 
	    @RuleEntityId * 100 + 2	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 		 
		N'Тариф РЖД'			AS [RuleEntityItemName]
		
    UNION

	SELECT
		@RuleEntityId * 100 + 3	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 		 
		N'Тариф по РЖД'			AS [RuleEntityItemName]	

    UNION

	SELECT
		@RuleEntityId * 100 + 4	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 		 
		N'Тариф, руб/т'			AS [RuleEntityItemName]	

GO


------------------------------------------------

DECLARE @RuleEntityId int = 40002 -- Охрана груза

INSERT INTO  [nkhtk].[RuleEntity]
	  (
		  [RuleEntityId],
		  [RuleEntityName],
		  [RuleEntityDescription]
	  )

    SELECT 
		@RuleEntityId							AS [RuleEntityId],
		N'Охрана груза' 						AS [RuleEntityItemName],
		N'Столбцы "Охрана груза" шаблона НХТК'	AS [RuleEntityDescription]

INSERT INTO  [nkhtk].[RuleEntityItem]
	  (
		  [RuleEntityItemId],
		  [RuleEntityId], 
		  [RuleEntityItemName]
	  )


    SELECT
	    @RuleEntityId * 100 + 1	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'Охрана груза'			AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 2	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'Охрана груза.'		AS [RuleEntityItemName]

	UNION

	SELECT 
	    @RuleEntityId * 100 + 3	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 		 
		N'Охрана'				AS [RuleEntityItemName]

	UNION

	SELECT 
	    @RuleEntityId * 100 + 4	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 		 
		N'Охрана.'				AS [RuleEntityItemName]	

GO


------------------------------------------------

DECLARE @RuleEntityId int = 40003 -- Тариф Сахалин

INSERT INTO  [nkhtk].[RuleEntity]
	  (
		  [RuleEntityId],
		  [RuleEntityName],
		  [RuleEntityDescription]
	  )

    SELECT 
		@RuleEntityId,
		N'Тариф Сахалин',
		N'Столбцы "Тариф Сахалин"  шаблона НХТК - только для НБ-1 - МТБЭ Сахалин'	

INSERT INTO  [nkhtk].[RuleEntityItem]
	  (
		  [RuleEntityItemId],
		  [RuleEntityId], 
		  [RuleEntityItemName]
	  )


    SELECT
	    @RuleEntityId * 100 + 1	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'Тариф Сахалин'		AS [RuleEntityItemName]

GO

------------------------------------------------

DECLARE @RuleEntityId int = 40004 -- Вес груза, брутто, т

INSERT INTO  [nkhtk].[RuleEntity]
	  (
		  [RuleEntityId],
		  [RuleEntityName],
		  [RuleEntityDescription]
	  )

    SELECT 
		@RuleEntityId,
		N'Вес груза',
		N'Столбец "Вес груза, брутто, т" шаблонов НХТК - КАУЧУКи и ПЭ-ПП '	

INSERT INTO  [nkhtk].[RuleEntityItem]
	  (
		  [RuleEntityItemId],
		  [RuleEntityId], 
		  [RuleEntityItemName]
	  )


    SELECT
	    @RuleEntityId * 100 + 1	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'Вес груза, брутто, т'	AS [RuleEntityItemName]

GO


------------------------------------------------

DECLARE @RuleEntityId int = 80001 -- ВС со СЗ

INSERT INTO  [nkhtk].[RuleEntity]
	  (
		  [RuleEntityId],
		  [RuleEntityName],
		  [RuleEntityDescription]
	  )

    SELECT 
		@RuleEntityId,
		N'ВС со СЗ',
		N'Столбцы "ВС со СЗ" шаблона НХТК'		

INSERT INTO  [nkhtk].[RuleEntityItem]
	  (
		  [RuleEntityItemId],
		  [RuleEntityId], 
		  [RuleEntityItemName]
	  )


    SELECT
	    @RuleEntityId * 100 + 1	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'ВС со СЗ Реализация'	AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 2	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'ВС со СЗ'				AS [RuleEntityItemName]

GO


------------------------------------------------

DECLARE @RuleEntityId int = 80002 -- S, км

INSERT INTO  [nkhtk].[RuleEntity]
	  (
		  [RuleEntityId],
		  [RuleEntityName],
		  [RuleEntityDescription]
	  )

    SELECT 
		@RuleEntityId,
		N'S, км',
		N'Столбцы "S, км" шаблона НХТК'	

INSERT INTO  [nkhtk].[RuleEntityItem]
	  (
		  [RuleEntityItemId],
		  [RuleEntityId], 
		  [RuleEntityItemName]
	  )

    SELECT
	    @RuleEntityId * 100 + 1	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'S, км'				AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 2	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'S РФ, км'				AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 3	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'S всего, км'			AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 4	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'Общее расстояние , км.'			AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 4	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'Общее расстояние , км. '			AS [RuleEntityItemName]
		    
GO


------------------------------------------------

DECLARE @RuleEntityId int = 80003 -- Вагонная составляющая

INSERT INTO  [nkhtk].[RuleEntity]
	  (
		  [RuleEntityId],
		  [RuleEntityName],
		  [RuleEntityDescription]
	  )

    SELECT 
		@RuleEntityId,
		N'Вагонная составляющая',
		N'Столбцы "Вагонная составляющая" шаблона НХТК'

INSERT INTO  [nkhtk].[RuleEntityItem]
	  (
		  [RuleEntityItemId],
		  [RuleEntityId], 
		  [RuleEntityItemName]
	  )

    SELECT
	    @RuleEntityId * 100 + 1	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'ВС'					AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 2	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'ВС, руб/т'			AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 3	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'Вагонная составляющая'AS [RuleEntityItemName]
	UNION

	SELECT
	    @RuleEntityId * 100 + 4	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'Вагонная составляющая.'AS [RuleEntityItemName]
	UNION

	SELECT
	    @RuleEntityId * 100 + 5	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'Услуга'				AS [RuleEntityItemName]    
GO



------------------------------------------------

DECLARE @RuleEntityId int = 80004 -- Возврат

INSERT INTO  [nkhtk].[RuleEntity]
	  (
		  [RuleEntityId],
		  [RuleEntityName],
		  [RuleEntityDescription]
	  )

    SELECT 
		@RuleEntityId,
		N'Возврат',
		N'Столбцы "Возврат" и "Возврат по РЖД" шаблона НХТК'

INSERT INTO  [nkhtk].[RuleEntityItem]
	  (
		  [RuleEntityItemId],
		  [RuleEntityId], 
		  [RuleEntityItemName]
	  )

    SELECT
	    @RuleEntityId * 100 + 1	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'Возврат'					AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 2	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'Возврат по РЖД'			AS [RuleEntityItemName]

		    
GO
------------------------------------------------

DECLARE @RuleEntityId int = 120001 -- Рентабельность

INSERT INTO  [nkhtk].[RuleEntity]
	  (
		  [RuleEntityId],
		  [RuleEntityName],
		  [RuleEntityDescription]
	  )

    SELECT 
		@RuleEntityId,
		N'Рентабельность',
		N'Столбец "Рентабельность"  шаблона НХТК'

INSERT INTO  [nkhtk].[RuleEntityItem]
	  (
		  [RuleEntityItemId],
		  [RuleEntityId], 
		  [RuleEntityItemName]
	  )

    SELECT
	    @RuleEntityId * 100 + 1	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'Рентабельность'	AS [RuleEntityItemName]

		    
GO


------------------------------------------------

DECLARE @RuleEntityId int = 160001 -- ГО отправления

INSERT INTO  [nkhtk].[RuleEntity]
	  (
		  [RuleEntityId],
		  [RuleEntityName],
		  [RuleEntityDescription]
	  )

    SELECT 
		@RuleEntityId,
		N'ГО отправления',
		N'Столбцы "ГО отправления" или "ТЭ отправления" шаблона НХТК'	

INSERT INTO  [nkhtk].[RuleEntityItem]
	  (
		  [RuleEntityItemId],
		  [RuleEntityId], 
		  [RuleEntityItemName]
	  )

    SELECT
	    @RuleEntityId * 100 + 1	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'ТЭ отправ.'			AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 2	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'ГО отправ.'			AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 3	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'ТЭ отпр.'				AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 4	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'ГО отправления'		AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 5	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'ТЭ отправления'		AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 6	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'ТЭ'					AS [RuleEntityItemName]
GO



		
------------------------------------------------

DECLARE @RuleEntityId int = 180001 -- ПНП отправления

INSERT INTO  [nkhtk].[RuleEntity]
	  (
		  [RuleEntityId],
		  [RuleEntityName],
		  [RuleEntityDescription]
	  )

    SELECT 
		@RuleEntityId,
		N'ПНП отправления',
		N'Столбцы "ПНП отправления" шаблона НХТК'	

INSERT INTO  [nkhtk].[RuleEntityItem]
	  (
		  [RuleEntityItemId],
		  [RuleEntityId], 
		  [RuleEntityItemName]
	  )

    SELECT
	    @RuleEntityId * 100 + 1	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'ПНП отправ.'			AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 2	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'ПНП отправл.'			AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 3	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'ПНП отправления'				AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 4	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'ПНП'					AS [RuleEntityItemName]

GO


------------------------------------------------

DECLARE @RuleEntityId int = 200001 -- ГО назначения

INSERT INTO  [nkhtk].[RuleEntity]
	  (
		  [RuleEntityId],
		  [RuleEntityName],
		  [RuleEntityDescription]
	  )

    SELECT 
		@RuleEntityId,
		N'ГО назначения',
		N'Столбцы "ГО назначения" или "ТЭ назначения" шаблона НХТК'	

INSERT INTO  [nkhtk].[RuleEntityItem]
	  (
		  [RuleEntityItemId],
		  [RuleEntityId], 
		  [RuleEntityItemName]
	  )

    SELECT
	    @RuleEntityId * 100 + 1	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'ТЭ назнач.'			AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 2	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'ГО назнач.'			AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 3	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'ТЭ назн.'				AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 4	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'ГО назначения'		AS [RuleEntityItemName]

	 UNION

	SELECT
	    @RuleEntityId * 100 + 5	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'ТЭ назначения'		AS [RuleEntityItemName]	
GO
----------------------



DECLARE @RuleEntityId int = 220001 -- ПНП назначения

INSERT INTO  [nkhtk].[RuleEntity]
	  (
		  [RuleEntityId],
		  [RuleEntityName],
		  [RuleEntityDescription]
	  )

    SELECT 
		@RuleEntityId,
		N'ПНП назначения',
		N'Столбцы "ПНП назначения" шаблона НХТК'	

INSERT INTO  [nkhtk].[RuleEntityItem]
	  (
		  [RuleEntityItemId],
		  [RuleEntityId], 
		  [RuleEntityItemName]
	  )

    SELECT
	    @RuleEntityId * 100 + 1	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'ПНП назнач.'			AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 2	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'ПНП назначен.'		AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 3	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'ПНП назначения'		AS [RuleEntityItemName]

GO
----------------------




DECLARE @RuleEntityId int = 470001 -- Станция отправления

INSERT INTO  [nkhtk].[RuleEntity]
	  (
		  [RuleEntityId],
		  [RuleEntityName],
		  [RuleEntityDescription]
	  )

    SELECT 
		@RuleEntityId,
		N'Станция отправления',
		N'Столбцы "Станция отправления" шаблона НХТК'	

INSERT INTO  [nkhtk].[RuleEntityItem]
	  (
		  [RuleEntityItemId],
		  [RuleEntityId], 
		  [RuleEntityItemName]
	  )

    SELECT
	    @RuleEntityId * 100 + 1	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'Станция отправления'	AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 2	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'Ст. отправления'		AS [RuleEntityItemName]


GO
----------------------



DECLARE @RuleEntityId int = 480001 -- Станция назначения

INSERT INTO  [nkhtk].[RuleEntity]
	  (
		  [RuleEntityId],
		  [RuleEntityName],
		  [RuleEntityDescription]
	  )

    SELECT 
		@RuleEntityId,
		N'Станция назначения',
		N'Столбцы "Станция назначения" шаблона НХТК'	

INSERT INTO  [nkhtk].[RuleEntityItem]
	  (
		  [RuleEntityItemId],
		  [RuleEntityId], 
		  [RuleEntityItemName]
	  )

    SELECT
	    @RuleEntityId * 100 + 1	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'Станция назначения'	AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 2	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId],
		-- А тут английская буква C 
		N'Cтанция назначения'	AS [RuleEntityItemName]

	UNION
			SELECT
	    @RuleEntityId * 100 + 3	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'Ст. назначения'		AS [RuleEntityItemName]


GO
----------------------


DECLARE @RuleEntityId int = 510001 -- Загрузка

INSERT INTO  [nkhtk].[RuleEntity]
	  (
		  [RuleEntityId],
		  [RuleEntityName],
		  [RuleEntityDescription]
	  )

    SELECT 
		@RuleEntityId,
		N'Загрузка',
		N'Столбцы "Загрузка" или "Расчетный вес, т" шаблона НХТК'	

INSERT INTO  [nkhtk].[RuleEntityItem]
	  (
		  [RuleEntityItemId],
		  [RuleEntityId], 
		  [RuleEntityItemName]
	  )

    SELECT
	    @RuleEntityId * 100 + 1	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'загрузка'				AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 2	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId],
		N'Расчетный вес, т'		AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 3	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId],
		N'Загрузка, т'		AS [RuleEntityItemName]

	UNION

	SELECT
	    @RuleEntityId * 100 + 4	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId],
		N'Вес груза, брутто, т'		AS [RuleEntityItemName]

GO
----------------------



DECLARE @RuleEntityId int = 520001 -- Product

INSERT INTO  [nkhtk].[RuleEntity]
	  (
		  [RuleEntityId],
		  [RuleEntityName],
		  [RuleEntityDescription]
	  )

    SELECT 
		@RuleEntityId,
		N'Product',
		N'Столбцы "Product" шаблона СВТ (не НХТК)'	

INSERT INTO  [nkhtk].[RuleEntityItem]
	  (
		  [RuleEntityItemId],
		  [RuleEntityId], 
		  [RuleEntityItemName]
	  )

    SELECT
	    @RuleEntityId * 100 + 1	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'Product'				AS [RuleEntityItemName]



GO
----------------------



DECLARE @RuleEntityId int = 530001 -- Product

INSERT INTO  [nkhtk].[RuleEntity]
	  (
		  [RuleEntityId],
		  [RuleEntityName],
		  [RuleEntityDescription]
	  )

    SELECT 
		@RuleEntityId,
		N'Груз',
		N'Столбцы "Груз" шаблона НХТК'	

INSERT INTO  [nkhtk].[RuleEntityItem]
	  (
		  [RuleEntityItemId],
		  [RuleEntityId], 
		  [RuleEntityItemName]
	  )

    SELECT
	    @RuleEntityId * 100 + 1	AS [RuleEntityItemId],
		@RuleEntityId			AS [RuleEntityId], 
		N'Груз'				AS [RuleEntityItemName]



GO
----------------------

