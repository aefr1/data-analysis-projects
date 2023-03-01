-- 1. Сколько компаний закрылось:

SELECT COUNT(status)
FROM company
WHERE status = 'closed'
GROUP BY status;


-- 2. Сумма привлеченных средств для новостных компаний США:

SELECT funding_total
FROM company
WHERE country_code = 'USA' AND category_code = 'news'
ORDER BY funding_total DESC;


-- 3. Общая сумма сделок по покупке одних компаний другими, за наличный расчет, с 2011 по 2013 год включительно: 

SELECT SUM(price_amount)
FROM acquisition
WHERE term_code = 'cash' AND EXTRACT(YEAR FROM acquired_at) IN (2011, 2012, 2013);


 -- 4. Отобразить имя, фамилию и названия аккаунтов людей в твиттере, у которых названия аккаунтов начинаются на 'Silver':
SELECT first_name,
       last_name,
       twitter_username
FROM people
WHERE twitter_username LIKE 'Silver%';


-- 5. Вывести всю информацию о людях, у которых названия аккаунтов в твиттере содержат подстроку 'money',
--    а фамилия начинается на 'K': 

SELECT *
FROM people
WHERE last_name LIKE('K%') AND twitter_username LIKE ('%money%');


-- 6. Общая сумма привлечённых инвестиций по странам (по месту регистрации компаний) с сортировкой по убыванию:

SELECT country_code,
       SUM(funding_total)
FROM company
GROUP BY country_code
ORDER BY SUM(funding_total) DESC;


-- 7. Таблица с датой проведения раунда, минимальным и максимальным значением суммы инвестиций, привлечённых в эту дату,
--    в которой минимальное значение суммы инвестиций не равняется нулю и максимальному значению:
SELECT funded_at,
   .    MIN(raised_amount),
       MAX(raised_amount)
FROM funding_round
GROUP BY funded_at
HAVING MIN(raised_amount) != 0 AND MIN(raised_amount) != MAX(raised_amount);

   
/* 8. Создать поля с категориями:
      - high_activity, lля фондов, которые инвестируют в 100 и более компаний;
      - middle_activity, для фондов, которые инвестируют в 20 и более компаний до 100;
      - low_activity, если количество инвестируемых компаний фонда не достигает 20.
      Отобразить все поля таблицы fund и новое поле с категориями:
*/
SELECT *,
       CASE
           WHEN invested_companies>=100 THEN 'high_activity'
           WHEN invested_companies>=20 THEN 'middle_activity'
           ELSE 'low_activity'
       END AS activity
FROM fund;


-- 9. Дополнить предыдущий запрос подсчетом среднего числа количества инвестиционных раундов (с округлением до ближайшего целого),
--    в которых фонд принимал участие. Вывести на экран категории и среднее количество раундов: 

SELECT 
       CASE
           WHEN invested_companies>=100 THEN 'high_activity'
           WHEN invested_companies>=20 THEN 'middle_activity'
           ELSE 'low_activity'
       END AS activity,
       ROUND(AVG(investment_rounds))
FROM fund
GROUP BY activity
ORDER BY ROUND(AVG(investment_rounds));


/* 10. Проанализировать, в каких странах находятся фонды, которые чаще всего инвестируют в стартапы.
       Для каждой страны посчитать минимальное, максимальное и среднее число компаний, 
       в которые инвестировали фонды этой страны, основанные с 2010 по 2012 год включительно. 
       Исключить страны с фондами, у которых минимальное число компаний, получивших инвестиции, равно нулю. 
       Выгрузить десять самых активных стран-инвесторов:
*/
SELECT country_code,
	   MIN(invested_companies) AS min_invested_companies,
       MAX(invested_companies) AS max_invested_companies,
	   AVG(invested_companies) AS avg_invested_companies
FROM fund
WHERE EXTRACT(YEAR FROM CAST(founded_at AS date)) BETWEEN '2010' AND '2012'
GROUP BY country_code
HAVING MIN(invested_companies) > 0
ORDER BY avg_invested_companies DESC, country_code
LIMIT 10;


-- 11. Отобразить имя и фамилию всех сотрудников стартапов и добавить название 
--     учебного заведения, которое окончил сотрудник:

SELECT p.first_name,
       p.last_name,
       e.instituition
FROM people AS p LEFT JOIN education AS e ON p.id = e.person_id;


-- 12. Подсчитать для каждой компании количество учебных заведений, которые окончили её сотрудники. 
--     Вывести топ-5 компаний по количеству университетов (название компании и число уникальных названий учебных заведений):

