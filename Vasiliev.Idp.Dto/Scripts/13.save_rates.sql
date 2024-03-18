-- PROCEDURE: public.SaveRate(bigint, bigint, bigint, date, date, numeric, boolean)

-- DROP PROCEDURE IF EXISTS public."SaveRate"(bigint, bigint, bigint, date, date, numeric, boolean);

CREATE OR REPLACE PROCEDURE public."SaveRate"(
	IN "nodeFromId" bigint,
	IN "nodeToId" bigint,
	IN "productGroupId" bigint,
	IN "startDate" date,
	IN "endDate" date,
	IN "val" numeric,
	IN "isDeflated" boolean)
LANGUAGE 'sql'
AS $BODY$
SELECT 1
$BODY$;
ALTER PROCEDURE public."SaveRate"(bigint, bigint, bigint, date, date, numeric, boolean)
    OWNER TO postgres;
