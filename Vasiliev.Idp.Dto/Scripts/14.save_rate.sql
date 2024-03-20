-- PROCEDURE: public.SaveRates(json)

-- DROP PROCEDURE IF EXISTS public."SaveRates"(json);


CREATE OR REPLACE PROCEDURE public."SaveRates"(rates json) AS $$
BEGIN
	DROP TABLE IF EXISTS temp_rates;
	
    CREATE TEMP TABLE temp_rates (
		"StartDate" date NOT NULL,
		"EndDate" date NOT NULL,
		"NodeFromId" bigint NOT NULL,
		"NodeToId" bigint NOT NULL,
		"ProductGroupId" bigint NOT NULL,
		"Value" numeric NOT NULL,
		"IsDeflated" boolean NOT NULL		
    );
INSERT INTO temp_rates ("StartDate", "EndDate", "NodeFromId", "NodeToId", "ProductGroupId", "Value", "IsDeflated")
    SELECT
		(json_data->>'start_date')::date,
		(json_data->>'end_date')::date,
       	(json_data->>'node_from_id')::bigint,
		(json_data->>'node_to_id')::bigint,
		(json_data->>'product_group_id')::bigint,			
       	(json_data->>'value')::numeric,
		(json_data->>'is_deflated')::boolean
    FROM json_array_elements(rates) AS json_data;
	
MERGE INTO public."Rate" AS r
	USING temp_rates AS d
	ON r."NodeFromId" = d."NodeFromId"
		AND r."NodeToId" = d."NodeToId"
		AND r."ProductGroupId" = d."ProductGroupId"
		AND r."StartDate" = d."StartDate"
		AND r."EndDate" = d."EndDate"		
   	WHEN MATCHED 
   		AND (r."Value" <> d."Value" OR  r."IsDeflated" <> d."IsDeflated")
		THEN
   	UPDATE SET "Value" = d."Value",
   			  "IsDeflated" = d."IsDeflated"	
	WHEN NOT MATCHED
		THEN
	  	INSERT ("StartDate", "EndDate", "NodeFromId", "NodeToId", "ProductGroupId", "Value", "IsDeflated")
	  	VALUES (d."StartDate", d."EndDate", d."NodeFromId", d."NodeToId", d."ProductGroupId", d."Value", d."IsDeflated")
	;

END;
$$ LANGUAGE plpgsql;

ALTER PROCEDURE public."SaveRates"(json)
    OWNER TO postgres;