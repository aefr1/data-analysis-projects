-- 1. Найти количество вопросов, которые набрали больше 300 очков или как минимум 100 раз были добавлены в «Закладки»: 

SELECT COUNT(id)
FROM stackoverflow.posts
WHERE post_type_id = 1
AND (score > 300 OR favorites_count >= 100)
GROUP BY post_type_id;


-- 2. Сколько в среднем в день задавали вопросов (с округлением до целого) с 1 по 18 ноября 2008 включительно:

SELECT ROUND(AVG(t.count), 0)
FROM (SELECT COUNT(id),
             creation_date::date
     FROM stackoverflow.posts
     WHERE post_type_id = 1
     GROUP BY creation_date::date
     HAVING creation_date::date BETWEEN '2008-11-01' AND '2008-11-18') AS t;


-- 3. Количество уникальных пользователей, получивших значки сразу в день регистрации:

SELECT COUNT(DISTINCT u.id)
FROM stackoverflow.badges b
JOIN stackoverflow.users u ON b.user_id = u.id
WHERE b.creation_date::date = u.creation_date::date;


-- 4. Сколько уникальных постов пользователя с именем Joel Coehoorn получили хотя бы один голос:

SELECT COUNT(t.id)
FROM (SELECT p.id
      FROM stackoverflow.posts p
      JOIN stackoverflow.votes v ON p.id = v.post_id
      JOIN stackoverflow.users u ON p.user_id = u.id
      WHERE u.display_name LIKE 'Joel Coehoorn'
      GROUP BY p.id
      HAVING COUNT(v.id) >= 1) as t;


-- 5. Выгрузить все поля таблицы vote_types, добавить к таблице поле rank, в которое войдут номера записей в обратном порядке.
--    Таблица должна быть отсортирована по полю id:

SELECT *,
       ROW_NUMBER()OVER(ORDER BY id DESC) AS rank
FROM stackoverflow.vote_types
ORDER BY id;

/* 6. Выбрать 10 пользователей, которые поставили больше всего голосов типа Close. 
      Отобразить таблицу из двух полей: идентификатором пользователя и количеством голосов.
      Отсортировать данные сначала по убыванию количества голосов, потом по убыванию значения идентификатора пользователя:
*/
SELECT *
FROM (SELECT v.user_id,
      COUNT(vt.id) AS cnt
      FROM stackoverflow.votes v
      JOIN stackoverflow.vote_types vt ON vt.id = v.vote_type_id
      WHERE vt.name LIKE 'Close'
      GROUP BY v.user_id
      ORDER BY cnt DESC LIMIT 10) AS t
ORDER BY t.cnt DESC, t.user_id DESC;


/* 7. Выбрать 10 пользователей по наибольшему количеству значков, полученных в период с 15 ноября по 15 декабря 2008 года включительно.
      Отобразить следующие поля:
      - идентификатор пользователя;
      - число значков;
      - место в рейтинге (чем больше значков, тем выше рейтинг).
      Пользователям, которые набрали одинаковое количество значков, присвоить одно и то же место в рейтинге.
      Отсортировать записи по количеству значков по убыванию, а затем по возрастанию значения идентификатора пользователя:
*/
SELECT *,
       DENSE_RANK() OVER (ORDER BY t.cnt DESC) AS n
       FROM (SELECT COUNT(id) AS cnt,
                    user_id
             FROM stackoverflow.badges
             WHERE creation_date::date BETWEEN '2008-11-15' AND '2008-12-15'
             GROUP BY 2
             ORDER BY cnt DESC, user_id
             LIMIT 10) AS t;


/* 8. Подсчитать, сколько в среднем очков получает пост каждого пользователя и сформировать таблицу с полями:
      - заголовок поста;
      - идентификатор пользователя;
      - число очков поста;
      - среднее число очков пользователя за пост, округлённое до целого числа.
      Не учитывать посты без заголовка, а также те, что набрали ноль очков:
*/
WITH t AS (SELECT ROUND(AVG(score)) AS avg_score,
                  user_id
          FROM stackoverflow.posts
          WHERE title IS NOT NULL
          AND score <> 0
          GROUP BY user_id)
    SELECT p.title,
           t.user_id,
           p.score,
           t.avg_score
    FROM t
    JOIN stackoverflow.posts AS p ON t.user_id = p.user_id
    WHERE p.title IS NOT NULL
    AND p.score <> 0;

