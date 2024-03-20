-- PROCEDURE: public.SaveRate(bigint, bigint, bigint, date, date, numeric, boolean)

-- DROP PROCEDURE IF EXISTS public."SaveRate"(bigint, bigint, bigint, date, date, numeric, boolean);


CREATE OR REPLACE PROCEDURE public."SaveRate"(
	IN node_from_id bigint,
	IN node_to_id bigint,
	IN product_group_id bigint,
	IN start_date date,
	IN end_date date,
	IN val numeric,
	IN is_deflated boolean)
AS $$

BEGIN

	MERGE INTO public."Rate" AS r
	USING (
		SELECT 
		node_from_id 	AS "NodeFromId",
		node_to_id		AS "NodeToId",
		product_group_id AS "ProductGroupId",
		start_date 		AS "StartDate",
		end_date		AS "EndDate",
		val				AS "Value",
		is_deflated		AS "IsDeflated"
	) AS d
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

ALTER PROCEDURE public."SaveRate"(bigint, bigint, bigint, date, date, numeric, boolean)
    OWNER TO postgres;
