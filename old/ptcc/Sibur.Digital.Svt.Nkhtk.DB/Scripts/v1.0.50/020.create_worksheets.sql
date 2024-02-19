USE [mdm_integ]
GO

/****** Object:  Table [nkhtk].[Worksheet]    Script Date: 07.07.2022 14:53:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [nkhtk].[Worksheet](
	[WorksheetId] [int] NOT NULL,
	[TemplateId] [int] NOT NULL,
	[WorksheetName] [nvarchar](4000) NOT NULL,
	 CONSTRAINT [PK_Worksheet_Id] PRIMARY KEY CLUSTERED 
	(
		[WorksheetId] ASC
	)
)
GO


ALTER TABLE [nkhtk].[Worksheet]  WITH CHECK ADD  CONSTRAINT [FK_Worksheet_Template_Id] FOREIGN KEY([TemplateId])
REFERENCES [nkhtk].[Template] ([TemplateId])
GO

ALTER TABLE [nkhtk].[Worksheet] CHECK CONSTRAINT [FK_Worksheet_Template_Id]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Вкладка excel файла исходного шаблона НХТК для последующего преобразования в шаблон СВТ' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'Worksheet'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Уникальный идентификатор вкладки шаблона' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'Worksheet', @level2type=N'COLUMN',@level2name=N'WorksheetId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Идентификатор шаблона-источника, к которому принадлежит вкладка' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'Worksheet', @level2type=N'COLUMN',@level2name=N'TemplateId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Имя вкладки шаблона' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'Worksheet', @level2type=N'COLUMN',@level2name=N'WorksheetName'
GO


INSERT INTO  [nkhtk].[Worksheet]
	  (
		  [WorksheetId], 
		  [WorksheetName],
		  [TemplateId]
	  )

  -- 06 – СУГ-1
    SELECT 
		1001					AS [WorksheetId], 
		N'Ставки'				AS [WorksheetName],
		1001					AS [TemplateId]
	UNION
	SELECT 
		1002,				
		N'Ставки без охраны',
		1001					
    UNION
	SELECT 
		1003,				
		N'Спецставка',		
		1001					
   
   
   
     -- 06 – СУГ-2 - фракция пент изопент
	 UNION
    SELECT 
		2001,				
		N'Ставки',			
		2001				


	-- 06 – СУГ-3 - бутадиен
   	 UNION
       SELECT 
		3101,				
		N'Ставки',			
		3101				
	UNION
	SELECT 
		3102,				
		N'СпецСтавки',		
		3101					
   
   --- 06 – СУГ-3 - пропилен, (изо-)бутилен, изопрен,БДФ
      UNION
	  SELECT 
		3201,					
		N'Пропилен, изобутилен',	
		3201					
	UNION
	SELECT 
		3202,					
		N'изобутилен до 720 км со скидкой',	
		3201					
    UNION
	SELECT 
		3203,					
		N'Бутилен, изопрен, БДФ',	
		3201					
   
   ---ШФЛУ

   
   UNION
       SELECT 
		5001,			
		N'повагонная',	
		5001			
	UNION
	SELECT 
		5002,			
		N'более 20',		
		5001			
    UNION
	SELECT 
		5003,			
		N'ПОМ',			
		5001			
   UNION
	SELECT 
		5004,			
		N'Спецставка',	
		5001			

		-- 06 – НБ-1 - Бензол эфир спирт и т.д. с 01.06.2022
   UNION
	SELECT 
		6001,							
		N'Ставки',						
		6001							
    UNION
	SELECT 
		6002,							
		N'Ставки со скидкой на 720 км',	
		6001							
    UNION
	SELECT 
		6003,			
		N'МТБЭ Сургут',	
		6001			
    UNION
	SELECT 
		6004,			
		N'МТБЭ Сахалин',	
		6001			
    UNION
	SELECT 
		6005,			
		N'Стирол',		
		6001			
    UNION
	SELECT 
		6006,			
		N'Гликоли',		
		6001			
    UNION
	SELECT 
		6007,			
		N'Гликоли КЛН',	
		6001			



	---	06 – НБ-2 - ЖПП СПТ и т.д
	 UNION
	SELECT 
		7101,					
		N'ставки 2022',			
		7101					
    UNION
	SELECT 
		7102,					
		N'Сахалин 2022 ИНДИКАТИВ',
		7101					
    
	-- 06 – НБ-2 - химия
		 UNION
	SELECT 
		7201,					
		N'ставки',			
		7201     
    UNION
	SELECT 
		7202,
		N'Ставки со скидкой на расст.  ап',
		7201     
    

	-- 06 – НБ-3 - БГС
	  UNION
	SELECT 
		8001, 
		N'БГС',
		8001
    UNION
	SELECT 
		8002, 
		N'БГС  более 20',
		8001
    UNION
	SELECT 
		8003, 
		N'ПОМ',
		8001    



		-- 06 – НБ-5 Натрия гидроксид, каустики
		  UNION
	SELECT 
		10001, 
		N'ставки',
		10001    

		-- 06 – НБ-7
		  UNION
	SELECT 
		11001,				
		N'ставки',		
		11001				

	-- 06 – НБ-8
		  UNION
	SELECT 
		12001,				
		N'ставки',		
		12001				


-- СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен
UNION
	SELECT 
		20001,				
		N'2022 ПБТ',		
		20001

UNION
	SELECT 
		20002,				
		N'2022 Пропилен',		
		20001

UNION
	SELECT 
		20003,				
		N'2022  Пропилен экспорт',		
		20001
UNION
	SELECT 
		20004,					
		N'2022 Бутадиен',		
		20001
UNION
	SELECT 
		20005,				
		N'2022 Бутилен (Бутен)',		
		20001


--- СПТ Тобольск ТК + БГС
UNION
	SELECT 
		21001,				
		N'СПТ',		
		21001

UNION
	SELECT 
		21002,				
		N'СПТ экспорт',		
		21001



-- КАУЧУКи с ВС
UNION
	SELECT 
		22001,				
		N'Каучуки руб | ваг АТЛАНТ',		
		22001

UNION
	SELECT 
		22002,				
		N'Каучуки руб | ваг РСТ',		
		22001

	


--- ПЭ-ПП с ВС ИНДИКАТИВ



UNION
	SELECT 
		23001,				
		N'ПЭ-ПП ПГК 122-175',		
		23001

UNION
	SELECT 
		23002,				
		N'ПЭ-ПП ПГК 150-175',		
		23001

UNION
	SELECT 
		23003,				
		N'ПЭ-ПП АНТАНТ',		
		23001
UNION
	SELECT 
		23004,					
		N'ПЭ-ПП РСТ',		
		23001
	UNION
SELECT 
		23005,					
		N'ПЭ-ПП Евросиб',		
		23001	
	GO