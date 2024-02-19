USE [mdm_integ]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




DECLARE @RuleDictionaryId int = 501 -- RUB

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId					AS [RuleDictionaryId],
		N'RUB'								AS [RuleDictionaryItemName],
		N'Словарь с константами для валюты RUB'			AS [RuleDictionaryDescription]
	
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
		N'RUB'				AS [DestinationValue]

GO

--------------------------------------------------------------------------

DECLARE @RuleDictionaryId int = 801 --  SugDistance
INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )

	SELECT 
		@RuleDictionaryId,
		N'SugDistance',
		N'Словарь с зависимостью "Предоставление ТС" для СУГ-1, ШФЛУ 95, СУГ-3, СУГ-3Б, СУГ-2 от дистанции в км'


		
	
INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [SourceValue],
		  [DestinationValue]
	  )

 SELECT
 [RuleDictionaryItemId] = @RuleDictionaryId * 100000 + ROW_NUMBER() OVER(ORDER BY RD.SourceValue ASC),
 [RuleDictionaryId] = @RuleDictionaryId,
 RD.[SourceValue],
 RD.[DestinationValue]

 from
 (
    SELECT
		[SourceValue] = CAST (NhtkDistance AS nvarchar(max)),
		[DestinationValue] = CAST (SugDistance AS nvarchar(max))
	from [nkhtk].[TmpDistanceDictionary] 
 ) AS RD



 GO
 --------------------------------------------------------------------------

DECLARE @RuleDictionaryId int = 802 --  NbDistance


 INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )

	SELECT 
		@RuleDictionaryId,
		N'NbDistance',
		N'Словарь с зависимостью "Предоставление ТС" для НБ-1, НБ-2 Хим, НБ-2 НП, НБ-3, НБ-4, НБ-5, НБ-6, НБ-7, НБ-8 от дистанции в км'	
	
INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [SourceValue],
		  [DestinationValue]
	  )

 SELECT
 [RuleDictionaryItemId] = @RuleDictionaryId * 100000 + ROW_NUMBER() OVER(ORDER BY RD.SourceValue ASC),
 [RuleDictionaryId] = @RuleDictionaryId,
 RD.[SourceValue],
 RD.[DestinationValue]

 from
 (
    SELECT

		[SourceValue] = CAST (NhtkDistance AS nvarchar(max)),
		[DestinationValue] = CAST (NbDistance AS nvarchar(max))
	from [nkhtk].[TmpDistanceDictionary] 
 ) AS RD




GO

----------------------------------
--- SpbtButadienDistance

DECLARE @RuleDictionaryId int = 803 --  SpbtButadienDistance


 INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )

	SELECT 
		@RuleDictionaryId,
		N'SpbtButadienDistance',
		N'Словарь с зависимостью "Предоставление ТС" для "СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен лист Бутадиен" от дистанции в км'	

		
INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [SourceValue],
		  [DestinationValue]
	  )

 SELECT
 [RuleDictionaryItemId] = @RuleDictionaryId * 100000 + ROW_NUMBER() OVER(ORDER BY RD.SourceValue ASC),
 [RuleDictionaryId] = @RuleDictionaryId,
 RD.[SourceValue],
 RD.[DestinationValue]

 from
 (
    SELECT
		[SourceValue] = CAST (NhtkDistance AS nvarchar(max)),
		[DestinationValue] = CAST (SpbtButadienDistance AS nvarchar(max))
	from [nkhtk].[TmpDistanceDictionary] 
 ) AS RD




GO


------------------SpbtButilenDistance


DECLARE @RuleDictionaryId int = 804 --  SpbtButilenDistance


 INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )

	SELECT 
		@RuleDictionaryId,
		N'SpbtButilenDistance',
		N'Словарь с зависимостью "Предоставление ТС" для "СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен лист Бутилен" от дистанции в км'	

	
INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [SourceValue],
		  [DestinationValue]
	  )

 SELECT
 [RuleDictionaryItemId] = @RuleDictionaryId * 100000 + ROW_NUMBER() OVER(ORDER BY RD.SourceValue ASC),
 [RuleDictionaryId] = @RuleDictionaryId,
 RD.[SourceValue],
 RD.[DestinationValue]

 from
 (
    SELECT
		[SourceValue] = CAST (NhtkDistance AS nvarchar(max)),
		[DestinationValue] = CAST (SpbtButilenDistance AS nvarchar(max))
	from [nkhtk].[TmpDistanceDictionary] 
 ) AS RD




GO


---------------------------------------------------
---SpbtPbtPropilenDistance


DECLARE @RuleDictionaryId int = 805 --  SpbtPbtPropilenDistance


 INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )

	SELECT 
		@RuleDictionaryId,
		N'SpbtPbtPropilenDistance',
		N'Словарь с зависимостью "Предоставление ТС" для "СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен листы ПБТ и Пропилен" от дистанции в км'	

		
INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [SourceValue],
		  [DestinationValue]
	  )

 SELECT
	 [RuleDictionaryItemId] = @RuleDictionaryId * 100000 + ROW_NUMBER() OVER(ORDER BY RD.SourceValue ASC),
	 [RuleDictionaryId] = @RuleDictionaryId,
	 RD.[SourceValue],
	 RD.[DestinationValue]

 from
 (
    SELECT
		[SourceValue] = CAST (NhtkDistance AS nvarchar(max)),
		[DestinationValue] = CAST (SpbtPbtPropilenDistance AS nvarchar(max))
	from [nkhtk].[TmpDistanceDictionary] 
 ) AS RD

 


GO




---------------------------------------------------
---SptTkBgsDistance


DECLARE @RuleDictionaryId int = 806 --  SptTkBgsDistance


 INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )

	SELECT 
		@RuleDictionaryId,
		N'SptTkBgsDistance',
		N'Словарь с зависимостью "Предоставление ТС" для "СПТ Тобольск ТК + БГС" от дистанции в км'	

	
INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [SourceValue],
		  [DestinationValue]
	  )

 SELECT
	 [RuleDictionaryItemId] = @RuleDictionaryId * 100000 + ROW_NUMBER() OVER(ORDER BY RD.SourceValue ASC),
	 [RuleDictionaryId] = @RuleDictionaryId,
	 RD.[SourceValue],
	 RD.[DestinationValue]

 from
 (
    SELECT

		[SourceValue] = CAST (NhtkDistance AS nvarchar(max)),
		[DestinationValue] = CAST (SptTkBgsDistance AS nvarchar(max))
	from [nkhtk].[TmpDistanceDictionary] 
 ) AS RD




GO


-------------------------

---ZeroToEmpty




DECLARE @RuleDictionaryId int = 1601 -- 0

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId					AS [RuleDictionaryId],
		N'ZeroToEmpty'						AS [RuleDictionaryItemName],
		N'Словарь для замены нулей на пустые значения'			AS [RuleDictionaryDescription]
	
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
		N'0.00'				AS [SourceValue],  
		N''					AS [DestinationValue]

	UNION
	SELECT
	    @RuleDictionaryId * 100000 + 2	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		N'0.0'				AS [SourceValue],  
		N''					AS [DestinationValue]

	UNION
	SELECT
	    @RuleDictionaryId * 100000 + 3	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		N'0'				AS [SourceValue],  
		N''					AS [DestinationValue]

	
GO


--------------------------------------------------------------------------

DECLARE @RuleDictionaryId int = 3201 -- Today CurrencyRateMonth

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId					AS [RuleDictionaryId],
		N'CurrencyRateMonth'								AS [RuleDictionaryItemName],
		N'Словарь с названием параметра CurrencyRateMonth'			AS [RuleDictionaryDescription]
	
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
		N'CurrencyRateMonth'				AS [DestinationValue]

GO


--------------------------------------------------------------------------

DECLARE @RuleDictionaryId int = 5401 -- StartDate

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId					AS [RuleDictionaryId],
		N'StartDate'								AS [RuleDictionaryItemName],
		N'Словарь с названием параметра StartDate'			AS [RuleDictionaryDescription]
	
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
		N'StartDate'				AS [DestinationValue]

GO

--------------------------------------------------------------------------

DECLARE @RuleDictionaryId int = 5501 -- EndDate

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId					AS [RuleDictionaryId],
		N'EndDate'								AS [RuleDictionaryItemName],
		N'Словарь с названием параметра EndDate'			AS [RuleDictionaryDescription]
	
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
		N'EndDate'				AS [DestinationValue]

GO

--------------------------------------------------------------------------



DECLARE @RuleDictionaryId int = 4401 -- RateCalcTypeTonne T

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId							AS [RuleDictionaryId],
		N'RateCalcTypeTonne'						AS [RuleDictionaryItemName],
		N'Словарь с константой T для RateCalcType'	AS [RuleDictionaryDescription]
	
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
		-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		---  это русское Т				!!!!!!!!!!!!!!
		---!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		N'Т'				AS [DestinationValue]  

GO

--------------------------------------------------------------------------




DECLARE @RuleDictionaryId int = 4501 -- RateType 4

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId							AS [RuleDictionaryId],
		N'RateTypeIndicative'						AS [RuleDictionaryItemName],
		N'Словарь с константой 4 для RateCalcType'	AS [RuleDictionaryDescription]
	
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
		N'4'				AS [DestinationValue]

GO

--------------------------------------------------------------------------


----------------------------------
--- NodesDictionary

DECLARE @RuleDictionaryId int = 4701 --  NodesDictionary


 INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )

	SELECT 
		@RuleDictionaryId,
		N'NodesDictionary',
		N'Словарь с зависимостью Узлов СВТ от узлов НХТК'	

	
INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [SourceValue],
		  [DestinationValue]
	  )

 SELECT
 [RuleDictionaryItemId] = @RuleDictionaryId * 100000 + ROW_NUMBER() OVER(ORDER BY RD.SourceValue ASC),
 [RuleDictionaryId] = @RuleDictionaryId,
 RD.[SourceValue],
 RD.[DestinationValue]

 from
 (
    SELECT
		[SourceValue] =[NKHTK_Name],
		[DestinationValue] = [SVT_Code]
	from [nkhtk].[TmpNodeDictionary] 
 ) AS RD




GO

---------------------- 49

DECLARE @RuleDictionaryId int = 4901 -- TransportKind Rail

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId							AS [RuleDictionaryId],
		N'TransportKindRail'						AS [RuleDictionaryItemName],
		N'Словарь с константой Rail для TransportKind'	AS [RuleDictionaryDescription]
	
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
		N'Rail'				AS [DestinationValue]

GO


---------------------- 50

DECLARE @RuleDictionaryId int = 5001 -- TransportType Rail_VC_other

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId							AS [RuleDictionaryId],
		N'TransportTypeRail_VC_other'						AS [RuleDictionaryItemName],
		N'Словарь с константой Rail_VC_other для TransportType'	AS [RuleDictionaryDescription]
	
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
		N'Rail_VC_other'				AS [DestinationValue]


GO


---------------------- 50

DECLARE @RuleDictionaryId int = 5002 -- TransportType Rail_TK_20

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId							AS [RuleDictionaryId],
		N'TransportTypeRail_TK_20'						AS [RuleDictionaryItemName],
		N'Словарь с константой Rail_TK_20 для TransportType'	AS [RuleDictionaryDescription]
	
INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [SourceValue],
		  [DestinationValue]
	  )


    SELECT
	    @RuleDictionaryId * 100000 +  1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'Rail_TK_20'				AS [DestinationValue]


GO



---------------------- 50

DECLARE @RuleDictionaryId int = 5003 -- TransportType Rail_KV

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId							AS [RuleDictionaryId],
		N'TransportType_Rail_KV'						AS [RuleDictionaryItemName],
		N'Словарь с константой Rail_KV для TransportType'	AS [RuleDictionaryDescription]
	
INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [SourceValue],
		  [DestinationValue]
	  )


    SELECT
	    @RuleDictionaryId * 100000 +  1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'Rail_KV'				AS [DestinationValue]


GO


---------------------- 51

DECLARE @RuleDictionaryId int = 5101 -- EffectiveLoadOfTransportType_SUG-1

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId													AS [RuleDictionaryId],
		N'EffectiveLoadOfTransportType_SUG-1'								AS [RuleDictionaryItemName],
		N'Словарь с загрузкой СУГ-1 для поля EffectiveLoadOfTransportType '	AS [RuleDictionaryDescription]
	
INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [SourceValue],
		  [DestinationValue]
	  )

    SELECT
	    @RuleDictionaryId * 100000 +  1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'36.82'			AS [DestinationValue]


GO

DECLARE @RuleDictionaryId int = 5102 -- EffectiveLoadOfTransportType_SUG-2

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId													AS [RuleDictionaryId],
		N'EffectiveLoadOfTransportType_SUG-2'								AS [RuleDictionaryItemName],
		N'Словарь с загрузкой "СУГ-2" для поля EffectiveLoadOfTransportType '	AS [RuleDictionaryDescription]
	
INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [SourceValue],
		  [DestinationValue]
	  )

    SELECT
	    @RuleDictionaryId * 100000 +  1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'39.09'			AS [DestinationValue]


GO

DECLARE @RuleDictionaryId int = 5103 -- EffectiveLoadOfTransportType_SUG-3-1

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId													AS [RuleDictionaryId],
		N'EffectiveLoadOfTransportType_SUG-3-1'								AS [RuleDictionaryItemName],
		N'Словарь с загрузкой "СУГ-3 - бутадиен" для поля EffectiveLoadOfTransportType '	AS [RuleDictionaryDescription]
	
INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [SourceValue],
		  [DestinationValue]
	  )

    SELECT
	    @RuleDictionaryId * 100000 +  1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'43.28'			AS [DestinationValue]


GO


DECLARE @RuleDictionaryId int = 5104 -- EffectiveLoadOfTransportType_SUG-3-2

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId													AS [RuleDictionaryId],
		N'EffectiveLoadOfTransportType_SUG-3-2'								AS [RuleDictionaryItemName],
		N'Словарь с загрузкой "СУГ-3 - пропилен, (изо-)бутилен, изопрен,БДФ" для поля EffectiveLoadOfTransportType '	AS [RuleDictionaryDescription]
	
INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [SourceValue],
		  [DestinationValue]
	  )

    SELECT
	    @RuleDictionaryId * 100000 +  1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'36.18'			AS [DestinationValue]


GO




DECLARE @RuleDictionaryId int = 5111 -- EffectiveLoadOfTransportType_HB-1

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId													AS [RuleDictionaryId],
		N'EffectiveLoadOfTransportType_HB-1'								AS [RuleDictionaryItemName],
		N'Словарь с загрузкой "НБ-1 - Бензол эфир спирт" для поля EffectiveLoadOfTransportType '	AS [RuleDictionaryDescription]
	
INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [SourceValue],
		  [DestinationValue]
	  )

    SELECT
	    @RuleDictionaryId * 100000 +  1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'58.14'			AS [DestinationValue]


GO



DECLARE @RuleDictionaryId int = 5112 -- EffectiveLoadOfTransportType_HB-2-1

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId													AS [RuleDictionaryId],
		N'EffectiveLoadOfTransportType_HB-2-1'								AS [RuleDictionaryItemName],
		N'Словарь с загрузкой " НБ-2 - ЖПП СПТ и т.д" для поля EffectiveLoadOfTransportType '	AS [RuleDictionaryDescription]
	
INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [SourceValue],
		  [DestinationValue]
	  )

    SELECT
	    @RuleDictionaryId * 100000 +  1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'57.37'			AS [DestinationValue]


GO





DECLARE @RuleDictionaryId int = 5113 -- EffectiveLoadOfTransportType_HB-2-2

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId													AS [RuleDictionaryId],
		N'EffectiveLoadOfTransportType_HB-2-2'								AS [RuleDictionaryItemName],
		N'Словарь с загрузкой " НБ-2 - химия" для поля EffectiveLoadOfTransportType '	AS [RuleDictionaryDescription]
	
INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [SourceValue],
		  [DestinationValue]
	  )

    SELECT
	    @RuleDictionaryId * 100000 +  1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'55.86'			AS [DestinationValue]


GO





DECLARE @RuleDictionaryId int = 5114 -- EffectiveLoadOfTransportType_HB-3

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId													AS [RuleDictionaryId],
		N'EffectiveLoadOfTransportType_HB-3'								AS [RuleDictionaryItemName],
		N'Словарь с загрузкой "НБ-3 - БГС" для поля EffectiveLoadOfTransportType '	AS [RuleDictionaryDescription]
	
INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [SourceValue],
		  [DestinationValue]
	  )

    SELECT
	    @RuleDictionaryId * 100000 +  1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'48.68'			AS [DestinationValue]


GO





DECLARE @RuleDictionaryId int = 5115 -- EffectiveLoadOfTransportType_HB-5

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId													AS [RuleDictionaryId],
		N'EffectiveLoadOfTransportType_HB-5'								AS [RuleDictionaryItemName],
		N'Словарь с загрузкой "НБ-5 Натрия гидроксид, каустики" для поля EffectiveLoadOfTransportType '	AS [RuleDictionaryDescription]
	
INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [SourceValue],
		  [DestinationValue]
	  )

    SELECT
	    @RuleDictionaryId * 100000 +  1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'53'			AS [DestinationValue]


GO




DECLARE @RuleDictionaryId int = 5117 -- EffectiveLoadOfTransportType_HB-7

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId													AS [RuleDictionaryId],
		N'EffectiveLoadOfTransportType_HB-7'								AS [RuleDictionaryItemName],
		N'Словарь с загрузкой "НБ-7" для поля EffectiveLoadOfTransportType '	AS [RuleDictionaryDescription]
	
INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [SourceValue],
		  [DestinationValue]
	  )

    SELECT
	    @RuleDictionaryId * 100000 +  1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'55.86'			AS [DestinationValue]


GO



DECLARE @RuleDictionaryId int = 5118 -- EffectiveLoadOfTransportType_HB-8

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId													AS [RuleDictionaryId],
		N'EffectiveLoadOfTransportType_HB-8'								AS [RuleDictionaryItemName],
		N'Словарь с загрузкой "НБ-8" для поля EffectiveLoadOfTransportType '	AS [RuleDictionaryDescription]
	
INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [SourceValue],
		  [DestinationValue]
	  )

    SELECT
	    @RuleDictionaryId * 100000 +  1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'57.5'			AS [DestinationValue]


GO
------------------------ 53
DECLARE @RuleDictionaryId int = 5301 -- СУГ-1- "Ставки"

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId									AS [RuleDictionaryId],
		N'Products_SUG-1-01'								AS [RuleDictionaryItemName],
		N'Словарь с продукатми "СУГ-1- "Ставки" для поля Product '	AS [RuleDictionaryDescription]

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
		N'1088401'			AS [DestinationValue]

	UNION
	SELECT
	    @RuleDictionaryId * 100000 + 2	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'818654'			AS [DestinationValue]

	UNION
	SELECT
	    @RuleDictionaryId * 100000 + 3	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'735853'			AS [DestinationValue]
	UNION
	SELECT
	    @RuleDictionaryId * 100000 + 4	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'1194872'			AS [DestinationValue]
	UNION
	SELECT
	    @RuleDictionaryId * 100000 + 5	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'1196667'			AS [DestinationValue]

GO


DECLARE @RuleDictionaryId int = 5302 -- СУГ-1- Ставки без охраны

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId									AS [RuleDictionaryId],
		N'Products_SUG-1-02'								AS [RuleDictionaryItemName],
		N'Словарь с продукатми "СУГ-1- "Ставки без охраны" для поля Product '	AS [RuleDictionaryDescription]

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
		N'726073'			AS [DestinationValue]

	UNION
	SELECT
	    @RuleDictionaryId * 100000 + 2	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'978768'			AS [DestinationValue]

	UNION
	SELECT
	    @RuleDictionaryId * 100000 + 3	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'1198596'			AS [DestinationValue]
	UNION
	SELECT
	    @RuleDictionaryId * 100000 + 4	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'1197026'			AS [DestinationValue]
	UNION
	SELECT
	    @RuleDictionaryId * 100000 + 5	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'1197413'			AS [DestinationValue]
UNION
	SELECT
	    @RuleDictionaryId * 100000 + 6	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'215147'			AS [DestinationValue]
UNION
	SELECT
	    @RuleDictionaryId * 100000 + 7	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'1197212'			AS [DestinationValue]
UNION
	SELECT
	    @RuleDictionaryId * 100000 + 8	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'1196896'			AS [DestinationValue]			
  UNION
	SELECT
	    @RuleDictionaryId * 100000 + 9	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'1182289'			AS [DestinationValue]         
UNION
	SELECT
	    @RuleDictionaryId * 100000 + 10	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'1184722'			AS [DestinationValue]            
            
 UNION
	SELECT
	    @RuleDictionaryId * 100000 + 11	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'1206057'			AS [DestinationValue]            
           
         
          
GO




GO


DECLARE @RuleDictionaryId int = 5303 -- СУГ-1- Спецставка

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId									AS [RuleDictionaryId],
		N'Products_SUG-1-03'								AS [RuleDictionaryItemName],
		N'Словарь с продукатми "СУГ-1- "Спецставка" для поля Product '	AS [RuleDictionaryDescription]

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
		N'978768'			AS [DestinationValue]

GO


DECLARE @RuleDictionaryId int = 5304 -- СУГ-2 - фракция пент изопент

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId									AS [RuleDictionaryId],
		N'Products_SUG-2-01'								AS [RuleDictionaryItemName],
		N'Словарь с продукатми "СУГ-2 - фракция пент изопент" для поля Product '	AS [RuleDictionaryDescription]

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
		N'949721'			AS [DestinationValue]

		UNION
	SELECT
	    @RuleDictionaryId * 100000 + 2	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'662545'			AS [DestinationValue]

GO


DECLARE @RuleDictionaryId int = 5305 -- СУГ-3 - бутадиен

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId									AS [RuleDictionaryId],
		N'Products_SUG-3-11'								AS [RuleDictionaryItemName],
		N'Словарь с продукатми "СУГ-3 - бутадиен" для поля Product '	AS [RuleDictionaryDescription]

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
		N'742969'			AS [DestinationValue]


GO



DECLARE @RuleDictionaryId int = 5306 -- СУГ-3 - пропилен, (изо-)бутилен, изопрен,БДФ  -- "Пропилен, изобутилен "

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId									AS [RuleDictionaryId],
		N'Products_SUG-3-21'								AS [RuleDictionaryItemName],
		N'Словарь с продукатми "СУГ-3 - пропилен, (изо-)бутилен, изопрен,БДФ  -- "Пропилен, изобутилен "" для поля Product '	AS [RuleDictionaryDescription]

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
		N'978767'			AS [DestinationValue]

		UNION

				
    SELECT
	    @RuleDictionaryId * 100000 + 2	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'1053729'			AS [DestinationValue]

			UNION

				
    SELECT
	    @RuleDictionaryId * 100000 + 3	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'369037'			AS [DestinationValue]

GO


GO



DECLARE @RuleDictionaryId int = 5307 -- СУГ-3 - пропилен, (изо-)бутилен, изопрен,БДФ  -- "Бутилен, изопрен, БДФ "

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId									AS [RuleDictionaryId],
		N'Products_SUG-3-22'								AS [RuleDictionaryItemName],
		N'Словарь с продукатми "СУГ-3 - пропилен, (изо-)бутилен, изопрен,БДФ  -- "Бутилен, изопрен, БДФ "" для поля Product '	AS [RuleDictionaryDescription]

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
		N'369037'			AS [DestinationValue]


