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