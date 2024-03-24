-- FUNCTION: public.GetRatesCount()

-- DROP FUNCTION IF EXISTS public."GetNonDeflatedRatesCount"();

CREATE OR REPLACE FUNCTION public."GetNonDeflatedRatesCount"(
	)
    RETURNS bigint
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
SELECT COUNT (*)	FROM public."Rate" WHERE "IsDeflated" = FALSE
$BODY$;

ALTER FUNCTION public."GetRatesCount"()
    OWNER TO postgres;
