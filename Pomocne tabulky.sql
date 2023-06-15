SELECT *
FROM deaths_alcohol_use dau;

-- Průměrný počet úmrtí souvisejících s alkoholem dle země:
SELECT
	location AS country,
	ROUND(AVG(val)) AS average_deaths_yearly
FROM deaths_alcohol_use dau
GROUP BY location
ORDER BY val DESC;

-- Tvorba nové tabulky - počet úmrtí souvisejících s alkoholem na 1000 obyvatel:
SELECT 
	dau.location,
	dau.`year`,
	dau.val,
	c.income_group,
	p.population,
	(1000 * dau.val / p.population) AS alc_death_per_1000popul
FROM deaths_alcohol_use dau
LEFT JOIN countries c
	ON dau.location = c.table_name
LEFT JOIN population p 
	ON dau.location = p.country_name 
	AND dau.`year` = p.`year`
WHERE dau.metric = 'Number' 
ORDER BY (dau.val / p.population) DESC;
	
CREATE OR REPLACE TABLE alcohol_death_by_population AS
	SELECT 
		dau.location,
		dau.`year`,
		dau.val,
		c.income_group,
		p.population,
		(1000 * dau.val / p.population) AS alc_death_per_1000popul
	FROM deaths_alcohol_use dau
	LEFT JOIN countries c
		ON dau.location = c.table_name
	LEFT JOIN population p 
		ON dau.location = p.country_name 
		AND dau.`year` = p.`year`
	WHERE dau.metric = 'Number' 
		AND dau.sex = 'Both'
	;

SELECT *
FROM alcohol_death_by_population adbp;


-- Tvorba tabulky se souhrnem konzumace typů alkoholu (v litrech čistého alk.)
SELECT *
FROM beer_consumption bc;

SELECT 
	bpc.entity,
	bpc.code,
	bpc.`year`,
	bpc.beer_percent_consumption,
	wpc.percent_wine_consumption,
	spc.percent_consumption_spirits 
FROM beer_percent_consumption bpc
LEFT JOIN wine_percent_consumption wpc 
	ON bpc.code = wpc.code 
	AND bpc.`year` = wpc.`year`
LEFT JOIN spirits_percent_consumption spc 
	ON bpc.code = spc.code 
	AND bpc.`year` = spc.`year` ;
	


CREATE OR REPLACE TABLE alcohol_consumed_by_type AS
	SELECT 
		bpc.entity,
		bpc.code,
		bpc.`year`,
		bc.beer_consumption,
		ROUND(bpc.beer_percent_consumption, 2) AS beer_share,
		wc.wine_consumption,
		ROUND(wpc.percent_wine_consumption, 2) AS wine_share,
		sc.spirits_consumption,
		ROUND(spc.percent_consumption_spirits, 2) AS spirits_share 
	FROM beer_percent_consumption bpc
	LEFT JOIN beer_consumption bc 
		ON bpc.code = bc.code 
		AND bpc.`year` = bc.`year` 
	LEFT JOIN wine_consumption wc 
		ON bpc.code = wc.code 
		AND bpc.`year` = wc.`year` 
	LEFT JOIN wine_percent_consumption wpc 
		ON bpc.code = wpc.code 
		AND bpc.`year` = wpc.`year`
	LEFT JOIN spirits_consumption sc 
		ON bpc.code = sc.code 
		AND bpc.`year` = sc.`year` 
	LEFT JOIN spirits_percent_consumption spc 
		ON bpc.code = spc.code 
		AND bpc.`year` = spc.`year`
	;
	
SELECT *
FROM alcohol_consumed_by_type acbt;