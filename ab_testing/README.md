# A/B-тестирование  

## Статус проекта
Завершен

## Описание проекта

В распоряжении есть датасет с действиями пользователей, техническое задание и несколько вспомогательных датасетов.  

Требуется:  

- оценить корректность проведения теста;
- проанализировать результаты теста

Для оценки корректностьи проведения теста, необходимо проверить:

- пересечение тестовой аудитории с конкурирующим тестом;
- совпадение теста и маркетинговых событий, другие проблемы временных границ теста.
  
## Цель проекта  

Провести оценку результатов A/B-теста   

## Итоги проекта  

**На этапе исследовательского анализа данных было установлено следующее**:  


1. Среднее значение количества событий в группе А и B отличаются, в группе А оно составляет 7,03, в группе В - 5,83.  


2. Анализ событий по дням показал:
- события в группах распределены по-разному, пользователи контрольной группы вели себя активнее, а в группе B плотнее распределение событий;
- заметно влияние праздника - католичческого Рождества, на обоих графиках групп выделяется пик - 21 декабря, после которого идет заметное снижение;
- в группе В активность упала раньше, 30 декабря активность присутствует только у контрольной группы.  


3. На воронке событий наглядно отображается несоразмерность групп. Конверсия по шагам сильно отличается на переходе к странице товара - 65% в группе А и 56% в группе В, этапы корзины и покупки выглядят схожим образом. Замечена особенность данной  воронки - этап покупки в ней имеет большую конверсию, чем корзина. Выдвинуто предположение о наличии такой возможности функционалом приложения. Больше всего пользователей теряется на переходе от авторизации к странице продукта, следует проверить, нет ли технических проблем на этом шаге.  


4. Зафиксированы отличительные особенности данного теста:
- группы имеют серьезный дисбаланс по количеству участников, а также несоответствие по общему количеству согласно ТЗ;
- тест завершен ранее запланированного срока - 29 декабря, в результате чего у части пользователей сократился лайфтайм. Данный эффект отчасти снивелирован особенностью активности покупателей, т.к. они совершали активные покупки только в первые дни после регистрации;
- уже до оценки результатов, мы удостоверились, что тест в целом провален, целевой результат в виде улучшения метрик на 10% не получен, а достоверность собранных данных вызывает сомнение.  


**На этапе оценки результатов теста можно выделить седующее**:  


1. Сформулированы нулевая и альтернативная гипотезы:
```
  H_0: Различий в долях пользователей между группами A и B нет  
  H_1: Различия в долях пользователей между группами A и B есть  
```
 
2. Результаты теста показали, что по двум событиям (корзина и покупка) P-value оказался выше уровня статистической значимости (стандартный уровень 0.05, рассчитан с поправкой Бонферрони для 3-х событий), и следовательно, причин отвергать нулевую гипотезу, и считать, что в долях пользователей между группами A и B есть статистически значимые различия для этих событий - нет.  


3. Для события "страница продукта"(product_page)  P-value = 0, т.е. оказался ниже уровня статистической значимости, значит, нулевую гипотезу о том, что статистически значимых различий в долях пользователей нет - отвергаем.  


**На основе изученных материалов можно выдвинуть следующие рекомендации**:  


1. Состав групп для проведения тестирования должен быть однородным и, желательно, не отличаться по размеру, более чем на 1%.  


2. Во время проведения тестов желательно воздержаться от параллельного тестирования других параметров. Пересечение пользователей, участвующих в тесте с другими группами также недопустимо.  


3. Сбор информации должен быть корректным, не допускается завершение ранее запланированного срока.  


4. Результаты данного тестирования не могут считаться корректными, следует провести его еще раз, исправив все недочеты.


## Описание данных:  

# Описание данных

*Датасет ab_project_marketing_events.csv* (календарь маркетинговых событий на 2020 год)

**name** — название маркетингового события;  
**regions** — регионы, в которых будет проводиться рекламная кампания;  
**start_dt** — дата начала кампании;  
**finish_dt** — дата завершения кампании.  

*Датасет final_ab_new_users.csv* (пользователи, зарегистрировавшиеся с 7 по 21 декабря 2020 года)

**user_id** — идентификатор пользователя;  
**first_date** — дата регистрации;  
**region** — регион пользователя;  
**device** — устройство, с которого происходила регистрация.  

*Датасет final_ab_events.csv* (действия новых пользователей в период с 7 декабря 2020 по 4 января 2021 года)  

**user_id** — идентификатор пользователя;  
**event_dt** — дата и время покупки;  
**event_name** — тип события;  
**details** — дополнительные данные о событии. Например, для покупок `purchase`, в этом поле хранится стоимость покупки в долларах.  

*Датасет final_ab_participants.csv* (таблица участников тестов)

**user_id** — идентификатор пользователя;  
**ab_test** — название теста;  
**group** — группа пользователя.    

## Навыки и инструменты:

`визуализация данных`
`событийная аналитика`
`продуктовые метрики`    
`A/B-тестирование`  
`проверка статистических гипотез`   
  
`Python`  
`Pandas`    
`Matplotlib`  
`Math`  
`Numpy`     
`Plotly`  
`Scipy`  
`Seaborn`   

## Содержание:  

1 Обзор и предобработка данных  
1.1 Импорт библиотек и загрузка данных  
1.2 Предобработка данных  
1.3 Вывод  
2 Оценка корректности проведения теста  
2.1 Проверка на соответствие данных требованиям технического задания   
2.2 Маркетинговые активности во время проведения теста и их влияние  
2.3 Оценка аудитории теста  
2.4 Вывод  
3 Исследовательский анализ данных  
3.1 Распределение количества событий на пользователя в выборках  
3.2 Распределение числа событий в выборках по дням  
3.3 Изменение конверсии в воронке в выборках на разных этапах  
4 Оценка результатов A/B-тестирования  
5 Выводы по исследованию данных и по оценке результатов A/B-тестирования  
