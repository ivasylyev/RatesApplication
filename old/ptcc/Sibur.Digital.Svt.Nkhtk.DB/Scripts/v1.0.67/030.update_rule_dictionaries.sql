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
  

    IF @LocalTran = 1 AND XACT_STATE() = 1
        COMMIT TRAN




	--------------------------------------------------------------------------------------------
	--  RateTenderServicePack -- Пакет услуг
	--------------------------------------------------------------------------------------------

	DECLARE @RuleDictionaryId INT = 13601 -- "_"

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId					AS [RuleDictionaryId],
			N'ММ Суша-Море _'					AS [RuleDictionaryItemName],
			N'Словарь с константой "_"'			AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL				AS [SourceValue],  
			N'_'				AS [DestinationValue]



	------------------------------------------------
	-- ТС
	------------------------------------------------

	SET @RuleDictionaryId = 14401 -- ТС

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId					AS [RuleDictionaryId],
			N'ММ Суша-Море ТС'					AS [RuleDictionaryItemName],
			N'Словарь с константой "ТС"'		AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL				AS [SourceValue],  
			N'ТС'				AS [DestinationValue]

	 


	--------------------------------------------------------------------------------------------
	--  RateType -- Тип ставки
	--------------------------------------------------------------------------------------------

	SET @RuleDictionaryId = 14501 -- 2

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId					AS [RuleDictionaryId],
			N'ММ Суша-Море 2'					AS [RuleDictionaryItemName],
			N'Словарь с константой "2"'			AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL				AS [SourceValue],  
			N'2'				AS [DestinationValue]

	 


	--------------------------------------------------------------------------------------------
	--   Мультипликатор, который просто дублирует все записи.
	--------------------------------------------------------------------------------------------

	SET @RuleDictionaryId = 14511 

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId								AS [RuleDictionaryId],
			N'ММ Суша-Море Мультипликатор'					AS [RuleDictionaryItemName],
			N'Словарь с двумя пустыми константами для работы мультипликатора всех записей'			AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL				AS [SourceValue],
			-- пустое значение т.к. при работе мультипликтора не надо вставлять новые значения, а надо 
			''				AS [DestinationValue]
		UNION 
			 SELECT
			@RuleDictionaryId * 100000 + 2	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL				AS [SourceValue],
			-- пустое значение т.к. при работе мультипликтора не надо вставлять новые значения, а надо просто "размножить" существующие строки
			''				AS [DestinationValue]

	 



	------------------------------------------------
	-- Mix
	------------------------------------------------

	SET @RuleDictionaryId = 14801 -- Mix

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId					AS [RuleDictionaryId],
			N'ММ Суша-Море Mix'					AS [RuleDictionaryItemName],
			N'Словарь с константой "Mix"'		AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL				AS [SourceValue],  
			N'Mix'				AS [DestinationValue]

	 


	------------------------------------------------
	-- mix_rail_cont_40
	------------------------------------------------

	SET @RuleDictionaryId = 14901 -- mix_rail_cont_40

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId					AS [RuleDictionaryId],
			N'ММ Суша-Море mix_rail_cont_40'					AS [RuleDictionaryItemName],
			N'Словарь с константой "mix_rail_cont_40"'		AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL				AS [SourceValue],  
			N'mix_rail_cont_40'				AS [DestinationValue]

	 



	------------------------------------------------
	-- mix_sea
	------------------------------------------------

	SET @RuleDictionaryId = 14902 -- mix_sea

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId					AS [RuleDictionaryId],
			N'ММ Суша-Море mix_sea'					AS [RuleDictionaryItemName],
			N'Словарь с константой "mix_sea"'		AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL				AS [SourceValue],  
			N'mix_sea'				AS [DestinationValue]

	 



	------------------------------------------------
	-- Словарь с названием параметра EffectiveLoadOfTransportType, который передается со стороны клиента
	------------------------------------------------


	SET @RuleDictionaryId = 15001 -- EffectiveLoadOfTransportType

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId												AS [RuleDictionaryId],
			N'ММ Суша-Море EffectiveLoadOfTransportType'									AS [RuleDictionaryItemName],
			N'Словарь с названием параметра EffectiveLoadOfTransportType  для ММ Суша-Море'	AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId				AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL							AS [SourceValue],  
			N'EffectiveLoadOfTransportType'	AS [DestinationValue]

	 



	------------------------------------------------
	-- Словарь с названием параметра ProductGroup, который передается со стороны клиента
	------------------------------------------------


	SET @RuleDictionaryId = 15101 -- ProductGroup

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId								AS [RuleDictionaryId],
			N'ММ Суша-Море ProductGroup'									AS [RuleDictionaryItemName],
			N'Словарь с названием параметра ProductGroup для ММ Суша-Море'	AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId				AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL							AS [SourceValue],  
			N'ProductGroup'					AS [DestinationValue]

	 



	------------------------------------------------
	-- Словарь с названием параметра Product, который передается со стороны клиента
	------------------------------------------------


	SET @RuleDictionaryId = 15201 -- Product

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId							AS [RuleDictionaryId],
			N'ММ Суша-Море Product'									AS [RuleDictionaryItemName],
			N'Словарь с названием параметра Product для ММ Суша-Море'	AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId				AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL							AS [SourceValue],  
			N'Product'						AS [DestinationValue]

	 


	------------------------------------------------
	-- Словарь с названием параметра StartDate, который передается со стороны клиента
	------------------------------------------------


	SET @RuleDictionaryId = 15301 -- StartDate

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId												AS [RuleDictionaryId],
			N'ММ Суша-Море StartDate'										AS [RuleDictionaryItemName],
			N'Словарь с названием параметра StartDate  для ММ Суша-Море'	AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL				AS [SourceValue],  
			N'StartDate'			AS [DestinationValue]

	 


	------------------------------------------------
	-- Словарь с названием параметра EndDate, который передается со стороны клиента
	------------------------------------------------


	SET @RuleDictionaryId = 15401 -- EndDate

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId											AS [RuleDictionaryId],
			N'ММ Суша-Море EndDate'										AS [RuleDictionaryItemName],
			N'Словарь с названием параметра EndDate  для ММ Суша-Море'	AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL				AS [SourceValue],  
			N'EndDate'			AS [DestinationValue]





	--------------------------------------------------------------------------------------------
	--  TotalCostTransport -
	--------------------------------------------------------------------------------------------

	SET @RuleDictionaryId = 15605 -- 

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId								AS [RuleDictionaryId],
			N'ММ Суша-Море 9'								AS [RuleDictionaryItemName],
			N'Словарь с заменой девяток на "нет данных"'	AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			N'9'				AS [SourceValue],  
			N'[Нет данных]'		AS [DestinationValue]
	UNION
		SELECT
			@RuleDictionaryId * 100000 + 2	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			N'99'				AS [SourceValue],  
			N'[Нет данных]'		AS [DestinationValue]
	UNION
		SELECT
			@RuleDictionaryId * 100000 + 3	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			N'999'				AS [SourceValue],  
			N'[Нет данных]'		AS [DestinationValue]
	UNION
		SELECT
			@RuleDictionaryId * 100000 + 4	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			N'9999'				AS [SourceValue],  
			N'[Нет данных]'		AS [DestinationValue]
	UNION
		SELECT
			@RuleDictionaryId * 100000 + 5	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			N'99999'			AS [SourceValue],  
			N'[Нет данных]'		AS [DestinationValue]
	UNION
		SELECT
			@RuleDictionaryId * 100000 + 6	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			N'999999'			AS [SourceValue],  
			N'[Нет данных]'		AS [DestinationValue]

	UNION
		SELECT
			@RuleDictionaryId * 100000 + 7	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			N'9999999'			AS [SourceValue],  
			N'[Нет данных]'		AS [DestinationValue]

	UNION
		SELECT
			@RuleDictionaryId * 100000 + 8	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			N'99999999'			AS [SourceValue],  
			N'[Нет данных]'		AS [DestinationValue]

	UNION
		SELECT
			@RuleDictionaryId * 100000 + 9	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			N'999999999'		AS [SourceValue],  
			N'[Нет данных]'		AS [DestinationValue]

	UNION
		SELECT
			@RuleDictionaryId * 100000 + 10	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			N'9999999999'		AS [SourceValue],  
			N'[Нет данных]'		AS [DestinationValue]

	UNION
		SELECT
			@RuleDictionaryId * 100000 + 11	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			N'99999999999'		AS [SourceValue],  
			N'[Нет данных]'		AS [DestinationValue]


	UNION
		SELECT
			@RuleDictionaryId * 100000 + 12	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			N'999999999999'		AS [SourceValue],  
			N'[Нет данных]'		AS [DestinationValue]


	------------------------------------------------
	-- Словарь c промежуточными узлами NodeFrom
	------------------------------------------------

	SET @RuleDictionaryId = 10401 --   (Начальная точка) Узел отправления
	IF NOT EXISTS  (SELECT * FROM [nkhtk].[RuleDictionary] WHERE [RuleDictionaryName] = N'ММ Суша-Море Узел отправления')
	BEGIN
		INSERT INTO  [nkhtk].[RuleDictionary]
			  (
				  [RuleDictionaryId],
				  [RuleDictionaryName],
				  [RuleDictionaryDescription]
			  )

			SELECT 
				@RuleDictionaryId,
				N'ММ Суша-Море Промежуточный узел',
				N'Словарь с зависимостью  промежуточных узлов из справочника мультимодальных узлов и "Метсоположения-узлы" для ММ Суша-море'
		
	
		INSERT INTO  [nkhtk].[RuleDictionaryItem]
			  (
				  [RuleDictionaryItemId],
				  [RuleDictionaryId], 
				  [SourceValue],
				  [DestinationValue]
			  )

		 SELECT
		 [RuleDictionaryItemId] = @RuleDictionaryId * 100000 + ROW_NUMBER() OVER(ORDER BY N.SourceValue ASC),
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

	SET @RuleDictionaryId = 10505 --  Узел отправления
	IF NOT EXISTS  (SELECT * FROM [nkhtk].[RuleDictionary] WHERE [RuleDictionaryName] = N'ММ Суша-Море Узел отправления')
	BEGIN
		INSERT INTO  [nkhtk].[RuleDictionary]
			  (
				  [RuleDictionaryId],
				  [RuleDictionaryName],
				  [RuleDictionaryDescription]
			  )

			SELECT 
				@RuleDictionaryId,
				N'ММ Суша-Море Узел отправления',
				N'Словарь с зависимостью "Узел отправления"из справочника мультимодальных узлов и "Метсоположения-узлы" для ММ Суша-море'

		
	
		INSERT INTO  [nkhtk].[RuleDictionaryItem]
			  (
				  [RuleDictionaryItemId],
				  [RuleDictionaryId], 
				  [SourceValue],
				  [DestinationValue]
			  )

		 SELECT
		 [RuleDictionaryItemId] = @RuleDictionaryId * 100000 + ROW_NUMBER() OVER(ORDER BY N.SourceValue ASC),
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

	SET @RuleDictionaryId = 15701 -- RUB

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId								AS [RuleDictionaryId],
			N'ММ Суша-Море GeneralCurrency'					AS [RuleDictionaryItemName],
			N'Словарь с названием параметра для валюты RUB'	AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL				AS [SourceValue],  
			N'GeneralCurrency'	AS [DestinationValue]



	------------------------------------------------
	-- Словарь с константами для операции вставки нового значения
	------------------------------------------------

	SET @RuleDictionaryId = 15801 -- 1

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId												AS [RuleDictionaryId],
			N'ММ Суша-Море stg_Operation_1'									AS [RuleDictionaryItemName],
			N'Словарь с константами для операции вставки нового значения'	AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


    SELECT
	    @RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'1'				AS [DestinationValue]



		

	------------------------------------------------
	-- Словарь с названием параметра Basis, который передается со стороны клиента
	------------------------------------------------


	SET @RuleDictionaryId = 11201 -- Basis Базис поставки

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId											AS [RuleDictionaryId],
			N'ММ Суша-Море Basis'										AS [RuleDictionaryItemName],
			N'Словарь с названием параметра Basis  для ММ Суша-Море'	AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId				AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL							AS [SourceValue],  
			N'Basis'	AS [DestinationValue]


			
	------------------------------------------------
	-- Словарь с маппингом Basis из имени в код
	------------------------------------------------


	SET @RuleDictionaryId = 11202 -- маппингом Basis Базис поставки

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId											AS [RuleDictionaryId],
			N'ММ Суша-Море Basis Mapping'										AS [RuleDictionaryItemName],
			N'Словарь с маппингом Basis из имени в код  для ММ Суша-Море'	AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
		 [RuleDictionaryItemId] = @RuleDictionaryId * 100000 + ROW_NUMBER() OVER(ORDER BY B.SourceValue ASC),
		 [RuleDictionaryId] = @RuleDictionaryId,
		 B.[SourceValue],
		 B.[DestinationValue]

		 from
			 (
				SELECT
					[SourceValue] = CAST ([Name] AS nvarchar(max)),
					[DestinationValue] = CAST ([Code] AS nvarchar(max))
				FROM [mdm].[dbo].[vw_Basis]
				WHERE PrimitiveEntityDataStateId = 1
			 ) AS B




			 
	------------------------------------------------
	-- Словарь  для параметра CurrencyStandard
	------------------------------------------------

	SET @RuleDictionaryId = 11150 -- RUB

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId								AS [RuleDictionaryId],
			N'ММ Суша-Море CurrencyStandard'					AS [RuleDictionaryItemName],
			N'Словарь с названием параметра для валюты'	AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL				AS [SourceValue],  
			N'CurrencyStandard'	AS [DestinationValue]


	------------------------------------------------
	-- Словарь с названием параметра CurrencyDate, который передается со стороны клиента
	------------------------------------------------


	SET @RuleDictionaryId = 11701 -- CurrencyDate

	INSERT INTO  [nkhtk].[RuleDictionary]
		  (
			  [RuleDictionaryId],
			  [RuleDictionaryName],
			  [RuleDictionaryDescription]
		  )
		SELECT 
			@RuleDictionaryId												AS [RuleDictionaryId],
			N'ММ Суша-Море CurrencyDate'										AS [RuleDictionaryItemName],
			N'Словарь с названием параметра CurrencyDate  для ММ Суша-Море'	AS [RuleDictionaryDescription]
	
	INSERT INTO  [nkhtk].[RuleDictionaryItem]
		  (
			  [RuleDictionaryItemId],
			  [RuleDictionaryId], 
			  [SourceValue],
			  [DestinationValue]
		  )


		SELECT
			@RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
			@RuleDictionaryId	AS [RuleDictionaryId],
			-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
			NULL				AS [SourceValue],  
			N'CurrencyDate'			AS [DestinationValue]

	 

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
