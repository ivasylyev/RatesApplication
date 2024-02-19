USE [mdm_integ]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




BEGIN TRY

    DECLARE @LocalTran BIT = IIF(@@TRANCOUNT = 0, 1, 0)

    IF @LocalTran = 1
        BEGIN TRAN


	------------------------------------------------
	-- Номинация СВТ
	------------------------------------------------

	DECLARE @RuleEntityId int = 1340001 

	/* для отладки
	DELETE  [nkhtk].[RuleEntity]
	WHERE [RuleEntityId] = @RuleEntityId
	*/

	INSERT INTO  [nkhtk].[RuleEntity]
		  (
			  [RuleEntityId],
			  [RuleEntityName],
			  [RuleEntityDescription]
		  )


		SELECT 
			@RuleEntityId											AS [RuleEntityId],
			N'ММ Суша-Море Номинация СВТ'							AS [RuleEntityItemName],
			N'Столбцы "Номинация СВТ" или "%" шаблона ММ Суша-Море'	AS [RuleEntityDescription]
	
	INSERT INTO  [nkhtk].[RuleEntityItem]
		  (
			  [RuleEntityItemId],
			  [RuleEntityId], 
			  [RuleEntityItemName]
		  )


		SELECT
			@RuleEntityId * 100 + 1	AS [RuleEntityItemId],
			@RuleEntityId			AS [RuleEntityId], 
			N'Номинация СВТ'		AS [RuleEntityItemName]

		UNION

		SELECT 
			@RuleEntityId * 100 + 2	AS [RuleEntityItemId],
			@RuleEntityId			AS [RuleEntityId], 		 
			N'%'					AS [RuleEntityItemName]
	


	------------------------------------------------
	-- Контрагент
	------------------------------------------------

	SET @RuleEntityId = 1350001 

	/* для отладки
	DELETE  [nkhtk].[RuleEntity]
	WHERE [RuleEntityId] = @RuleEntityId
	*/

	INSERT INTO  [nkhtk].[RuleEntity]
		  (
			  [RuleEntityId],
			  [RuleEntityName],
			  [RuleEntityDescription]
		  )


		SELECT 
			@RuleEntityId										AS [RuleEntityId],
			N'ММ Суша-Море Контрагент'							AS [RuleEntityItemName],
			N'Столбцы "Код контрагента" или "Код КА" шаблона ММ Суша-Море'	AS [RuleEntityDescription]
	
	INSERT INTO  [nkhtk].[RuleEntityItem]
		  (
			  [RuleEntityItemId],
			  [RuleEntityId], 
			  [RuleEntityItemName]
		  )


		SELECT
			@RuleEntityId * 100 + 1	AS [RuleEntityItemId],
			@RuleEntityId			AS [RuleEntityId], 
			N'Код контрагента'		AS [RuleEntityItemName]

		UNION

		SELECT 
			@RuleEntityId * 100 + 2	AS [RuleEntityItemId],
			@RuleEntityId			AS [RuleEntityId], 		 
			N'Код КА'				AS [RuleEntityItemName]
	




	------------------------------------------------
	-- Матрица
	------------------------------------------------

	SET @RuleEntityId = 1360001 

	/* для отладки
	DELETE  [nkhtk].[RuleEntity]
	WHERE [RuleEntityId] = @RuleEntityId
	*/

	INSERT INTO  [nkhtk].[RuleEntity]
		  (
			  [RuleEntityId],
			  [RuleEntityName],
			  [RuleEntityDescription]
		  )


		SELECT 
			@RuleEntityId								AS [RuleEntityId],
			N'ММ Суша-Море Матрица'						AS [RuleEntityItemName],
			N'Столбец "Матрица" шаблона ММ Суша-Море'	AS [RuleEntityDescription]
	
	INSERT INTO  [nkhtk].[RuleEntityItem]
		  (
			  [RuleEntityItemId],
			  [RuleEntityId], 
			  [RuleEntityItemName]
		  )


		SELECT
			@RuleEntityId * 100 + 1	AS [RuleEntityItemId],
			@RuleEntityId			AS [RuleEntityId], 
			N'Матрица'		AS [RuleEntityItemName]

	



	------------------------------------------------
	-- Описание строки
	------------------------------------------------

	SET @RuleEntityId = 1360002 

	/* для отладки
	DELETE  [nkhtk].[RuleEntity]
	WHERE [RuleEntityId] = @RuleEntityId
	*/

	INSERT INTO  [nkhtk].[RuleEntity]
		  (
			  [RuleEntityId],
			  [RuleEntityName],
			  [RuleEntityDescription]
		  )


		SELECT 
			@RuleEntityId								AS [RuleEntityId],
			N'ММ Суша-Море Описание строки'						AS [RuleEntityItemName],
			N'Столбец "Описание строки" шаблона ММ Суша-Море'	AS [RuleEntityDescription]
	
	INSERT INTO  [nkhtk].[RuleEntityItem]
		  (
			  [RuleEntityItemId],
			  [RuleEntityId], 
			  [RuleEntityItemName]
		  )


		SELECT
			@RuleEntityId * 100 + 1	AS [RuleEntityItemId],
			@RuleEntityId			AS [RuleEntityId], 
			N'Описание строки'		AS [RuleEntityItemName]

	



	------------------------------------------------
	-- Узел отправления - первое плечо
	------------------------------------------------

	SET @RuleEntityId = 1460001 

	/* для отладки
	DELETE  [nkhtk].[RuleEntity]
	WHERE [RuleEntityId] = @RuleEntityId
	*/

	INSERT INTO  [nkhtk].[RuleEntity]
		  (
			  [RuleEntityId],
			  [RuleEntityName],
			  [RuleEntityDescription]
		  )


		SELECT 
			@RuleEntityId										AS [RuleEntityId],
			N'ММ Суша-Море Узел отправления'					AS [RuleEntityItemName],
			N'Столбец "Узел отправления" шаблона ММ Суша-Море'	AS [RuleEntityDescription]
	
	INSERT INTO  [nkhtk].[RuleEntityItem]
		  (
			  [RuleEntityItemId],
			  [RuleEntityId], 
			  [RuleEntityItemName]
		  )


		SELECT
			@RuleEntityId * 100 + 1	AS [RuleEntityItemId],
			@RuleEntityId			AS [RuleEntityId], 
			N'Узел отправления'		AS [RuleEntityItemName]

	




	------------------------------------------------
	-- Узел отправления - второе плечо, он же узел назначения первого плеча
	------------------------------------------------

	SET @RuleEntityId= 1460002 

	/* для отладки
	DELETE  [nkhtk].[RuleEntity]
	WHERE [RuleEntityId] = @RuleEntityId
	*/

	INSERT INTO  [nkhtk].[RuleEntity]
		  (
			  [RuleEntityId],
			  [RuleEntityName],
			  [RuleEntityDescription]
		  )


		SELECT 
			@RuleEntityId										AS [RuleEntityId],
			N'ММ Суша-Море КОД  порта отправления'					AS [RuleEntityItemName],
			N'Столбец "КОД  порта отправления" шаблона ММ Суша-Море'	AS [RuleEntityDescription]
	
	INSERT INTO  [nkhtk].[RuleEntityItem]
		  (
			  [RuleEntityItemId],
			  [RuleEntityId], 
			  [RuleEntityItemName]
		  )


		SELECT
			@RuleEntityId * 100 + 1	AS [RuleEntityItemId],
			@RuleEntityId			AS [RuleEntityId], 
			N'КОД  порта отправления'		AS [RuleEntityItemName]

	



	------------------------------------------------
	-- Узел назначения - второе плечо
	------------------------------------------------

	SET @RuleEntityId = 1470001

	/* для отладки
	DELETE  [nkhtk].[RuleEntity]
	WHERE [RuleEntityId] = @RuleEntityId
	*/

	INSERT INTO  [nkhtk].[RuleEntity]
		  (
			  [RuleEntityId],
			  [RuleEntityName],
			  [RuleEntityDescription]
		  )
		SELECT 
			@RuleEntityId										AS [RuleEntityId],
			N'ММ Суша-Море Узел назначения'					AS [RuleEntityItemName],
			N'Столбец "Узел назначения" шаблона ММ Суша-Море'	AS [RuleEntityDescription]
	
	INSERT INTO  [nkhtk].[RuleEntityItem]
		  (
			  [RuleEntityItemId],
			  [RuleEntityId], 
			  [RuleEntityItemName]
		  )
		SELECT
			@RuleEntityId * 100 + 1	AS [RuleEntityItemId],
			@RuleEntityId			AS [RuleEntityId], 
			N'Узел назначения'		AS [RuleEntityItemName]

	




	------------------------------------------------
	-- TotalCostTransport  Стоимость  ЖД перевозки по территории РФ включая все расходы  Перевозчика.в USD/ктк (Цена) (Цена)
	-- первое плечо
	------------------------------------------------

	SET @RuleEntityId = 1560001

	/* для отладки
	DELETE  [nkhtk].[RuleEntity]
	WHERE [RuleEntityId] = @RuleEntityId
	*/

	INSERT INTO  [nkhtk].[RuleEntity]
		  (
			  [RuleEntityId],
			  [RuleEntityName],
			  [RuleEntityDescription]
		  )
		SELECT 
			@RuleEntityId										AS [RuleEntityId],
			N'ММ Суша-Море Стоимость  ЖД перевозки по территории РФ включая все расходы  Перевозчика.в USD/ктк (Цена) (Цена)'					AS [RuleEntityItemName],
			N'Столбец "Стоимость  ЖД перевозки по территории РФ включая все расходы  Перевозчика.в USD/ктк (Цена) (Цена)" шаблона ММ Суша-Море'	AS [RuleEntityDescription]
	
	INSERT INTO  [nkhtk].[RuleEntityItem]
		  (
			  [RuleEntityItemId],
			  [RuleEntityId], 
			  [RuleEntityItemName]
		  )
		SELECT
			@RuleEntityId * 100 + 1	AS [RuleEntityItemId],
			@RuleEntityId			AS [RuleEntityId], 
			N'Стоимость  ЖД перевозки по территории РФ включая все расходы  Перевозчика.в USD/ктк (Цена) (Цена)'		AS [RuleEntityItemName]





	------------------------------------------------
	-- TotalCostTransport  Стоимость  ЖД перевозки по территории РФ включая все расходы  Перевозчика.в USD/ктк (Цена) (Цена)
	-- второе плечо
	------------------------------------------------

	SET @RuleEntityId = 1560002

	/* для отладки
	DELETE  [nkhtk].[RuleEntity]
	WHERE [RuleEntityId] = @RuleEntityId
	*/

	INSERT INTO  [nkhtk].[RuleEntity]
		  (
			  [RuleEntityId],
			  [RuleEntityName],
			  [RuleEntityDescription]
		  )
		SELECT 
			@RuleEntityId										AS [RuleEntityId],
			N'ММ Суша-Море Стоимость морской перевозки, включая экспедирование в порту РФ, USD/ктк (Цена) (Цена)'					AS [RuleEntityItemName],
			N'Столбец "Стоимость морской перевозки, включая экспедирование в порту РФ, USD/ктк (Цена) (Цена)" шаблона ММ Суша-Море'	AS [RuleEntityDescription]
	
	INSERT INTO  [nkhtk].[RuleEntityItem]
		  (
			  [RuleEntityItemId],
			  [RuleEntityId], 
			  [RuleEntityItemName]
		  )
		SELECT
			@RuleEntityId * 100 + 1	AS [RuleEntityItemId],
			@RuleEntityId			AS [RuleEntityId], 
			N'Стоимость морской перевозки, включая экспедирование в порту РФ, USD/ктк (Цена) (Цена)'		AS [RuleEntityItemName]

	


	
	------------------------------------------------
	-- TotalCostTransport  
	-- для копирования из одной колонки СВТ в другую
	------------------------------------------------

	SET @RuleEntityId = 1140001

	/* для отладки
	DELETE  [nkhtk].[RuleEntity]
	WHERE [RuleEntityId] = @RuleEntityId
	*/

	INSERT INTO  [nkhtk].[RuleEntity]
		  (
			  [RuleEntityId],
			  [RuleEntityName],
			  [RuleEntityDescription]
		  )
		SELECT 
			@RuleEntityId										AS [RuleEntityId],
			N'ММ Суша-Море TotalCostTransport'					AS [RuleEntityItemName],
			N'Столбец "TotalCostTransport" шаблона СВТ для ММ Суша-Море'	AS [RuleEntityDescription]
	
	INSERT INTO  [nkhtk].[RuleEntityItem]
		  (
			  [RuleEntityItemId],
			  [RuleEntityId], 
			  [RuleEntityItemName]
		  )
		SELECT
			@RuleEntityId * 100 + 1	AS [RuleEntityItemId],
			@RuleEntityId			AS [RuleEntityId], 
			N'TotalCostTransport'		AS [RuleEntityItemName]