-- 9. Вывести заголовки постов, которые были написаны пользователями, получившими более 1000 значков.
--    Посты без заголовков не должны попасть в список:

SELECT title
FROM stackoverflow.posts
WHERE user_id IN (SELECT user_id
                 FROM stackoverflow.badges
                 GROUP BY user_id
                 HAVING COUNT(id) > 1000)
AND title IS NOT NULL;

/* 10. Написать запрос, который выгрузит данные о пользователях из США (англ. United States). 
       Разделить пользователей на три группы в зависимости от количества просмотров их профилей:
       - группа 1, пользователи с числом просмотров больше либо равным 350;
       - группа 2, пользователи с числом просмотров меньше 350, но больше либо равным 100;
       - группа 3, пользователи с числом просмотров меньше 100.
       Отобразить в итоговой таблице идентификатор пользователя, количество просмотров профиля и группу.
       Пользователи с нулевым количеством просмотров не должны войти в итоговую таблицу:
*/
SELECT id,
       views,
       CASE
           WHEN views >= 350 THEN 1
           WHEN views < 100 THEN 3
           ELSE 2
       END AS g
FROM stackoverflow.users
WHERE location LIKE '%United States%'
AND views > 0;

/* 11. Дополнить предыдущий запрос и отобразить лидеров каждой группы — пользователей,
       которые набрали максимальное число просмотров в своей группе. 
       Вывести поля с идентификатором пользователя, группой и количеством просмотров.
       Отсортировать таблицу по убыванию просмотров, а затем по возрастанию значения идентификатора:
*/
WITH p AS (SELECT t.id,
                  t.views,
                  t.g,
                  MAX(t.views) OVER (PARTITION BY t.g) AS max
           FROM (SELECT id,
                        views,
                        CASE
                            WHEN views >= 350 THEN 1
                            WHEN views < 100 THEN 3
                            ELSE 2
                        END AS g
                 FROM stackoverflow.users
                 WHERE location LIKE '%United States%'
                 AND views > 0) as t)
     SELECT p.id,
            p.views,
            p.g
     FROM p
     WHERE p.views = p.max
     ORDER BY p.views DESC, p.id;


/* 12. Посчитать ежедневный прирост новых пользователей в ноябре 2008 года и сформировать таблицу с полями:
       - номер дня;
       - число пользователей, зарегистрированных в этот день;
       - сумму пользователей с накоплением.
*/
SELECT *,
       SUM(t.cnt) OVER (ORDER BY t.dt) as nn
FROM (SELECT EXTRACT(DAY FROM creation_date::date) AS dt,
             COUNT(id) AS cnt
      FROM stackoverflow.users
      WHERE creation_date::date BETWEEN '2008-11-01' AND '2008-11-30'
      GROUP BY EXTRACT (DAY FROM creation_date::date)) AS t;


/* 13. Для каждого пользователя, который написал хотя бы один пост, найти интервал между регистрацией 
       и временем создания первого поста. Вывести:
       - идентификатор пользователя;
       - разницу во времени между регистрацией и первым постом.
*/
WITH t AS (SELECT DISTINCT user_id,
                  MIN(creation_date) OVER (PARTITION BY user_id) AS min_dt
          FROM stackoverflow.posts)
    SELECT t.user_id,
           (t.min_dt - u.creation_date) AS dif
    FROM stackoverflow.users AS u
    JOIN t ON u.id = t.user_id;


/* 14. Вывести общую сумму просмотров постов за каждый месяц 2008 года.
       Если данных за какой-либо месяц в базе нет, такой месяц можно пропустить.
       Результат отсоровать по убыванию общего количества просмотров:
*/
SELECT SUM (views_count),
       DATE_TRUNC('month', creation_date)::date AS dt
FROM stackoverflow.posts
GROUP BY DATE_TRUNC('month', creation_date)::date
ORDER BY SUM(views_count) DESC;


/* 15. Вывести имена самых активных пользователей, которые в первый месяц после регистрации (включая день регистрации)
       дали больше 100 ответов. Вопросы, которые задавали пользователи, не учитывать. Для каждого имени пользователя
       вывести количество уникальных значений user_id и отсортировать результат по полю с именами в лексикографическом порядке:
*/
SELECT u.display_name,
    COUNT(DISTINCT user_id) as cnt
