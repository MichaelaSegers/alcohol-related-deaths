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