USE [mdm_integ]
GO


DECLARE @OldMaxRuleDictionaryId BIGINT
DECLARE @RuleDictionaryId BIGINT
DECLARE @Nodes TABLE (
                        SourceValue nvarchar(max),
                        DestinationValue nvarchar(max)
                     )

SELECT @RuleDictionaryId = RuleDictionaryId FROM [nkhtk].[RuleDictionary] WHERE RuleDictionaryName = N'NodesDictionary'
SELECT @OldMaxRuleDictionaryId = RuleDictionaryItemId FROM [nkhtk].[RuleDictionaryItem] WHERE RuleDictionaryId = @RuleDictionaryId AND SourceValue = N'Ярцево'

INSERT INTO @Nodes (SourceValue,  DestinationValue)
VALUES
         ('Громово', 'R022705')
        ,('ГРЭС', 'R773402')
        ,('Железнодорожная', 'R230402')
        ,('Заднепровская', 'R157809')
        ,('Злобино', 'R891806')
        ,('Икша', 'R238103')
        ,('Лиски', 'R582005')
        ,('Наливная', 'R626203')
        ,('Орловка', 'R610506')
        ,('Прохладная', 'R537601')
        ,('Пушкино', 'R235904')
        ,('Савелово', 'R050300')
        ,('Суворовская', 'R531605')
        ,('Титан', 'R015805')
        ,('Энергетик', 'R211505')




IF (@RuleDictionaryId) IS NULL
    RAISERROR ('отсутсвует  словарь местоположений ', 16, 1)
IF (@OldMaxRuleDictionaryId) IS NULL
    RAISERROR ('В словаре местоположений отсутсвует узел "Ярцево"', 16, 1)


MERGE  [nkhtk].[RuleDictionaryItem] AS trg
USING (
    SELECT
        ROW_NUMBER() OVER (ORDER BY SourceValue ASC) + @OldMaxRuleDictionaryId
                            AS RuleDictionaryItemId,
        @RuleDictionaryId   AS RuleDictionaryId, 
        SourceValue         AS SourceValue,
        DestinationValue    AS DestinationValue
    FROM @Nodes

) AS src (RuleDictionaryItemId, RuleDictionaryId, SourceValue, DestinationValue)
    ON (trg.RuleDictionaryItemId = src.RuleDictionaryItemId
        AND trg.RuleDictionaryId = src.RuleDictionaryId)
WHEN MATCHED  THEN
    UPDATE SET trg.SourceValue = src.SourceValue,
               trg.DestinationValue = src.DestinationValue
WHEN NOT MATCHED BY TARGET THEN
    INSERT (RuleDictionaryItemId, RuleDictionaryId, SourceValue, DestinationValue) 
    VALUES (src.RuleDictionaryItemId, src.RuleDictionaryId, src.SourceValue, src.DestinationValue)
;

GO
