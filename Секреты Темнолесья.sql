/* Проект «Секреты Тёмнолесья»
 * Цель проекта: изучить влияние характеристик игроков и их игровых персонажей 
 * на покупку внутриигровой валюты «райские лепестки», а также оценить 
 * активность игроков при совершении внутриигровых покупок
 * 
 * Автор: Лазарева Елизавета Сергеевна
 * Дата: 31.12.2024
*/

-- Часть 1. Исследовательский анализ данных
-- Задача 1. Исследование доли платящих игроков

-- 1.1. Доля платящих пользователей по всем данным:
WITH u_c AS(SELECT count(*) over() AS users_count,
	   payer
FROM fantasy.users u )
SELECT users_count,
	   count(payer) AS payer_count,
	   ROUND(count(payer)/users_count::numeric, 4) AS payer_share
FROM u_c
WHERE payer = 1
GROUP BY users_count;

-- 1.2. Доля платящих пользователей в разрезе расы персонажа:
-- Общее количество зарегистрированных пользователей в разрезе расы
WITH race_count AS(
SELECT DISTINCT race,
       count(id) over(PARTITION BY race) AS users_count	   				
FROM fantasy.race r 
JOIN fantasy.users u ON r.race_id = u.race_id 
),
--Общее количество платящих игроков в разрезе расы
pay_count as(
SELECT DISTINCT race,
	   count(payer) over(PARTITION BY race) AS payers_count
FROM fantasy.race r 
JOIN fantasy.users u ON r.race_id = u.race_id
WHERE payer = 1
)
--Основной запрос, считающий долю платящих игроков в разрезе расы
SELECT r.race,
	   payers_count,
	   users_count,
	   round( payers_count::numeric/users_count, 4) AS payers_share
FROM race_count r
JOIN pay_count p ON r.race = p.race
ORDER BY payers_share desc;

-- Задача 2. Исследование внутриигровых покупок

-- 2.1. Статистические показатели по полю amount:

SELECT count(amount) AS transactions_count,
	   sum(amount) AS sum_amount,
	   max(amount) AS max_amount,
	   min(amount) AS min_amount,
	   round(stddev(amount)::numeric, 2) AS stddev_amount,
	   round(avg(amount)::numeric,2) AS avg_amount,
	   round(percentile_cont(0.5) WITHIN GROUP(ORDER BY amount)::NUMERIC ,2) AS median_amount	   
FROM fantasy.events e;
--Статистические показатели по полю amount без учета нулевых покупок:
SELECT count(amount) AS transactions_count,
	   sum(amount) AS sum_amount,
	   max(amount) AS max_amount,
	   min(amount) AS min_amount,
	   round(stddev(amount)::numeric, 2) AS stddev_amount,
	   round(avg(amount)::numeric,2) AS avg_amount,
	   round(percentile_cont(0.5) WITHIN GROUP(ORDER BY amount)::NUMERIC ,2) AS median_amount	   
FROM fantasy.events e
WHERE amount >0;


-- 2.2: Аномальные нулевые покупки:

SELECT COUNT(transaction_id) FILTER (WHERE amount = 0) AS anomalous_amount,
	   round(COUNT(transaction_id) FILTER (WHERE amount = 0)::NUMERIC / count(transaction_id), 4) AS anomalous_amount_share
FROM fantasy.events e ;

SELECT game_items,
	   count(DISTINCT id) AS users_count,
	   count(*) AS buying_count
FROM fantasy.events e 
LEFT JOIN fantasy.items i ON e.item_code = i.item_code 
WHERE amount = 0
GROUP BY game_items
ORDER BY buying_count DESC;

-- 2.3: Сравнительный анализ активности платящих и неплатящих игроков:

