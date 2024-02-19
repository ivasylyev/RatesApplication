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

	DECLARE @RuleEntityId int = 2340001 

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
			N'ММ Суша-Суша Номинация'					AS [RuleEntityItemName],
			N'Столбец "Номинация" шаблона ММ Суша-Суша'	AS [RuleEntityDescription]
	
	INSERT INTO  [nkhtk].[RuleEntityItem]
		  (
			  [RuleEntityItemId],
			  [RuleEntityId], 
			  [RuleEntityItemName]
		  )


		SELECT
			@RuleEntityId * 100 + 1	AS [RuleEntityItemId],
			@RuleEntityId			AS [RuleEntityId], 
			N'Номинация'			AS [RuleEntityItemName]

		

	
	------------------------------------------------
	-- Контрагент
	------------------------------------------------

	SET @RuleEntityId = 2350001 

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
			N'ММ Суша-Суша Номер КА'					AS [RuleEntityItemName],
			N'Столбец "Номер КА" шаблона ММ Суша-Суша'	AS [RuleEntityDescription]
	
	INSERT INTO  [nkhtk].[RuleEntityItem]
		  (
			  [RuleEntityItemId],
			  [RuleEntityId], 
			  [RuleEntityItemName]
		  )

		SELECT
			@RuleEntityId * 100 + 1	AS [RuleEntityItemId],
			@RuleEntityId			AS [RuleEntityId], 
			N'Номер КА'				AS [RuleEntityItemName]

		



	------------------------------------------------
	-- Пакет услуг
	------------------------------------------------

	SET @RuleEntityId = 2360001 

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
			N'ММ Суша-Суша Пакет услуг'						AS [RuleEntityItemName],
			N'Столбец "Пакет услуг" шаблона ММ Суша-Суша'	AS [RuleEntityDescription]
	
	INSERT INTO  [nkhtk].[RuleEntityItem]
		  (
			  [RuleEntityItemId],
			  [RuleEntityId], 
			  [RuleEntityItemName]
		  )


		SELECT
			@RuleEntityId * 100 + 1	AS [RuleEntityItemId],
			@RuleEntityId			AS [RuleEntityId], 
			N'Пакет услуг'				AS [RuleEntityItemName]

	



	------------------------------------------------
	-- Описание строки
	------------------------------------------------

	SET @RuleEntityId = 2360002 

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
			N'ММ Суша-Суша Описание строки'						AS [RuleEntityItemName],
			N'Столбец "Описание строки" шаблона ММ Суша-Суша'	AS [RuleEntityDescription]
	
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
	-- Узел отправления 
	------------------------------------------------

	SET @RuleEntityId = 2460001 

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
			N'ММ Суша-Суша Узел отправления'					AS [RuleEntityItemName],
			N'Столбец "Узел отправления" шаблона ММ Суша-Суша'	AS [RuleEntityDescription]
	
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
	-- Узел назначения 
	------------------------------------------------

	SET @RuleEntityId = 2470001

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
			N'ММ Суша-Суша Узел назначения'					AS [RuleEntityItemName],
			N'Столбец "Узел назначения" шаблона ММ Суша-Суша'	AS [RuleEntityDescription]
	
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
	-- TotalCostTransport -   Total rate, including 7 days of free storage, usd (Цена)
	
	------------------------------------------------

	SET @RuleEntityId = 2560001

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
			N'ММ Суша-Суша Total rate, including 7 days of free storage, usd (Цена)'					AS [RuleEntityItemName],
			N'Столбец "Total rate, including 7 days of free storage, usd (Цена)'	AS [RuleEntityDescription]
	
	INSERT INTO  [nkhtk].[RuleEntityItem]
		  (
			  [RuleEntityItemId],
			  [RuleEntityId], 
			  [RuleEntityItemName]
		  )
		SELECT
			@RuleEntityId * 100 + 1	AS [RuleEntityItemId],
			@RuleEntityId			AS [RuleEntityId], 
			N'Total rate, including 7 days of free storage, usd (Цена)'		AS [RuleEntityItemName]






------------------------------------------------
	-- EffectiveLoadOfTransportType  
	-- для копирования из одной колонки СВТ в другую
	------------------------------------------------

	SET @RuleEntityId = 2500002

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
			N'ММ Суша-Суша EffectiveLoadOfTransportType'					AS [RuleEntityItemName],
			N'Столбец "EffectiveLoadOfTransportType" шаблона СВТ для ММ Суша-Суша'	AS [RuleEntityDescription]
	
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