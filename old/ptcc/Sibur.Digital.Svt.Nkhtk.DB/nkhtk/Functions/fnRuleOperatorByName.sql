

		
-- =============================================
-- Author:		Ivan Vasilev
-- Create date: 2022-07-12
-- Description:	Возвращает идентификатор оператора, применяемый к данным, которыми оперирует правло, по его имени
-- =============================================
CREATE   FUNCTION [nkhtk].[fnRuleOperatorByName] 
(
	@name nvarchar(700)
)
RETURNS int
AS
BEGIN
	DECLARE @Id int

	SELECT @id = [RuleOperatorId]
	FROM [nkhtk].[RuleOperator]
	WHERE [RuleOperatorName] = @name

	IF (@id IS NULL)
		DECLARE @i INT = CAST((N'Не найден идентификатор для "' + ISNULL(@name, '') + '"') AS INT)

	RETURN @id
END