GO

DECLARE @RuleDictionaryId int = 5308 -- СУГ-3 - пропилен, (изо-)бутилен, изопрен,БДФ  -- "Бутилен, изопрен, БДФ "

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId									AS [RuleDictionaryId],
		N'Products_SUG-3-23'								AS [RuleDictionaryItemName],
		N'Словарь с продукатми "СУГ-3 - пропилен, (изо-)бутилен, изопрен,БДФ  -- "Бутилен, изопрен, БДФ "" для поля Product '	AS [RuleDictionaryDescription]

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
		N'492195'			AS [DestinationValue]

		UNION

				
    SELECT
	    @RuleDictionaryId * 100000 + 2	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'668077'			AS [DestinationValue]

			UNION

				
    SELECT
	    @RuleDictionaryId * 100000 + 3	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId],
		-- [SourceValue] отсутсвует, потому что данный словарь используется без привяки к источнику. 
		NULL				AS [SourceValue],  
		N'728551'			AS [DestinationValue]

GO


--06 – ШФЛУ


DECLARE @RuleDictionaryId int = 5310 -- 06 – ШФЛУ

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId									AS [RuleDictionaryId],
		N'Products_SHFLU'								AS [RuleDictionaryItemName],
		N'Словарь с продукатми "ШФЛУ" для поля Product '	AS [RuleDictionaryDescription]

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
		N'1129223'			AS [DestinationValue]


GO

--06 – ШФЛУ


DECLARE @RuleDictionaryId int = 5321 -- 06 – НБ-1 - Бензол эфир спирт и т.д. - Ставки

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId								AS [RuleDictionaryId],
		N'Products_HB-11'								AS [RuleDictionaryItemName],
		N'Словарь с продукатми " НБ-1 - Ставки" для поля Product '	AS [RuleDictionaryDescription]

INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [DestinationValue]
	  )
   
    SELECT
	    @RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'337649'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 2	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'801633'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 3	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'343336'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 4	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'996943'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 5	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'381473'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 6	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'388088'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 7	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'437119'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 8	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'549716'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 9	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'573024'			AS [DestinationValue]
UNION
  
    SELECT
	    @RuleDictionaryId * 100000 + 10	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'586791'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 11	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'710117'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 12	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'429178'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 13	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'313745'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 14	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'375534'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 15	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'457881'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 16	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'991886'			AS [DestinationValue]
UNION
      
    SELECT
	    @RuleDictionaryId * 100000 + 17	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'897818'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 18	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'339909'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 19	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'386495'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 20	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'415581'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 21	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'624229'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 22	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'365688'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 23	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'546480'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 24	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'702944'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 25	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'972108'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 26	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'900549'			AS [DestinationValue]
UNION
       
    SELECT
	    @RuleDictionaryId * 100000 + 27	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'963009'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 28	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'825146'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 29	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'685916'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 30	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'346026'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 31	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'1184679'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 32	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'1182518'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 33	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'1182642'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 34	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'1209282'			AS [DestinationValue]
GO



DECLARE @RuleDictionaryId int = 5322 -- 06 – НБ-1 - Бензол эфир спирт и т.д. - Ставки со скидкой на 720 км

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId								AS [RuleDictionaryId],
		N'Products_HB-12'								AS [RuleDictionaryItemName],
		N'Словарь с продукатми " НБ-1 - Ставки со скидкой на 720 км" для поля Product '	AS [RuleDictionaryDescription]

INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [DestinationValue]
	  )
   
  
    SELECT
	    @RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'198835'			AS [DestinationValue]
UNION

    SELECT
	    @RuleDictionaryId * 100000 + 2	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'1182517'			AS [DestinationValue]
UNION

    SELECT
	    @RuleDictionaryId * 100000 + 3	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'969046'			AS [DestinationValue]
UNION

			
            
            
    SELECT
	    @RuleDictionaryId * 100000 + 4	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'1204844'			AS [DestinationValue]
UNION

    SELECT
	    @RuleDictionaryId * 100000 + 5	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'415581'			AS [DestinationValue]
UNION

    SELECT
	    @RuleDictionaryId * 100000 + 6	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'991886'			AS [DestinationValue]
UNION

    SELECT
	    @RuleDictionaryId * 100000 + 7	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'1182518'			AS [DestinationValue]
UNION

    SELECT
	    @RuleDictionaryId * 100000 + 8	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'897818'			AS [DestinationValue]

		GO

            
            
            
            
            

DECLARE @RuleDictionaryId int = 5323 -- НБ-1 - Бензол эфир спирт и т.д. с 01.06.2022  -- МТБЭ Сургут

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId								AS [RuleDictionaryId],
		N'Products_HB-13'								AS [RuleDictionaryItemName],
		N'Словарь с продукатми " НБ-1 -  МТБЭ Сургут" для поля Product '	AS [RuleDictionaryDescription]

INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [DestinationValue]
	  )
   
  
    SELECT
	    @RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'991643'			AS [DestinationValue]



GO
DECLARE @RuleDictionaryId int = 5324 -- НБ-1 - Бензол эфир спирт и т.д. с 01.06.2022  -- МТБЭ Сахалин МАЙ 2022

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId								AS [RuleDictionaryId],
		N'Products_HB-14'								AS [RuleDictionaryItemName],
		N'Словарь с продукатми "НБ-1 -  МТБЭ Сахалин МАЙ 2022" для поля Product '	AS [RuleDictionaryDescription]

INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [DestinationValue]
	  )
   
  
    SELECT
	    @RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'616866'			AS [DestinationValue]

		union
		  SELECT
	    @RuleDictionaryId * 100000 + 2	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'279160'			AS [DestinationValue]

		GO


		
