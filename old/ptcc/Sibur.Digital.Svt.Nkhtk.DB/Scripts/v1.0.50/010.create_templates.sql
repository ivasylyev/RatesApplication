USE [mdm_integ]
GO

/****** Object:  Table [nkhtk].[Template]    Script Date: 07.07.2022 14:53:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [nkhtk].[Template](
	[TemplateId] [int] NOT NULL,
	[TemplateEnglishName] [nvarchar](700) NOT NULL,
	[TemplateRussianName] [nvarchar](700) NOT NULL,
	 CONSTRAINT [PK_Template_Id] PRIMARY KEY CLUSTERED 
	(
		[TemplateId] ASC
	),
	CONSTRAINT UC_Template_EnglishName UNIQUE 
	(
		[TemplateEnglishName]
	),
	CONSTRAINT UC_Template_RussianName UNIQUE 
	(
		[TemplateRussianName]
	)
)
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Исходный шаблон НХТК для последующего преобразования в шаблон СВТ' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'Template'
GO



EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Уникальный идентификатор шаблона' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'Template', @level2type=N'COLUMN',@level2name=N'TemplateId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Имя шаблона на английском языке' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'Template', @level2type=N'COLUMN',@level2name=N'TemplateEnglishName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Имя шаблона на русском языке' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'Template', @level2type=N'COLUMN',@level2name=N'TemplateRussianName'
GO

INSERT INTO   [nkhtk].[Template]
 ([TemplateId], [TemplateEnglishName], [TemplateRussianName] )

SELECT 
		1001	AS [TemplateId], 
		N'SUG-1'	AS [TemplateEnglishName],
		N'СУГ-1'	AS [TemplateRussianName]
UNION
	SELECT 
		2001,		
		N'SUG-2',		
		N'СУГ-2 - фракция пент изопент'
UNION
	SELECT 
		3101, 
		N'SUG-3-1',
		N'СУГ-3 - бутадиен'
UNION
	SELECT 
		3201, 
		N'SUG-3-2',
		N'СУГ-3 - пропилен, (изо-)бутилен, изопрен, БДФ'
UNION
	SELECT 
		5001, 
		N'SHFLU',
		N'ШФЛУ'		
UNION

	SELECT 
		6001, 
		N'HB-1',
		N'НБ-1 - Бензол эфир спирт'

UNION
	SELECT 
		7101,			
		N'HB-2-1',		
		N'НБ-2 - ЖПП СПТ'
UNION
	SELECT 
		7201,			
		N'HB-2-2',		
		N'НБ-2 - химия'	
UNION
	SELECT 
		8001,			
		N'HB-3',			
		N'НБ-3 - БГС'	
UNION
	SELECT 
		10001,			
		N'HB-5',			
		N'НБ-5 Натрия гидроксид, каустики'
UNION
	SELECT 
		11001,		
		N'HB-7',		
		N'НБ-7'		

UNION
	SELECT 
		12001,		
		N'HB-8',		
		N'НБ-8'

		
UNION
	SELECT 
		15001,		
		N'TK_RF',		
		N'ТК РФ'

UNION
	SELECT 
		20001,		
		N'SPBT-1',		
		N'СПБТ-Нягань-ТК Тобольск Бутадиен-ТК Биклянь - Бутен'
UNION
	SELECT 
		21001,		
		N'SPT-1',		
		N'СПТ Тобольск ТК + БГС'
UNION
	SELECT 
		22001,		
		N'Kauchuk',		
		N'КАУЧУКи'
UNION
	SELECT 
		23001,		
		N'PE-PP',		
		N'ПЭ-ПП'



GO