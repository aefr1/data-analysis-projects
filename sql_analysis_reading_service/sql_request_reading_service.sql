-- 1. Подсчет книг, вышедших после 1 января 2000 года:

SELECT COUNT(book_id)
FROM books
WHERE publication_date::date >= '01-01-2000';


-- 2. Подсчет количества обзоров и расчет средней оценкки для каждой книги:

SELECT books.book_id,
       title,
       COUNT(DISTINCT review_id) AS count_reviews,
       ROUND(AVG(rating), 3) AS avg_rating
FROM books
LEFT JOIN ratings ON books.book_id = ratings.book_id
LEFT JOIN reviews ON books.book_id = reviews.book_id
GROUP BY books.book_id,
         title
ORDER BY count_reviews DESC
LIMIT 20;


-- 3. Определение издательства, выпустившего наибольшее число книг толще 50 страниц:

SELECT publishers.publisher_id AS id,
       ublishers.publisher AS multi_page_publisher,
       COUNT(books.book_id) AS books_count
FROM publishers
LEFT JOIN books ON books.publisher_id = publishers.publisher_id
WHERE books.num_pages > 50
GROUP BY id, multi_page_publisher
ORDER BY books_count DESC
LIMIT 3;


-- 4. Определение автора с самой высокой средней оценкой книг (с 50 и более оценок):

SELECT a.author,
       ROUND(AVG(r.rating), 3) as avg_rating
FROM authors as a
LEFT JOIN books as b ON a.author_id = b.author_id
LEFT JOIN (SELECT *,
                  COUNT(rating_id) OVER (PARTITION BY book_id) as count_rating
           FROM ratings) as r ON b.book_id = r.book_id
WHERE r.count_rating >= 50
GROUP BY a.author_id
ORDER BY avg_rating DESC
LIMIT 3;


-- 5. Расчет среднего количества обзоров от пользователей, которые поставили больше 50 оценок:

WITH i AS
  (SELECT COUNT(reviews.review_id) AS count_reviews
   FROM reviews
   WHERE username IN (SELECT username
                      FROM ratings
                      GROUP BY username
                      HAVING COUNT(rating_id) > 50)
   GROUP BY username)  
SELECT ROUND(AVG(i.count_reviews), 3) AS avg_number_reviews
FROM i;