SSELECT c.name,
	 COUNT(DISTINCT instituition) AS count_inst
FROM people AS p
JOIN education AS e ON p.id = e.person_id
JOIN company AS c ON c.id = p.company_id
GROUP BY c.name
ORDER BY count_inst DESC
LIMIT 5;


-- 13. Составить список с уникальными названиями закрытых компаний, 
--     для которых первый раунд финансирования оказался последним:

SELECT DISTINCT c.name
FROM company AS c
LEFT JOIN funding_round AS fr ON c.id = fr.company_id
WHERE c.status = 'closed' AND fr.is_first_round = 1 AND fr.is_last_round = 1;


-- 14. Составить список уникальных номеров сотрудников, 
--     которые работают в компаниях, отобранных в предыдущем запросе:

SELECT p.id
FROM (SELECT DISTINCT c.id
    FROM company AS c
    LEFT JOIN funding_round AS fr ON c.id = fr.company_id
    WHERE c.status = 'closed' AND fr.is_first_round = 1 AND fr.is_last_round = 1) AS t
    INNER JOIN people AS p ON t.id = p.company_id; 

                     
-- 15. Составить таблицу, куда войдут уникальные пары с номерами сотрудников из предыдущего запроса
--     и учебным заведением, которое окончил сотрудник:

SELECT DISTINCT p.id,
       e.instituition
FROM (SELECT DISTINCT c.id
    FROM company AS c
    LEFT JOIN funding_round AS fr ON c.id = fr.company_id
    WHERE c.status = 'closed' AND fr.is_first_round = 1 AND fr.is_last_round = 1) AS t
    INNER JOIN people AS p ON t.id = p.company_id
    INNER JOIN education AS e ON p.id = e.person_id;
                              

-- 16. Подсчитать количество учебных заведений для каждого сотрудника из предыдущего запроса, 
--     с учетом того, что некоторые сотрудники могли окончить одно и то же заведение дважды:

SELECT DISTINCT p.id,
       COUNT(e.instituition)
FROM (SELECT DISTINCT c.id
    FROM company AS c
    LEFT JOIN funding_round AS fr ON c.id = fr.company_id
    WHERE c.status = 'closed' AND fr.is_first_round = 1 AND fr.is_last_round = 1) AS t
    INNER JOIN people AS p ON t.id = p.company_id
    INNER JOIN education AS e ON p.id = e.person_id
GROUP BY p.id;


-- 17. Дополнить предыдущий запрос и вывести среднее число учебных заведений (всех, не только уникальных), 
--     которые окончили сотрудники разных компаний:

SELECT AVG(count_inst) 
FROM (SELECT p.id,
      COUNT(e.instituition) AS count_inst
      FROM (SELECT DISTINCT c.id
      FROM company AS c
      LEFT JOIN funding_round AS fr ON c.id = fr.company_id
      WHERE c.status = 'closed' AND fr.is_first_round = 1 AND fr.is_last_round = 1) AS t
      INNER JOIN people AS p ON t.id = p.company_id
      INNER JOIN education AS e ON p.id = e.person_id
      GROUP BY p.id) AS tt;


-- 18. Вывести среднее число учебных заведений (всех, не только уникальных), которые окончили сотрудники Facebook:

SELECT AVG(count_inst) 
FROM (SELECT p.id,
      COUNT(e.instituition) AS count_inst
      FROM company AS c
     INNER JOIN people AS p ON c.id = p.company_id
     INNER JOIN education AS e ON p.id = e.person_id
      WHERE c.name = 'Facebook'
     GROUP BY p.id) AS tt;


/* 19. Составить таблицу со следующими полями:
       - name_of_fund — название фонда;
       - name_of_company — название компании;
       - amount — сумма инвестиций, которую привлекла компания в раунде.
       В таблицу должны войти данные о компаниях, в истории которых было больше шести важных этапов, 
       а раунды финансирования проходили с 2012 по 2013 год включительно:
*/
SELECT f.name AS name_of_fund,
       c.name AS name_of_company,
       fr.raised_amount AS amount
FROM company AS c
LEFT JOIN investment AS i ON i.company_id  = c.id
LEFT JOIN funding_round AS fr ON i.funding_round_id = fr.id
LEFT JOIN fund AS f ON i.fund_id = f.id
WHERE EXTRACT (YEAR FROM CAST (fr.funded_at  AS DATE)) IN (2012,2013) AND c.milestones > 6;  


