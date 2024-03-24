-- Table: public.ProductGroup

-- DROP TABLE IF EXISTS public."ProductGroup";

CREATE TABLE IF NOT EXISTS public."ProductGroup"
(
    "Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY,
    "Code" character varying(50) COLLATE pg_catalog."default" NOT NULL,
    "Name" character varying(400) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "ProductGroup_pkey" PRIMARY KEY ("Id"),
    CONSTRAINT ProductGroup_id_ukey UNIQUE ("Id")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."ProductGroup"
    OWNER to postgres;