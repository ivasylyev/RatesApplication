ALTER TABLE IF EXISTS public."Rate"
    ADD CONSTRAINT "FK_RateNodeFrom" FOREIGN KEY ("NodeFromId")
    REFERENCES public."LocationNode" ("Id") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;
CREATE INDEX IF NOT EXISTS "fki_FK_RateNodeFrom"
    ON public."Rate"("NodeFromId");