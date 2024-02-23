WITH routes AS (
WITH RECURSIVE tsp AS (
	SELECT 
		point1,
		point2,
		cost,
		1 AS lvl,
		ARRAY[point1] AS path, 
		FALSE AS cycle, 
		ARRAY[cost] AS costs
	FROM nodes
	WHERE point1 = 'a'
	UNION ALL
	SELECT
		nodes.point1,
		nodes.point2,
		nodes.cost + tsp.cost AS cost,
		tsp.lvl + 1 AS lvl,
		tsp.path || nodes.point1 AS path,
		nodes.point1 = ANY(tsp.path) AS cycle,
		tsp.costs || nodes.cost AS costs
	FROM nodes
	JOIN tsp ON nodes.point1 = tsp.point2 
	WHERE NOT tsp.cycle              
)                       
SELECT 
	cost - costs[5] AS total_cost,
	path AS tour
FROM tsp
WHERE lvl = 5
	AND 'a' = ANY(path)
	AND 'b' = ANY(path)
	AND 'c' = ANY(path)
	AND 'd' = ANY(path)
	AND path[1] = path[5]
ORDER BY 1, 2
)

SELECT DISTINCT * 
FROM routes
WHERE total_cost = (SELECT MIN(total_cost) FROM routes)
OR total_cost = (SELECT MAX(total_cost) FROM routes)
ORDER BY 1, 2;