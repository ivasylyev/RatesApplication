
-- =============================================
-- Author:		Ivan Vasilev
-- Create date: 2022-07-12
-- Description:	Возвращает идентификатор типа данных, которыми оперирует правило, по имени типа данных
-- =============================================
CREATE   FUNCTION [nkhtk].[fnRuleDataTypeByName] 
(
	@name nvarchar(700)
)
RETURNS int
AS
BEGIN
	DECLARE @Id int

	SELECT @id = [RuleDataTypeId]
	FROM [nkhtk].[RuleDataType]
	WHERE [RuleDataTypeName] = @name

	IF (@id IS NULL)
		DECLARE @i INT = CAST((N'Не найден идентификатор для "' + ISNULL(@name, '') + '"') AS INT)


	RETURN @id
END