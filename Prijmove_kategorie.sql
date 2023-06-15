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