GO
DECLARE @RuleDictionaryId int = 5325 -- НБ-1 - Бензол эфир спирт и т.д. с 01.06.2022  -- Стирол

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId								AS [RuleDictionaryId],
		N'Products_HB-15'								AS [RuleDictionaryItemName],
		N'Словарь с продукатми "НБ-1 - МТБЭ Стирол" для поля Product '	AS [RuleDictionaryDescription]

INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [DestinationValue]
	  )
   
  
    SELECT
	    @RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'338824'			AS [DestinationValue]


		GO


		GO
DECLARE @RuleDictionaryId int = 5326 -- НБ-1 - Бензол эфир спирт и т.д. с 01.06.2022  -- МТБЭ Гликоли

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId								AS [RuleDictionaryId],
		N'Products_HB-16'								AS [RuleDictionaryItemName],
		N'Словарь с продукатми "НБ-1 - МТБЭ Гликоли" для поля Product '	AS [RuleDictionaryDescription]

INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [DestinationValue]
	  )
   
  
    SELECT
	    @RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'991831'			AS [DestinationValue]


		GO



		-- НБ-2 - ЖПП СПТ и т.д 
			GO
DECLARE @RuleDictionaryId int = 5331 -- НБ-2 - ЖПП СПТ и т.д 

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId								AS [RuleDictionaryId],
		N'Products_HB-2-1-1'								AS [RuleDictionaryItemName],
		N'Словарь с продукатми "НБ-2 - ЖПП СПТ и т.д  -- ставки" для поля Product '	AS [RuleDictionaryDescription]

INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [DestinationValue]
	  )

    SELECT
	    @RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'773362'			AS [DestinationValue]
UNION

    SELECT
	    @RuleDictionaryId * 100000 + 2	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'1210592'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 3	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'1182294'			AS [DestinationValue]
UNION

    SELECT
	    @RuleDictionaryId * 100000 + 4	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'1182302'			AS [DestinationValue]
UNION

    SELECT
	    @RuleDictionaryId * 100000 + 5	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'1003156'			AS [DestinationValue]
UNION

    SELECT
	    @RuleDictionaryId * 100000 + 6	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'801770'			AS [DestinationValue]
UNION

            
            
    SELECT
	    @RuleDictionaryId * 100000 + 7	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'185621'			AS [DestinationValue]
UNION

    SELECT
	    @RuleDictionaryId * 100000 + 8	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'1188810'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 9	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'713976'			AS [DestinationValue]


					GO
DECLARE @RuleDictionaryId int = 5332 -- НБ-2 - ЖПП СПТ и т.д  Сахалин 2022 ИНДИКАТИВ МАЙ!!!

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId								AS [RuleDictionaryId],
		N'Products_HB-2-1-2'								AS [RuleDictionaryItemName],
		N'Словарь с продукатми "НБ-2 - Сахалин 2022 ИНДИКАТИВ МАЙ!!!" для поля Product '	AS [RuleDictionaryDescription]

INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [DestinationValue]
	  )
   
  
    SELECT
	    @RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'1182294'			AS [DestinationValue]
UNION

    SELECT
	    @RuleDictionaryId * 100000 + 2	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'713976'			AS [DestinationValue]


GO


			GO
DECLARE @RuleDictionaryId int = 5341 -- НБ-2 - химия  -- ставки 2022
INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId								AS [RuleDictionaryId],
		N'Products_HB-2-2-1'								AS [RuleDictionaryItemName],
		N'Словарь с продукатми "НБ-2 - химия  -- ставки" для поля Product '	AS [RuleDictionaryDescription]

INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [DestinationValue]
	  )
  
    SELECT
	    @RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'428674'			AS [DestinationValue]
UNION

    SELECT
	    @RuleDictionaryId * 100000 + 2	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'350620'			AS [DestinationValue]
UNION

    SELECT
	    @RuleDictionaryId * 100000 + 3	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'767776'			AS [DestinationValue]
		UNION

    SELECT
	    @RuleDictionaryId * 100000 + 4	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'402872'			AS [DestinationValue]
		UNION


    SELECT
	    @RuleDictionaryId * 100000 + 5	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'958869'			AS [DestinationValue]
		UNION

    SELECT
	    @RuleDictionaryId * 100000 + 6	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'339435'			AS [DestinationValue]
		UNION

    SELECT
	    @RuleDictionaryId * 100000 + 7	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'339428'			AS [DestinationValue]
		UNION

    SELECT
	    @RuleDictionaryId * 100000 + 8	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'697932'			AS [DestinationValue]
		UNION

    SELECT
	    @RuleDictionaryId * 100000 + 9	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'337640'			AS [DestinationValue]
		UNION

    SELECT
	    @RuleDictionaryId * 100000 + 10	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'369630'			AS [DestinationValue]
		
GO



			GO
DECLARE @RuleDictionaryId int = 5342 -- НБ-2 - химия  -- сСтавки со скидкой на расст.  ап
INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId								AS [RuleDictionaryId],
		N'Products_HB-2-2-2'								AS [RuleDictionaryItemName],
		N'Словарь с продукатми "НБ-2 - химия  Ставки со скидкой на расст.  ап" для поля Product '	AS [RuleDictionaryDescription]

INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [DestinationValue]
	  )
  
    SELECT
	    @RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'428674'			AS [DestinationValue]
UNION

    SELECT
	    @RuleDictionaryId * 100000 + 2	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'350620'			AS [DestinationValue]
		UNION

    SELECT
	    @RuleDictionaryId * 100000 + 3	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'339435'			AS [DestinationValue]
		UNION

    SELECT
	    @RuleDictionaryId * 100000 + 4	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'337640'			AS [DestinationValue]


		GO



	--	НБ-3 - БГС

	DECLARE @RuleDictionaryId int = 5350 -- НБ-3
INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId								AS [RuleDictionaryId],
		N'Products_HB-3'								AS [RuleDictionaryItemName],
		N'Словарь с продукатми "НБ-3 - БГС" для поля Product '	AS [RuleDictionaryDescription]

INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [DestinationValue]
	  )
  
    SELECT
	    @RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'214018'			AS [DestinationValue]


GO

--	НБ-5

	DECLARE @RuleDictionaryId int = 5352 -- Натрия гидроксид, каустики
INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId								AS [RuleDictionaryId],
		N'Products_HB-5'								AS [RuleDictionaryItemName],
		N'Словарь с продукатми "НБ-5 Натрия гидроксид, каустики" для поля Product '	AS [RuleDictionaryDescription]

INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [DestinationValue]
	  )
  
    SELECT
	    @RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'1194297'			AS [DestinationValue]


GO


--	НБ-7
GO
	DECLARE @RuleDictionaryId int = 5354
INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId								AS [RuleDictionaryId],
		N'Products_HB-7'								AS [RuleDictionaryItemName],
		N'Словарь с продукатми "НБ-7" для поля Product '	AS [RuleDictionaryDescription]

INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [DestinationValue]
	  )
  
    SELECT
	    @RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'412522'			AS [DestinationValue]
UNION
    SELECT
	    @RuleDictionaryId * 100000 + 2	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'1184726'			AS [DestinationValue]

GO


--select * from [nkhtk].[RuleDictionary]
--select * from [nkhtk].[RuleDictionaryItem]
--	НБ-8

	DECLARE @RuleDictionaryId int = 5356
INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId								AS [RuleDictionaryId],
		N'Products_HB-8'								AS [RuleDictionaryItemName],
		N'Словарь с продукатми "НБ-8" для поля Product '	AS [RuleDictionaryDescription]

INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [DestinationValue]
	  )
  
    SELECT
	    @RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'1184797'			AS [DestinationValue]

GO


DECLARE @RuleDictionaryId int = 5360
INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId								AS [RuleDictionaryId],
		N'ProductNames_TK_RF'								AS [RuleDictionaryItemName],
		N'Словарь имен продуктов и их кодов шаблона "ТК РФ" для поля Product '	AS [RuleDictionaryDescription]

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
		'спирты'  AS [SourceValue],
		'343336'  AS [DestinationValue]

	UNION
    SELECT
	    @RuleDictionaryId * 100000 + 2	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		'Спирты'  AS [SourceValue],
		'343336'  AS [DestinationValue]

	UNION
	SELECT
	    @RuleDictionaryId * 100000 + 3	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		'Бутилакрилат'  AS [SourceValue],
		'900549'  AS [DestinationValue]

	UNION
	SELECT
	    @RuleDictionaryId * 100000 + 4	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		'бутилакрилат'  AS [SourceValue],
		'900549'  AS [DestinationValue]

	UNION
     	SELECT
	    @RuleDictionaryId * 100000 + 5	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		'Дициклопентадиена (ЕТСНГ711162)'  AS [SourceValue],
		'1185200'  AS [DestinationValue]

	UNION     
   	SELECT
	    @RuleDictionaryId * 100000 + 6	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		'ДОФ / ДОТФ'  AS [SourceValue],
		'1080493'  AS [DestinationValue]

	UNION
		SELECT
	    @RuleDictionaryId * 100000 + 7	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		'стирол'  AS [SourceValue],
		'338824'  AS [DestinationValue]

	UNION
			SELECT
	    @RuleDictionaryId * 100000 + 8	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		'Стирол'  AS [SourceValue],
		'338824'  AS [DestinationValue]

	UNION 
SELECT
	    @RuleDictionaryId * 100000 + 9	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		'Гликоли'  AS [SourceValue],
		'991831'  AS [DestinationValue]

	UNION

	SELECT
	    @RuleDictionaryId * 100000 + 10	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		'гликоли'  AS [SourceValue],
		'991831'  AS [DestinationValue]

	UNION

	SELECT
	    @RuleDictionaryId * 100000 + 11	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		'Кислота 2-этилгексановая (ЕТСНГ724266)'  AS [SourceValue],
		'198835'  AS [DestinationValue]

	UNION
	SELECT
	    @RuleDictionaryId * 100000 + 12	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		'Кислота 2-этилгексановая (ЕТСНГ724266) '  AS [SourceValue],
		'198835'  AS [DestinationValue]

	UNION      
  	SELECT
	    @RuleDictionaryId * 100000 + 13	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		'Винилацетат ингибированный (ЕТСНГ 725112)'  AS [SourceValue],
		'1194963'  AS [DestinationValue]

	UNION          
   	SELECT
	    @RuleDictionaryId * 100000 + 14	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		'Бутадиен'  AS [SourceValue],
		'742969'  AS [DestinationValue]

	UNION           
   	SELECT
	    @RuleDictionaryId * 100000 + 15	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		'Бензол'  AS [SourceValue],
		'346026'  AS [DestinationValue]

	UNION 
    	SELECT
	    @RuleDictionaryId * 100000 + 16	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		'Гексен-1'  AS [SourceValue],
		'1209282'  AS [DestinationValue]
UNION 
    	SELECT
	    @RuleDictionaryId * 100000 + 17	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		'гексен-1'  AS [SourceValue],
		'1209282'  AS [DestinationValue]
	UNION

	    	SELECT
	    @RuleDictionaryId * 100000 + 18	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		'бутадиен'  AS [SourceValue],
		'742969'  AS [DestinationValue]

	UNION 
   	    	SELECT
	    @RuleDictionaryId * 100000 + 19	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		'бензол'  AS [SourceValue],
		'346026'  AS [DestinationValue]

	


GO

---53 - СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен ---------  ПБТ



DECLARE @RuleDictionaryId int = 5370
INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId								AS [RuleDictionaryId],
		N'Products_SpbtPbt'								AS [RuleDictionaryItemName],
		N'Словарь с продукатми "СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен ---------  ПБТ" для поля Product '	AS [RuleDictionaryDescription]

INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [DestinationValue]
	  )
  
    SELECT
	    @RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'1196667'			AS [DestinationValue]
