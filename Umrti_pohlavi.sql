-- Úmrtí v souvislosti s pohlavím

SELECT 
	sex,
	AVG(val) AS avg_percent
FROM deaths_alcohol_use dau 
WHERE metric = 'Percent'
GROUP BY sex;
/* Průměrný celosvětový podíl alkoholu na úmrtí 3,84% celkově, 1,35% u žen, 5,95% u mužů */