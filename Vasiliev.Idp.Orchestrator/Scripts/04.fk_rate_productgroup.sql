ALTER TABLE IF EXISTS public."Rate"
    ADD CONSTRAINT "FK_RateProductGroup" FOREIGN KEY ("ProductGroupId")
    REFERENCES public."ProductGroup" ("Id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;
CREATE INDEX IF NOT EXISTS "fki_FK_RateProductGroup"
    ON public."Rate"("ProductGroupId");