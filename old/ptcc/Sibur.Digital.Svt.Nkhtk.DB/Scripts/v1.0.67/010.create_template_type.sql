USE [mdm_integ]
GO

/****** Object:  Table [nkhtk].[TemplateType]    Script Date: 07.07.2022 14:53:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [nkhtk].[TemplateType](
	[TemplateTypeId] [int] NOT NULL,
	[TemplateTypeEnglishName] [nvarchar](700) NOT NULL,
	[TemplateTypeRussianName] [nvarchar](700) NOT NULL,
	 CONSTRAINT [PK_TemplateType_Id] PRIMARY KEY CLUSTERED 
	(
		[TemplateTypeId] ASC
	),
	CONSTRAINT UC_TemplateType_EnglishName UNIQUE 
	(
		[TemplateTypeEnglishName]
	),
	CONSTRAINT UC_TemplateType_RussianName UNIQUE 
	(
		[TemplateTypeRussianName]
	)
)
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Тип исходных шаблонов для последующего преобразования в шаблон СВТ' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'TemplateType'
GO



EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Уникальный идентификатор типа шаблона' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'TemplateType', @level2type=N'COLUMN',@level2name=N'TemplateTypeId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Имя типа шаблона на английском языке' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'TemplateType', @level2type=N'COLUMN',@level2name=N'TemplateTypeEnglishName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Имя типа шаблона на русском языке' , @level0type=N'SCHEMA',@level0name=N'nkhtk', @level1type=N'TABLE',@level1name=N'TemplateType', @level2type=N'COLUMN',@level2name=N'TemplateTypeRussianName'
GO

INSERT INTO   [nkhtk].[TemplateType]
 ([TemplateTypeId], [TemplateTypeEnglishName], [TemplateTypeRussianName] )

SELECT 
		1		AS [TemplateTypeId], 
		N'NHTK'	AS [TemplateTypeEnglishName],
		N'НХТК'	AS [TemplateTypeRussianName]
UNION
	SELECT 
		2,		
		N'MultiModal',		
		N'Мультимодальный - ставки'
UNION
	SELECT 
		3,		
		N'MultiModalSpecial',		
		N'Мультимодальный - спец ставки'

GO