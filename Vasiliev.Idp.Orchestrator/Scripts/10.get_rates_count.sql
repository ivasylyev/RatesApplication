-- FUNCTION: public.GetRatesCount()

-- DROP FUNCTION IF EXISTS public."GetRatesCount"();

CREATE OR REPLACE FUNCTION public."GetRatesCount"(
	)
    RETURNS bigint
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
SELECT COUNT (*)	FROM public."Rate"
$BODY$;

ALTER FUNCTION public."GetRatesCount"()
    OWNER TO postgres;
