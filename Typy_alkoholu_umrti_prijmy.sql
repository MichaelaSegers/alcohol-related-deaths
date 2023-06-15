-- Je konzumace piva a vína nejvyšší ve státech, které jsou vnímány jako pro ně typické?
-- Souvisí typ preferovaného alkoholu s počtem úmrtí?
-- Souvisí typ preferovaného alkoholu s příjmovou kategorií?

SELECT *
FROM alcohol_consumed_by_type_2016 acbt
ORDER BY beer_share DESC;

SELECT *
FROM alcohol_consumed_by_type_2016 acbt
ORDER BY beer_consumption DESC;

SELECT *
FROM alcohol_consumed_by_type_2016 acbt
ORDER BY wine_share DESC;

SELECT *
FROM alcohol_consumed_by_type_2016 acbt
ORDER BY wine_consumption DESC;

SELECT
	dau.location,
	dau.val,
	acbt.beer_share,
	acbt.wine_share,
	acbt.spirits_share 
FROM deaths_alcohol_use dau
LEFT JOIN alcohol_consumed_by_type_2016 acbt
	ON dau.location = acbt.entity
WHERE dau.sex = 'Both'
	AND dau.metric = 'Percent'
	AND dau.`year` = 2016
ORDER BY dau.val DESC;
/* nevidím souvislost mezi podílem alkoholu na celkových úmrtích
 * a typem preferovaného alkoholu v zemi */

SELECT 
	acbt.entity,
	c.income_group, 
	acbt.beer_share,
	acbt.wine_share,
	acbt.spirits_share
FROM alcohol_consumed_by_type_2016 acbt 
LEFT JOIN countries c 
	ON acbt.entity = c.table_name 
	;

SELECT 
	c.income_group,
	ROUND(AVG(acbt.beer_share), 2) AS avg_beer_share,
	ROUND(AVG(acbt.wine_share), 2) AS avg_wine_share,
	ROUND(AVG(acbt.spirits_share), 2) AS avg_spirits_share
FROM alcohol_consumed_by_type_2016 acbt 
LEFT JOIN countries c 
	ON acbt.entity = c.table_name 
WHERE c.income_group IS NOT NULL 
GROUP BY c.income_group;
/* Preference piva ve všech kategoriích podobná,
 * preference vína vyšší, čím vyšší příjmy,
 * preference tvrdého alkoholu různá */

SELECT 
	c.income_group,
	ROUND(AVG(acbt.beer_consumption), 2) AS avg_beer_consumption,
	ROUND(AVG(acbt.wine_consumption), 2) AS avg_wine_consumption,
	ROUND(AVG(acbt.spirits_consumption), 2) AS avg_spirits_consumption
FROM alcohol_consumed_by_type_2016 acbt 
LEFT JOIN countries c 
	ON acbt.entity = c.table_name 
WHERE c.income_group IS NOT NULL 
GROUP BY c.income_group;
/* U všech typů alkoholu - čím vyšší příjmy,
tím vyšší spotřeba */