GO

---53 - СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен ---------  Пропилен
DECLARE @RuleDictionaryId int = 5371
INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId								AS [RuleDictionaryId],
		N'Products_SpbtPropilen'							AS [RuleDictionaryItemName],
		N'Словарь с продукатми "СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен ---------  Пропилен" для поля Product '	AS [RuleDictionaryDescription]

INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [DestinationValue]
	  )
  
    SELECT
	    @RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'1053729'			AS [DestinationValue]
GO



---53 - СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен ---------  Бутадиен
DECLARE @RuleDictionaryId int = 5372
INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId								AS [RuleDictionaryId],
		N'Products_SpbtButadien'							AS [RuleDictionaryItemName],
		N'Словарь с продукатми "СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен ---------  Бутадиен" для поля Product '	AS [RuleDictionaryDescription]

INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [DestinationValue]
	  )
  
    SELECT
	    @RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'742969'			AS [DestinationValue]
GO



---53 - СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен ---------  Бутилен
DECLARE @RuleDictionaryId int = 5373
INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId								AS [RuleDictionaryId],
		N'Products_SpbtButilen'							AS [RuleDictionaryItemName],
		N'Словарь с продукатми "СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен ---------  Бутилен" для поля Product '	AS [RuleDictionaryDescription]

INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [DestinationValue]
	  )
  
    SELECT
	    @RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'668077'			AS [DestinationValue]
GO




--53 - СПТ Тобольск ТК + БГС


DECLARE @RuleDictionaryId int = 5375
INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId								AS [RuleDictionaryId],
		N'Products_SptTkBgs'							AS [RuleDictionaryItemName],
		N'Словарь с продукатми "СПТ Тобольск ТК + БГС" для поля Product '	AS [RuleDictionaryDescription]

INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [DestinationValue]
	  )
  
    SELECT
	    @RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'1182294'			AS [DestinationValue]
GO


--53 - КАУЧУКи

DECLARE @RuleDictionaryId int = 5378
INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId								AS [RuleDictionaryId],
		N'Products_Kauchuk'							AS [RuleDictionaryItemName],
		N'Словарь с продукатми "КАУЧУКи" для поля Product '	AS [RuleDictionaryDescription]

INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [DestinationValue]
	  )
  
    SELECT
	    @RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'1209656'			AS [DestinationValue]
GO


--53 -  ПЭ-ПП

DECLARE @RuleDictionaryId int = 5380
INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId								AS [RuleDictionaryId],
		N'Products_PE-PP'							AS [RuleDictionaryItemName],
		N'Словарь с продукатми "ПЭ-ПП" для поля Product '	AS [RuleDictionaryDescription]

INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [DestinationValue]
	  )
  
    SELECT
	    @RuleDictionaryId * 100000 + 1	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'159683'			AS [DestinationValue]

	UNION	
    SELECT
	    @RuleDictionaryId * 100000 + 2	AS [RuleDictionaryItemId],
		@RuleDictionaryId	AS [RuleDictionaryId], 
		N'1214791'			AS [DestinationValue]
GO


-- 52

DECLARE @RuleDictionaryId int = 5200 --  ProductGroup
INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )

	SELECT 
		@RuleDictionaryId,
		N'ProductGroup',
		N'Словарь с зависимостью "ProductGroup" от "Product"'

	
INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [SourceValue],
		  [DestinationValue]
	  )

 SELECT
 [RuleDictionaryItemId] = @RuleDictionaryId * 100000 + ROW_NUMBER() OVER(ORDER BY RD.SourceValue ASC),
 [RuleDictionaryId] = @RuleDictionaryId,
 RD.[SourceValue],
 RD.[DestinationValue]

 from
 (
    SELECT
		[SourceValue] = CAST (MaterialCode AS nvarchar(max)),
		[DestinationValue] = CAST (ProductGroupCode AS nvarchar(max))
	from [nkhtk].[TmpProductDictionary] 
 ) AS RD



 GO
 --------

 -- 3

DECLARE @RuleDictionaryId int = 300 --  ETSNGCode
INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )

	SELECT 
		@RuleDictionaryId,
		N'ETSNGCode',
		N'Словарь с зависимостью "ETSNGCode" от "Product"'

	
INSERT INTO  [nkhtk].[RuleDictionaryItem]
	  (
		  [RuleDictionaryItemId],
		  [RuleDictionaryId], 
		  [SourceValue],
		  [DestinationValue]
	  )

 SELECT
 [RuleDictionaryItemId] = @RuleDictionaryId * 100000 + ROW_NUMBER() OVER(ORDER BY RD.SourceValue ASC),
 [RuleDictionaryId] = @RuleDictionaryId,
 RD.[SourceValue],
 RD.[DestinationValue]

 from
 (
    SELECT
		[SourceValue] = CAST (MaterialCode AS nvarchar(max)),
		[DestinationValue] = CAST (ETSNGCode AS nvarchar(max))
	from [nkhtk].[TmpProductDictionary] 
 ) AS RD



 GO
 --------


 
DECLARE @RuleDictionaryId int = 590 -- 1

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId					AS [RuleDictionaryId],
		N'stg_Operation_1'								AS [RuleDictionaryItemName],
		N'Словарь с константами для операции вставки нового значения'			AS [RuleDictionaryDescription]
	
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

GO


 
DECLARE @RuleDictionaryId int = 1000 -- 1

INSERT INTO  [nkhtk].[RuleDictionary]
	  (
		  [RuleDictionaryId],
		  [RuleDictionaryName],
		  [RuleDictionaryDescription]
	  )
    SELECT 
		@RuleDictionaryId					AS [RuleDictionaryId],
		N'ActualRate_0'								AS [RuleDictionaryItemName],
		N'Словарь с константами для актуальности ставки'			AS [RuleDictionaryDescription]
	
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
		N'0'				AS [DestinationValue]

GO

