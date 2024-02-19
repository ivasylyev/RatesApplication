USE [mdm_integ]
GO

/****** Object:  Table [nkhtk].[Template]    Script Date: 07.07.2022 14:53:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER TABLE [nkhtk].[Template]
	ADD  [TemplateTypeId] [int] NULL 
GO

UPDATE [nkhtk].[Template]
SET [TemplateTypeId] = 1
WHERE [TemplateTypeId] = 0 OR [TemplateTypeId] IS NULL

GO


ALTER TABLE [nkhtk].[Template]  WITH CHECK ADD  CONSTRAINT [FK_Template_TemplateType_Id] FOREIGN KEY([TemplateTypeId])
REFERENCES [nkhtk].[TemplateType] ([TemplateTypeId])
GO

ALTER TABLE [nkhtk].[Template] CHECK CONSTRAINT [FK_Template_TemplateType_Id]
GO