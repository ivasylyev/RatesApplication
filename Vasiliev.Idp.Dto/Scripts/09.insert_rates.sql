
INSERT INTO public."Rate"
	("StartDate", "EndDate", "NodeFromId", "NodeToId", "ProductGroupId", "Value", "IsDeflated")	
	
SELECT 
	TO_DATE('2024-01-01', 'YYYY-MM-DD') AS "StartDate",
	TO_DATE('2024-12-31','YYYY-MM-DD') AS "EndDate",
	n1."Id" AS "NodeFromId",
	n2."Id" AS "NodeToId",
	pg."Id" AS "ProductGroupId",
	1000 * n1."Id" + 10*n2."Id" + pg."Id" + 100.5 AS  "Value",
	FALSE AS "IsDeflated"
 
FROM public."LocationNode" as n1
JOIN  public."LocationNode" as  n2
ON TRUE
JOIN public."ProductGroup" as pg
ON TRUE