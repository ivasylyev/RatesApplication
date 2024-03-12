-- Table: public.RateData

-- DROP TABLE IF EXISTS public."RateData";

CREATE TABLE IF NOT EXISTS public."RateData"
(
    "RateId" bigint NOT NULL DEFAULT nextval('"RateData_RateId_seq"'::regclass),
    "StartDate" date NOT NULL,
    "EndDate" date NOT NULL,
    "NodeFromId" bigint NOT NULL,
    "NodeToId" bigint NOT NULL,
    "ProductGroupId" bigint NOT NULL,
    "Value" numeric NOT NULL,
    "IsDeflated" bit(1) NOT NULL,
    CONSTRAINT "RateData_pkey" PRIMARY KEY ("RateId")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."RateData"
    OWNER to postgres;