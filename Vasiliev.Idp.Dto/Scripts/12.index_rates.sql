CREATE UNIQUE INDEX "UK_Rate_Nodes_PG_Dates" 
ON public."Rate" ("NodeFromId","NodeToId","ProductGroupId","StartDate","EndDate")
INCLUDE ("Value", "IsDeflated")