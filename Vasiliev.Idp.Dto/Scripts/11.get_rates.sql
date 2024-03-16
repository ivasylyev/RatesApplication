-- FUNCTION: public.GetRates()

-- DROP FUNCTION IF EXISTS public."GetRates"();

CREATE FUNCTION public."GetRates"(IN take_limit bigint, IN skip_offset bigint)
    RETURNS table(
		"RateId" bigint,
		"StartDate" date, 
		"EndDate" date, 	
		"Value" numeric,
		"IsDeflated" boolean,
	    "ProductGroupId" bigint,
	    "ProductGroupCode"  character varying(50),
	    "ProductGroupName" character varying(400),
		"NodeFromId" bigint,
	    "NodeFromCode"  character varying(50),
	    "NodeFromName" character varying(400),
		"NodeToId" bigint,
	    "NodeToCode"  character varying(50),
	    "NodeToName" character varying(400)
	) 
    LANGUAGE 'sql'
    
AS $BODY$
    SELECT 
		r."Id" 			AS "RateId",
		r."StartDate" 	AS "StartDate", 
		r."EndDate" 	AS "EndDate", 		
		r."Value" 		AS "Value",
		r."IsDeflated" 	AS "IsDeflated",
		pg."Id"			AS "ProductGroupId",
		pg."Code" 		AS "ProductGroupCode",
		pg."Name" 		AS "ProductGroupName",
		nf."Id"			AS "NodeFromId",
		nf."Code"		AS "NodeFromCode",
		nf."Name"		AS "NodeFromName",
		nt."Id"			AS "NodeToId",
		nt."Code"		AS "NodeToCode",
		nt."Name"		AS "NodeToName"		
   
FROM public."Rate" as r
JOIN public."ProductGroup" pg
    ON pg."Id" = r."ProductGroupId"
JOIN public."LocationNode" nf
    ON nf."Id" = r."NodeFromId"
JOIN public."LocationNode" nt
    ON nt."Id" = r."NodeToId"
    LIMIT take_limit OFFSET skip_offset
$BODY$;

ALTER FUNCTION public."GetRates"(bigint, bigint)
    OWNER TO postgres;