FROM stackoverflow.posts p
JOIN stackoverflow.post_types pt ON p.post_type_id = pt.id
JOIN stackoverflow.users u ON p.user_id = u.id
WHERE type = 'Answer' AND DATE_TRUNC('day', p.creation_date) >= DATE_TRUNC('day', u.creation_date) AND
    DATE_TRUNC('day', p.creation_date) <= (DATE_TRUNC('day', u.creation_date) + INTERVAL '1 month')
GROUP BY 1
HAVING COUNT(*) > 100
ORDER BY 1;


-- 16. Вывести количество постов за 2008 год по месяцам. Выбрать посты от пользователей, которые зарегистрировались
--     в сентябре 2008 года и сделали хотя бы один пост в декабре того же года. Отсортировать таблицу по значению месяца по убыванию:

WITH t AS (SELECT DISTINCT u.id
           FROM stackoverflow.users u
           JOIN stackoverflow.posts p ON p.user_id=u.id
           WHERE date_trunc('day', u.creation_date)::date BETWEEN '2008-09-01' AND '2008-09-30'
           AND DATE_TRUNC('day', p.creation_date)::date BETWEEN '2008-12-01' AND '2008-12-31')
SELECT DATE_TRUNC('month', pp.creation_date)::date,
       COUNT(pp.id)
FROM t
JOIN stackoverflow.posts pp on pp.user_id=t.id
GROUP BY 1
ORDER BY 1 DESC;


/* 17. Используя данные о постах, вывести следующие поля:
       - идентификатор пользователя, который написал пост;
       - дата создания поста;
       - количество просмотров у текущего поста;
       - сумму просмотров постов автора с накоплением.
       Данные в таблице должны быть отсортированы по возрастанию идентификаторов пользователей,
       а данные об одном и том же пользователе — по возрастанию даты создания поста:
*/
SELECT user_id,
       creation_date,
       views_count,
       SUM(views_count) OVER (PARTITION BY user_id ORDER BY creation_date)
FROM stackoverflow.posts;


/* 18. Сколько в среднем дней в период с 1 по 7 декабря 2008 года включительно пользователи 
       взаимодействовали с платформой, для каждого пользователя выбрать дни, в которые он или она
       опубликовали хотя бы один пост. Вывести результат расчета с округлением до целого числа:
*/
SELECT ROUND(AVG(t.cnt))
FROM (SELECT user_id,
             COUNT(DISTINCT creation_date::date) AS cnt
      FROM stackoverflow.posts
      WHERE creation_date::date BETWEEN '2008-12-01' AND '2008-12-07'
      GROUP BY user_id) AS t;


/* 19. Посчитать, на сколько процентов менялось количество постов ежемесячно с 1 сентября по 31 декабря 2008 года. 
       Вывести таблицу со следующими полями:
       - номер месяца;
       - количество постов за месяц;
       - процент, который показывает, насколько изменилось количество постов в текущем месяце по сравнению с предыдущим.
       Если постов стало меньше, значение процента должно быть отрицательным, если больше — положительным.
       Округлить значения процента до двух знаков после запятой:
*/
WITH t AS (SELECT EXTRACT(MONTH FROM creation_date::date) AS month,
                   COUNT(DISTINCT id)
           FROM stackoverflow.posts
           WHERE creation_date::date BETWEEN '2008-09-01' AND '2008-12-31'
           GROUP BY month)
     SELECT *,
     -- при делении одного целого числа на другое в PostgreSQL в результате получится целое число, 
     -- округлённое до ближайшего целого вниз, чтобы этого избежать, переводим делимое в тип numeric:
     ROUND(((count::numeric / LAG(count) OVER (ORDER BY month)) -1) * 100, 2) AS grow
     FROM t;


/* 20. Выгрузить данные активности пользователя, который опубликовал больше всего постов за всё время. 
       Вывести данные за октябрь 2008 года в следующем виде:
       - номер недели;
       - дата и время последнего поста, опубликованного на этой неделе.
*/
WITH t1 AS (SELECT user_id,
                   COUNT(DISTINCT id) AS cnt
           FROM stackoverflow.posts
           GROUP BY user_id
           ORDER BY cnt DESC
           LIMIT 1),
     t2 AS (SELECT p.user_id,
                   p.creation_date,
                   EXTRACT('week' from p.creation_date) AS w
           FROM stackoverflow.posts AS p
           JOIN t1 ON t1.user_id = p.user_id
           WHERE DATE_TRUNC('month', p.creation_date)::date = '2008-10-01')
SELECT DISTINCT w::numeric,
       MAX(creation_date) OVER (PARTITION BY w)
FROM t2
ORDER BY w;