/* 20. Выгрузить таблицу, в которой будут следующие поля:
       - название компании-покупателя;
       - сумма сделки;
       - название компании, которую купили;
       - сумма инвестиций, вложенных в купленную компанию;
       - доля, которая отображает, во сколько раз сумма покупки превысила сумму вложенных в компанию инвестиций, 
         округлённая до ближайшего целого числа.
       Сделки, в которых сумма покупки равна нулю учитывать не нужно. Если сумма инвестиций в компанию равна нулю,
       необходимо исключить такую компанию из таблицы. 
       Таблица должна быть отсортирована по сумме сделки от большей к меньшей, 
       а затем по названию купленной компании в лексикографическом порядке. Вывести первые десять записей:
 */
SELECT c.name AS acquiring_company,
       a.price_amount,
       c1.name AS acquired_company,
	   c1.funding_total,
	   ROUND(a.price_amount / c1.funding_total) AS percent
FROM acquisition AS a
LEFT JOIN company AS c ON a.acquiring_company_id = c.id
LEFT JOIN company AS c1 ON a.acquired_company_id = c1.id
WHERE a.price_amount > 0 AND c1.funding_total > 0
ORDER BY a.price_amount DESC, acquired_company
LIMIT 10;

/* 21. Выгрузить таблицу, в которую войдут названия компаний из категории social, получившие финансирование 
       с 2010 по 2013 год включительно. Проверить, что сумма инвестиций не равна нулю. 
       Вывести также номер месяца, в котором проходил раунд финансирования:
*/
SELECT c.name,
       EXTRACT(MONTH FROM fr.funded_at)
FROM company AS c
LEFT JOIN funding_round AS fr ON c.id = fr.company_id
WHERE c.category_code = 'social'
  AND EXTRACT (YEAR FROM fr.funded_at) BETWEEN 2010 AND 2013
  AND fr.raised_amount > 0;

  
/* 22. Отобрать данные по месяцам с 2010 по 2013 год, когда проходили инвестиционные раунды. 
       Сгруппировать данные по номеру месяца и получить таблицу, в которой будут следующие поля: 
       - номер месяца, в котором проходили раунды;
       - количество уникальных названий фондов из США, которые инвестировали в этом месяце;
       - количество компаний, купленных за этот месяц;
       - общая сумма сделок по покупкам в этом месяце.
 */
WITH fr AS (SELECT EXTRACT(MONTH FROM fr.funded_at) AS month,
            COUNT(DISTINCT f.name) AS count_fund
            FROM funding_round AS fr
            LEFT JOIN investment AS i ON fr.id = i.funding_round_id
            LEFT JOIN fund AS f ON i.fund_id = f.id
            WHERE f.country_code = 'USA'
              AND EXTRACT (YEAR FROM fr.funded_at) BETWEEN 2010 AND 2013
            GROUP BY month),
     ac AS (SELECT EXTRACT(MONTH FROM acquired_at) AS month,
            COUNT(acquired_company_id) AS count_acquired_company,
            SUM(price_amount) AS sum
            FROM acquisition
            WHERE EXTRACT (YEAR FROM acquired_at) BETWEEN 2010 AND 2013
            GROUP BY month)
SELECT DISTINCT fr.month,
       fr.count_fund,
       ac.count_acquired_company,
       ac.sum
FROM fr
JOIN ac ON fr.month = ac.month
ORDER BY month;


/* 23. Составить сводную таблицу и вывести среднюю сумму инвестиций для стран, в которых есть стартапы, 
    зарегистрированные в 2011, 2012 и 2013 годах. Данные за каждый год должны быть в отдельном поле. 
    Отсортировать таблицу по среднему значению инвестиций за 2011 год от большего к меньшему:
*/
SELECT y11.country_code,
       y11.s,
       y12.s,
       y13.s
FROM (SELECT country_code,
             coalesce(AVG(funding_total), 0) AS s
      FROM company AS c
      WHERE EXTRACT(YEAR FROM c.founded_at) = 2011
      GROUP BY country_code) AS y11
      INNER JOIN
      (SELECT country_code,
             coalesce(AVG(funding_total), 0) AS s
      FROM company AS c
      WHERE EXTRACT(YEAR FROM c.founded_at) = 2012
      GROUP BY country_code) AS y12 ON y11.country_code = y12.country_code
      INNER JOIN
      (SELECT country_code,
             coalesce(AVG(funding_total), 0) AS s
      FROM company AS c
      WHERE EXTRACT(YEAR FROM c.founded_at) = 2013
      GROUP BY country_code) AS y13 ON y11.country_code = y13.country_code
      ORDER BY y11.s DESC;

      