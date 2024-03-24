-- View: public.FullRates

-- DROP VIEW public."FullRates";

CREATE OR REPLACE VIEW public."FullRates"
 AS
 SELECT r."Id" AS "RateId",
    r."StartDate",
    r."EndDate",
    r."Value",
    r."IsDeflated",
    pg."Id" AS "ProductGroupId",
    pg."Code" AS "ProductGroupCode",
    pg."Name" AS "ProductGroupName",
    nf."Id" AS "NodeFromId",
    nf."Code" AS "NodeFromCode",
    nf."Name" AS "NodeFromName",
    nt."Id" AS "NodeToId",
    nt."Code" AS "NodeToCode",
    nt."Name" AS "NodeToName"
   FROM "Rate" r
     JOIN "ProductGroup" pg ON pg."Id" = r."ProductGroupId"
     JOIN "LocationNode" nf ON nf."Id" = r."NodeFromId"
     JOIN "LocationNode" nt ON nt."Id" = r."NodeToId";

ALTER TABLE public."FullRates"
    OWNER TO postgres;

