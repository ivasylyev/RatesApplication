-- Table: public.LocationNode

-- DROP TABLE IF EXISTS public."LocationNode";

CREATE TABLE IF NOT EXISTS public."LocationNode"
(
    "Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY,
    "Code" character varying(50) COLLATE pg_catalog."default" NOT NULL,
    "Name" character varying(400) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "LocationNode_pkey" PRIMARY KEY ("Id"),
    CONSTRAINT LocationNode_id_ukey UNIQUE ("Id")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."LocationNode"
    OWNER to postgres;