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
	-- 34  - Nomination -- Номинация
	------------------------------------------------

	DECLARE @RuleDictionaryId int = 23401 -- 34  - Nomination -- Номинация

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId					AS [RuleDictionaryId],
			N'ММ Суша-Суша Номинация 0'					AS [RuleDictionaryItemName],
			N'Словарь для замены пустых значений на ноль в колонке Номинация'		AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 13000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],		
			N''					AS [SourceValue],  
			N'0'				AS [DestinationValue]


	------------------------------------------------
	-- ТС
	------------------------------------------------

	SET @RuleDictionaryId = 24401 -- ТС

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId					AS [RuleDictionaryId],
			N'ММ Суша-Суша ТС'					AS [RuleDictionaryItemName],
			N'Словарь с константой "ТС"'		AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 13000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL				AS [SourceValue],  
			N'ТС'				AS [DestinationValue]

	 


	--------------------------------------------------------------------------------------------
	--  RateType -- Тип ставки
	--------------------------------------------------------------------------------------------

	SET @RuleDictionaryId = 24501 -- 2

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId					AS [RuleDictionaryId],
			N'ММ Суша-Суша 2'					AS [RuleDictionaryItemName],
			N'Словарь с константой "2"'			AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )

		  
		SELECT
			@RuleDictionaryId * 13000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL				AS [SourceValue],  
			N'2'				AS [DestinationValue]

	 


	------------------------------------------------
	-- Mix
	------------------------------------------------

	SET @RuleDictionaryId = 24801 -- Mix

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId					AS [RuleDictionaryId],
			N'ММ Суша-Суша Mix'					AS [RuleDictionaryItemName],
			N'Словарь с константой "Mix"'		AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 13000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL				AS [SourceValue],  
			N'Mix'				AS [DestinationValue]

	 


	------------------------------------------------
	-- mix_40
	------------------------------------------------

	SET @RuleDictionaryId = 24901 -- mix_40

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId					AS [RuleDictionaryId],
			N'ММ Суша-Суша Mix_40'				AS [RuleDictionaryItemName],
			N'Словарь с константой "Mix_40"'	AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 13000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL				AS [SourceValue],  
			N'Mix_40'			AS [DestinationValue]

	 



	 



	------------------------------------------------
	-- Словарь с названием параметра EffectiveLoadOfTransportType, который передается со стороны клиента
	------------------------------------------------


	SET @RuleDictionaryId = 25001 -- EffectiveLoadOfTransportType

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId												AS [RuleDictionaryId],
			N'ММ Суша-Суша EffectiveLoadOfTransportType'									AS [RuleDictionaryItemName],
			N'Словарь с названием параметра EffectiveLoadOfTransportType  для ММ Суша-Суша'	AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 13000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId				AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL							AS [SourceValue],  
			N'EffectiveLoadOfTransportType'	AS [DestinationValue]

	 



	------------------------------------------------
	-- Словарь с названием параметра ProductGroup, который передается со стороны клиента
	------------------------------------------------


	SET @RuleDictionaryId = 25101 -- ProductGroup

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId								AS [RuleDictionaryId],
			N'ММ Суша-Суша ProductGroup'									AS [RuleDictionaryItemName],
			N'Словарь с названием параметра ProductGroup для ММ Суша-Суша'	AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 13000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId				AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL							AS [SourceValue],  
			N'ProductGroup'					AS [DestinationValue]

	 



	------------------------------------------------
	-- Словарь с названием параметра Product, который передается со стороны клиента
	------------------------------------------------


	SET @RuleDictionaryId = 25201 -- Product

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId							AS [RuleDictionaryId],
			N'ММ Суша-Суша Product'									AS [RuleDictionaryItemName],
			N'Словарь с названием параметра Product для ММ Суша-Суша'	AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 13000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId				AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL							AS [SourceValue],  
			N'Product'						AS [DestinationValue]

	 


	------------------------------------------------
	-- Словарь с названием параметра StartDate, который передается со стороны клиента
	------------------------------------------------


	SET @RuleDictionaryId = 25301 -- StartDate

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId												AS [RuleDictionaryId],
			N'ММ Суша-Суша StartDate'										AS [RuleDictionaryItemName],
			N'Словарь с названием параметра StartDate  для ММ Суша-Суша'	AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 13000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL				AS [SourceValue],  
			N'StartDate'			AS [DestinationValue]

	 


	------------------------------------------------
	-- Словарь с названием параметра EndDate, который передается со стороны клиента
	------------------------------------------------


	SET @RuleDictionaryId = 25401 -- EndDate

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId											AS [RuleDictionaryId],
			N'ММ Суша-Суша EndDate'										AS [RuleDictionaryItemName],
			N'Словарь с названием параметра EndDate  для ММ Суша-Суша'	AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 13000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL				AS [SourceValue],  
			N'EndDate'			AS [DestinationValue]





	--------------------------------------------------------------------------------------------
	--  TotalCostTransport -
	--------------------------------------------------------------------------------------------

	SET @RuleDictionaryId = 25605 -- 

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId								AS [RuleDictionaryId],
			N'ММ Суша-Суша 9'								AS [RuleDictionaryItemName],
			N'Словарь с заменой девяток на "нет данных"'	AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 13000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			N'9'				AS [SourceValue],  
			N'[Нет данных]'		AS [DestinationValue]
	UNION
		SELECT
			@RuleDictionaryId * 13000 + 2	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			N'99'				AS [SourceValue],  
			N'[Нет данных]'		AS [DestinationValue]
	UNION
		SELECT
			@RuleDictionaryId * 13000 + 3	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			N'999'				AS [SourceValue],  
			N'[Нет данных]'		AS [DestinationValue]
	UNION
		SELECT
			@RuleDictionaryId * 13000 + 4	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			N'9999'				AS [SourceValue],  
			N'[Нет данных]'		AS [DestinationValue]
	UNION
		SELECT
			@RuleDictionaryId * 13000 + 5	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			N'99999'			AS [SourceValue],  
			N'[Нет данных]'		AS [DestinationValue]
	UNION
		SELECT
			@RuleDictionaryId * 13000 + 6	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			N'999999'			AS [SourceValue],  
			N'[Нет данных]'		AS [DestinationValue]

	UNION
		SELECT
			@RuleDictionaryId * 13000 + 7	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			N'9999999'			AS [SourceValue],  
			N'[Нет данных]'		AS [DestinationValue]

	UNION
		SELECT
			@RuleDictionaryId * 13000 + 8	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			N'99999999'			AS [SourceValue],  
			N'[Нет данных]'		AS [DestinationValue]

	UNION
		SELECT
			@RuleDictionaryId * 13000 + 9	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			N'999999999'		AS [SourceValue],  
			N'[Нет данных]'		AS [DestinationValue]

	UNION
		SELECT
			@RuleDictionaryId * 13000 + 10	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			N'9999999999'		AS [SourceValue],  
			N'[Нет данных]'		AS [DestinationValue]

	UNION
		SELECT
			@RuleDictionaryId * 13000 + 11	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			N'99999999999'		AS [SourceValue],  
			N'[Нет данных]'		AS [DestinationValue]


	UNION
		SELECT
			@RuleDictionaryId * 13000 + 12	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			N'999999999999'		AS [SourceValue],  
			N'[Нет данных]'		AS [DestinationValue]


	------------------------------------------------
	-- Словарь c промежуточными узлами NodeFrom
	------------------------------------------------

	SET @RuleDictionaryId = 20401 --   (Начальная точка) Узел отправления
	IF NOT EXISTS  (SELECT * FROM [nkhtk].[RuleDictionary] WHERE [RuleDictionaryName] = N'ММ Суша-Суша Узел отправления')
	BEGIN
		INSERT INTO  [nkhtk].[RuleDictionary]
			  (
				  [RuleDictionaryId],
				  [RuleDictionaryName],
				  [RuleDictionaryDescription]
			  )

			SELECT 
				@RuleDictionaryId,
				N'ММ Суша-Суша Промежуточный узел',
				N'Словарь с зависимостью  промежуточных узлов из справочника мультимодальных узлов и "Метсоположения-узлы" для ММ Суша-Суша'
		
	
		INSERT INTO  [nkhtk].[RuleDictionaryItem]
			  (
				  [RuleDictionaryItemId],
				  [RuleDictionaryId], 
				  [SourceValue],
				  [DestinationValue]
			  )

		 SELECT
		 [RuleDictionaryItemId] = @RuleDictionaryId * 13000 + ROW_NUMBER() OVER(ORDER BY N.SourceValue ASC),
		 [RuleDictionaryId] = @RuleDictionaryId,
		 N.[SourceValue],
		 N.[DestinationValue]

		 from
		 (
			SELECT 
				[SourceValue] = CAST (ln.[Code] AS nvarchar(max)),
				[DestinationValue] = CAST (mmn.[Code] AS nvarchar(max))
			FROM [mdm].[dbo].[vw_MultiModal_Node]  mmn
			INNER JOIN mdm.dbo.vw_MultiModal_NodeCategory nc
				ON nc.Id = mmn.NodeCategoryCode
			INNER JOIN mdm.dbo.vw_LocationsNodes ln
				ON ln.Id = mmn.NodeCode
			WHERE ln.PrimitiveEntityDataStateId = 1
			AND mmn.PrimitiveEntityDataStateId = 1
			AND nc.PrimitiveEntityDataStateId = 1
			AND nc.Code = N'Transit'
		 ) AS N

	END


	
	------------------------------------------------
	-- Словарь со стартовыми узлами StartNode
	------------------------------------------------

	SET @RuleDictionaryId = 20505 --  Узел отправления
	IF NOT EXISTS  (SELECT * FROM [nkhtk].[RuleDictionary] WHERE [RuleDictionaryName] = N'ММ Суша-Суша Узел отправления')
	BEGIN
		INSERT INTO  [nkhtk].[RuleDictionary]
			  (
				  [RuleDictionaryId],
				  [RuleDictionaryName],
				  [RuleDictionaryDescription]
			  )

			SELECT 
				@RuleDictionaryId,
				N'ММ Суша-Суша Узел отправления',
				N'Словарь с зависимостью "Узел отправления"из справочника мультимодальных узлов и "Метсоположения-узлы" для ММ Суша-Суша'

		
	
		INSERT INTO  [nkhtk].[RuleDictionaryItem]
			  (
				  [RuleDictionaryItemId],
				  [RuleDictionaryId], 
				  [SourceValue],
				  [DestinationValue]
			  )

		 SELECT
		 [RuleDictionaryItemId] = @RuleDictionaryId * 13000 + ROW_NUMBER() OVER(ORDER BY N.SourceValue ASC),
		 [RuleDictionaryId] = @RuleDictionaryId,
		 N.[SourceValue],
		 N.[DestinationValue]

		 from
		 (
			SELECT 
				[SourceValue] = CAST (ln.[Code] AS nvarchar(max)),
				[DestinationValue] = CAST (mmn.[Code] AS nvarchar(max))
			FROM [mdm].[dbo].[vw_MultiModal_Node]  mmn
			INNER JOIN mdm.dbo.vw_MultiModal_NodeCategory nc
				ON nc.Id = mmn.NodeCategoryCode
			INNER JOIN mdm.dbo.vw_LocationsNodes ln
				ON ln.Id = mmn.NodeCode
			WHERE ln.PrimitiveEntityDataStateId = 1
			AND mmn.PrimitiveEntityDataStateId = 1
			AND nc.PrimitiveEntityDataStateId = 1
			AND nc.Code = N'Start'
		 ) AS N

	END



	------------------------------------------------
	-- Словарь  для параметра GeneralCurrency
	------------------------------------------------

	SET @RuleDictionaryId = 25701 -- RUB

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId								AS [RuleDictionaryId],
			N'ММ Суша-Суша GeneralCurrency'					AS [RuleDictionaryItemName],
			N'Словарь с названием параметра для валюты RUB'	AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 13000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL				AS [SourceValue],  
			N'GeneralCurrency'	AS [DestinationValue]



	------------------------------------------------
	-- Словарь с константами для операции вставки нового значения
	------------------------------------------------

	SET @RuleDictionaryId = 25801 -- 1

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId												AS [RuleDictionaryId],
			N'ММ Суша-Суша stg_Operation_1'									AS [RuleDictionaryItemName],
			N'Словарь с константами для операции вставки нового значения'	AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


    SELECT
	    @RuleDictionaryId * 13000 + 1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'1'				AS [DestinationValue]



		


			


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