------------------------------------------------
	-- EffectiveLoadOfTransportType  
	-- для копирования из одной колонки СВТ в другую
	------------------------------------------------

	SET @RuleEntityId = 1140002

	/* для отладки
	DELETE  [nkhtk].[RuleEntity]
	WHERE [RuleEntityId] = @RuleEntityId
	*/

	INSERT INTO  [nkhtk].[RuleEntity]
		  (
			  [RuleEntityId],
			  [RuleEntityName],
			  [RuleEntityDescription]
		  )
		SELECT 
			@RuleEntityId										AS [RuleEntityId],
			N'ММ Суша-Море EffectiveLoadOfTransportType'					AS [RuleEntityItemName],
			N'Столбец "EffectiveLoadOfTransportType" шаблона СВТ для ММ Суша-Море'	AS [RuleEntityDescription]
	
	INSERT INTO  [nkhtk].[RuleEntityItem]
		  (
			  [RuleEntityItemId],
			  [RuleEntityId], 
			  [RuleEntityItemName]
		  )
		SELECT
			@RuleEntityId * 100 + 1	AS [RuleEntityItemId],
			@RuleEntityId			AS [RuleEntityId], 
			N'EffectiveLoadOfTransportType'		AS [RuleEntityItemName]




------------------------------------------------
	-- Basis  
	-- для копирования из одной колонки СВТ в другую
	------------------------------------------------

	SET @RuleEntityId = 1120002

	/* для отладки
	DELETE  [nkhtk].[RuleEntity]
	WHERE [RuleEntityId] = @RuleEntityId
	*/

	INSERT INTO  [nkhtk].[RuleEntity]
		  (
			  [RuleEntityId],
			  [RuleEntityName],
			  [RuleEntityDescription]
		  )
		SELECT 
			@RuleEntityId										AS [RuleEntityId],
			N'ММ Суша-Море Basis'					AS [RuleEntityItemName],
			N'Столбец "Basis" шаблона СВТ для ММ Суша-Море'	AS [RuleEntityDescription]
	
	INSERT INTO  [nkhtk].[RuleEntityItem]
		  (
			  [RuleEntityItemId],
			  [RuleEntityId], 
			  [RuleEntityItemName]
		  )
		SELECT
			@RuleEntityId * 100 + 1	AS [RuleEntityItemId],
			@RuleEntityId			AS [RuleEntityId], 
			N'Basis'		AS [RuleEntityItemName]

			
  

    IF @LocalTran = 1 AND XACT_STATE() = 1
        COMMIT TRAN

END TRY

BEGIN CATCH

DECLARE
    @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE() + ISNULL(', PROC: ' + ERROR_PROCEDURE(), '') + ', LINE: ' + CAST(ERROR_LINE() AS VARCHAR(10)),
    @ErrorSeverity INT = ERROR_SEVERITY(),
    @ErrorState INT = ERROR_STATE()

IF @LocalTran = 1 AND XACT_STATE() <> 0
    ROLLBACK TRAN

RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH