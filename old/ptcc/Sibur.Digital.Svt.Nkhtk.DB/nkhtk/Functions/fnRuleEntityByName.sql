

	
-- =============================================
-- Author:		Ivan Vasilev
-- Create date: 2022-07-12
-- Description:	Возвращает идентификатор коллекции элементов шаблона по его имени
-- =============================================

CREATE   FUNCTION [nkhtk].[fnRuleEntityByName] 
(
	@name nvarchar(700)
)
RETURNS int
AS
BEGIN
	DECLARE @Id int

	SELECT @id = [RuleEntityId]
	FROM [nkhtk].[RuleEntity]
	WHERE [RuleEntityName] = @name

	IF (@id IS NULL)
		DECLARE @i INT = CAST((N'Не найден идентификатор для "' + ISNULL(@name, '') + '"') AS INT)


	RETURN @id
END