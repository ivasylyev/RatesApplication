
-- =============================================
-- Author:		Ivan Vasilev
-- Create date: 2022-07-12
-- Description:	Возвращает идентификатор словаря по его имени
-- =============================================

CREATE   FUNCTION [nkhtk].[fnRuleDictionaryByName] 
(
	@name nvarchar(700)
)
RETURNS int
AS
BEGIN
	DECLARE @Id int

	SELECT @id = [RuleDictionaryId]
	FROM [nkhtk].[RuleDictionary]
	WHERE [RuleDictionaryName] = @name

	IF (@id IS NULL)
		DECLARE @i INT = CAST((N'Не найден идентификатор для "' + ISNULL(@name, '') + '"') AS INT)


	RETURN @id
END