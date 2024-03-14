-- Table: public.Rate

-- DROP TABLE IF EXISTS public."Rate";

CREATE TABLE IF NOT EXISTS public."Rate"
(
    "Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY,
    "StartDate" date NOT NULL,
    "EndDate" date NOT NULL,
    "NodeFromId" bigint NOT NULL,
    "NodeToId" bigint NOT NULL,
    "ProductGroupId" bigint NOT NULL,
    "Value" numeric NOT NULL,
    "IsDeflated" bit(1) NOT NULL,
    CONSTRAINT "Rate_pkey" PRIMARY KEY ("Id"),
      CONSTRAINT Rate_id_ukey UNIQUE ("Id")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Rate"
    OWNER to postgres;