SELECT CASE WHEN payer = 1
		THEN 'payer'
		ELSE 'non-payer' END AS payer,
	CASE WHEN payer = 1 
		 THEN count(DISTINCT e.id)
		 ELSE count(DISTINCT e.id) END AS users_count,
	CASE WHEN payer = 1 
		 THEN round(count(transaction_id)::NUMERIC/count(DISTINCT e.id) ,2)
		 ELSE round(count(transaction_id)::NUMERIC/count(DISTINCT e.id) ,2) END AS avg_transactions_per_user, 
	CASE WHEN payer = 1 
		 THEN round(sum(amount)::NUMERIC/count(DISTINCT e.id) ,2)
		 ELSE round(sum(amount)::NUMERIC/count(DISTINCT e.id) ,2) END AS avg_amount_per_user	 
FROM fantasy.events e 
LEFT JOIN fantasy.users u ON e.id = u.id
WHERE amount >0
GROUP BY payer
ORDER BY payer DESC ;


-- 2.4: Популярные эпические предметы:
SELECT game_items,
	   e.item_code,
	   round(count(DISTINCT id)::NUMERIC/(SELECT count(*) FROM fantasy.users u), 5) AS users_share,
	   count(transaction_id) AS transactions_count,
	   round(count(transaction_id)::NUMERIC/sum(count(transaction_id)) over(), 5)*100 AS transactions_share
FROM fantasy.events e
LEFT JOIN fantasy.items i ON e.item_code = i.item_code
WHERE amount >0
GROUP BY e.item_code, game_items
ORDER BY transactions_count desc;

SELECT count(game_items) AS not_buyed_items
FROM fantasy.events e
LEFT JOIN fantasy.items i ON e.item_code = i.item_code
WHERE amount >0
HAVING count(transaction_id) = 0;


-- Часть 2. Решение ad hoc-задач
-- Задача 1. Зависимость активности игроков от расы персонажа:
--Количество пользователей для каждой расы
WITH users as(
SELECT race,
	   r.race_id,
	   count(u.id) AS users_count
FROM fantasy.users u 
LEFT JOIN fantasy.race r ON u.race_id = r.race_id
GROUP BY race, r.race_id),
--Количество и доля игроков, совершивших покупку
buyers AS (
SELECT race,
	   r.race_id,
	   count(DISTINCT e.id) AS buyers_count,
	   round(count(DISTINCT e.id)::numeric/count(u.id), 3) AS buyers_share
FROM fantasy.users u 
LEFT JOIN fantasy.race r ON u.race_id = r.race_id
LEFT JOIN fantasy.events e ON u.id = e.id
WHERE amount >0
GROUP BY race, r.race_id),
--Количество и доля платящих игроков
payers as(
SELECT race,
	   r.race_id,
	   count(DISTINCT e.id) AS payers_count 
FROM fantasy.users u 
LEFT JOIN fantasy.race r ON u.race_id = r.race_id
LEFT JOIN fantasy.events e ON u.id = e.id
WHERE payer = 1 AND amount>0
GROUP BY race, r.race_id),
--Среднее количество покупок,средняя стоимость одной покупки, средняя суммарную стоимость всех покупок на одного игрока
stats  as(
SELECT race,
	   r.race_id,
	   round(count(transaction_id)/count(DISTINCT e.id)::NUMERIC) AS avg_transactions_per_user,
	   round(sum(amount)::numeric/count(transaction_id)) AS avg_one_purchace_amount,
	   round(sum(amount)::numeric/count(DISTINCT e.id)) AS avg_all_purchaces_amount
FROM fantasy.users u 
LEFT JOIN fantasy.race r ON u.race_id = r.race_id
LEFT JOIN fantasy.events e ON u.id = e.id
WHERE amount >0
GROUP BY race, r.race_id)
--Основной запрос, считающий необходимые показатели
SELECT u.race_id,
	   u.race,
	   users_count,
	   buyers_count,
	   round(buyers_count/users_count::NUMERIC, 3) AS buyers_share,
	   round(payers_count::NUMERIC/buyers_count, 2) AS payers_share,
	   avg_transactions_per_user,
	   avg_one_purchace_amount,
	   avg_all_purchaces_amount
FROM users u
FULL JOIN buyers b ON u.race_id = b.race_id
FULL JOIN payers p ON u.race_id = p.race_id
FULL JOIN stats s ON s.race_id = u.race_id
ORDER BY buyers_share DESC, payers_Share DESC ;
	   

