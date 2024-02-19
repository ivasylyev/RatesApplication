
-- =============================================
-- Author:		Ivan Vasilev
-- Create date: 2022-07-12
-- Description:	Возвращает идентификатор вида правила по его имени
-- =============================================

CREATE   FUNCTION [nkhtk].[fnRuleKindByName] 
(
	@name nvarchar(700)
)
RETURNS int
AS
BEGIN
	DECLARE @Id int

	SELECT @id = [RuleKindId]
	FROM [nkhtk].[RuleKind]
	WHERE [RuleKindName] = @name

	IF (@id IS NULL)
		DECLARE @i INT = CAST((N'Не найден идентификатор для "' + ISNULL(@name, '') + '"') AS INT)


	RETURN @id
END