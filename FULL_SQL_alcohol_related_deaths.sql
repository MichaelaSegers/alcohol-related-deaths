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
	


CREATE OR REPLACE TABLE alcohol_consumed_by_type_2016 AS
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

-- Která země má nejvíce úmrtí v souvislosti s alkoholem?

SELECT *
FROM deaths_alcohol_use dau
WHERE metric = 'Percent'
AND sex = 'Both'
ORDER BY val DESC;
/*Mongolsko 2015-2019 pro obě pohlaví - nejvyšší podíl alkoholu z celkových úmrtí*/

SELECT *
FROM deaths_alcohol_use dau
WHERE metric = 'Percent'
AND sex != 'Both'
ORDER BY val DESC;


SELECT *
FROM deaths_alcohol_use dau
WHERE metric = 'Percent'
AND sex = 'Male'
ORDER BY val DESC;
/* Rusko 2004-2008 u mužů - nejvyšší podíl alkoholu z celkových úmrtí */

SELECT *
FROM deaths_alcohol_use dau
WHERE metric = 'Percent'
AND sex = 'Female'
ORDER BY val DESC;
/* Moldavsko 1990-1999 u žen - nejvyšší podíl alkoholu z celkových úmrtí */


SELECT *
FROM deaths_alcohol_use dau
WHERE `year` = 2019
	AND metric = 'Percent'
	AND sex = 'Both'
ORDER BY val DESC
LIMIT 3;
/* Poslední měřený rok (2019) nejvyšší podíly v Mongolsku, Moldavsku, Kambodže */

SELECT *
FROM deaths_alcohol_use dau
WHERE `year` = 2019
	AND metric = 'Percent'
	AND sex = 'Both'
ORDER BY val
LIMIT 3;
/* Poslední měřený rok (2019) nejnižší podíly v Afghanistánu, Súdánu, Kuvajtu */

SELECT *
FROM alcohol_death_by_population adbp
WHERE alc_death_per_1000popul IS NOT NULL
ORDER BY alc_death_per_1000popul DESC;
/* Alk. úmrtí na 1000 obyvatel - nejvyšší v Rusku 2000-2010 */

SELECT *
FROM alcohol_death_by_population adbp
WHERE alc_death_per_1000popul IS NOT NULL
ORDER BY alc_death_per_1000popul;
/* Alk. úmrtí na 1000 obyvatel - nejnižšší v Kuvajtu */

SELECT *
FROM alcohol_death_by_population adbp
WHERE `year` = 2019
	AND alc_death_per_1000popul IS NOT NULL
ORDER BY alc_death_per_1000popul DESC
LIMIT 3;
/* Alk. úmrtí na 1000 obyvatel v roce 2019 - nejvyšší v Moldavsku, Bulharsku, Rusku */

SELECT *
FROM alcohol_death_by_population adbp
WHERE `year` = 2019
	AND alc_death_per_1000popul IS NOT NULL
ORDER BY alc_death_per_1000popul
LIMIT 3;
/* Alk. úmrtí na 1000 obyvatel v roce 2019 - nejnižší v Kuvajtu, Súdánu, Ománu */


-- Úmrtí v souvislosti s pohlavím

SELECT 
	sex,
	AVG(val) AS avg_percent
FROM deaths_alcohol_use dau 
WHERE metric = 'Percent'
GROUP BY sex;
/* Průměrný celosvětový podíl alkoholu na úmrtí 3,84% celkově, 1,35% u žen, 5,95% u mužů */


-- Souvisí množství zkonzumovaného alkoholu s úmrtími?

SELECT *
FROM alcohol_consumption ac;

SELECT 
	dau.location,
	dau.`year`,
	dau.val,
	ac.consumption 
FROM deaths_alcohol_use dau
LEFT JOIN alcohol_consumption ac 
	ON dau.location = ac.entity 
	AND dau.`year` = ac.`year` 
WHERE metric = 'Percent'
	AND sex = 'Both'
	AND dau.`year` = 2018;
	
-- Trendy konzumace alkoholu v ČR - roste nebo klesá?

SELECT *
FROM alcohol_consumption ac
WHERE entity = 'Czechia';

SELECT 
	location,
	sex,
	`year`,
	val 
FROM deaths_alcohol_use dau 
WHERE location = 'Czechia'
	AND metric = 'Percent'
	AND sex = 'Both'
ORDER BY `year`;
/* Za posledních 30 poměrně stabilně kolem 6% z celkových úmrtí */


SELECT 
	location,
	sex,
	`year`,
	val 
FROM deaths_alcohol_use dau 
WHERE location = 'Czechia'
	AND metric = 'Number'
	AND sex = 'Both'
ORDER BY `year`;

SELECT 
	location,
	sex,
	`year`,
	val 
FROM deaths_alcohol_use dau 
WHERE location = 'Czechia'
	AND metric = 'Number'
	AND sex = 'Male'
ORDER BY `year`;

SELECT 
	location,
	sex,
	`year`,
	val 
FROM deaths_alcohol_use dau 
WHERE location = 'Czechia'
	AND metric = 'Number'
	AND sex = 'Female'
ORDER BY `year`;


-- Ve které příjmové kategorii zemí se konzumuje nejvíce alkoholu a kde se nejvíce umírá?

SELECT 
	ac.entity,
	ac.`year`,
	ac.consumption,
	c.income_group 
FROM alcohol_consumption ac
LEFT JOIN countries c 
	ON ac.entity = c.table_name
ORDER BY consumption DESC ;
/* Jednoznačně nejvíce konzumace alkoholu per capita je ve
 * vysoce příjmových a středně vysoce příjmových státech. */

SELECT
	dau.location,
	c.income_group,
	ROUND(AVG(dau.val), 4) AS avg_death_percent
FROM deaths_alcohol_use dau
LEFT JOIN countries c 
	ON dau.location = c.table_name 
WHERE dau.metric = 'Percent'
GROUP BY dau.location
ORDER BY avg_death_percent DESC; 
/* Také podíl úmrtí souvisejících s alkoholem je nejvyšší v zemích
 * s vysokými a středně vysokými příjmy. */


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