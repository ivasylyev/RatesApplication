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
    -- Ваш код хранимой процедуры здесь
    -- Например, просто выводим переданные параметры
    RAISE NOTICE 'Параметр nodeFromId: %', node_from_id;
   
END;
$$ LANGUAGE plpgsql;

ALTER PROCEDURE public."SaveRate"(bigint, bigint, bigint, date, date, numeric, boolean)
    OWNER TO postgres;
