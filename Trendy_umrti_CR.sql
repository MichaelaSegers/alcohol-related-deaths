-- Trendy úmrtí kvůli alkoholu v ČR - roste nebo klesá?

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