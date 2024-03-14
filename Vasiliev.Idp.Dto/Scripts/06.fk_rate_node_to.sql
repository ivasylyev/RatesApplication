ALTER TABLE IF EXISTS public."Rate"
    ADD CONSTRAINT "FK_RateNodeTo" FOREIGN KEY ("NodeToId")
    REFERENCES public."LocationNode" ("Id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;
CREATE INDEX IF NOT EXISTS "fki_FK_RateNodeTo"
    ON public."Rate"("NodeToId");