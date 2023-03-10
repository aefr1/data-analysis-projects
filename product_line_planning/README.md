# Планирование продуктовой линейки и рекламных акций в интернет-магазине компьютерных игр

## Статус проекта
Завершен

## Описание проекта

Интернет-магазин занимается продажей компьютерных игр по всему миру. Из открытых источников доступны исторические данные о продажах игр, оценки пользователей и экспертов, жанры и платформы (например, Xbox или PlayStation). Требуется выявить определяющие успешность игры закономерности. Это позволит сделать ставку на потенциально популярный продукт и спланировать рекламные кампании.  

Заказчиком предоставлены данные до 2016 года. Необходимо представить гипотетическую ситуацию, что сейчас декабрь 2016 г., и мы  планируем кампанию на 2017-й год. Нужно отработать общий принцип работы с данными, и неважно, прогнозируем ли мы продажи на 2017 год по данным 2016-го или же 2027-й — по данным 2026 года. 

В наборе данных попадается аббревиатура ESRB (Entertainment Software Rating Board) — это ассоциация, определяющая возрастной рейтинг компьютерных игр. ESRB оценивает игровой контент и присваивает ему подходящую возрастную категорию, например, «Для взрослых», «Для детей младшего возраста» или «Для подростков».

## Цель проекта  

Выявить закономерности, определяющие коммерческую успешность игр.

## Итоги проекта  

В рамках данного проекта устранены проблемы в данных, отработан принцип работы с данными для изучения закономерностей, определяющих коммерческую успешность игр, включая исследование выпуска игр по годам, изменение продаж по платформам, определение актуального периода, выбор потенциально прибыльных платформ, исследование влияния отзывов критиков и пользователей на продажи, определение популярных жанров, изучение спроса и влияние рейтинга ESRB по регионам продаж. В дополнение, были сформулированы и проверены две гипотезы.
Такой комплексный подход позволяет сделать ставку на потенциально популярный продукт и спланировать рекламные кампании на будущие периоды.  

**Выявлено, что коммерческую успешность продукта необходимо оценивать исходя из предполагаемого региона сбыта:**

*Для успешной экспансии на рынки Северной Америки и Европы, окажут положительное влияние следующие факторы:*
- выпуск игры для одной из популярных платформ: PS4, X360, XOne, PS3 и 3DS;  
- выпуск игры в жанре Action, Shooter, Sports, Role-Playing и Misc;  
- присвоенный игре рейтинг М по версии ESRB  

*Для успеха на рынке Японии будут полезны следующие факторы:*  
- выпуск игры для одной из популярных платформ: 3DS, PS3 и PSV, PS4 и WiiU;
- выпуск игры в жанре Action, Role-Playing, Misc, Fighting и Shooter

Планировать рекламную компанию необходимо также с акцентом на выделенные факторы, и обязательно с учетом выявленных региональных особенностей.

## Описание данных:  

*Датасет games.csv:*

**Name** — название игры  
**Platform** — платформа  
**Year_of_Release** — год выпуска  
**Genre** — жанр игры  
**NA_sales** — продажи в Северной Америке (миллионы проданных копий)  
**EU_sales** — продажи в Европе (миллионы проданных копий)  
**JP_sales** — продажи в Японии (миллионы проданных копий)  
**Other_sales** — продажи в других странах (миллионы проданных копий)  
**Critic_Score** — оценка критиков (максимум 100)  
**User_Score** — оценка пользователей (максимум 10)  
**Rating** — рейтинг от организации ESRB ([ознакомиться подробнее можно здесь](https://ru.wikipedia.org/wiki/Entertainment_Software_Rating_Board))

*Примечание:* Данные за 2016 год могут быть неполными.

## Навыки и инструменты:  
`предобработка данных`  
`исследовательский анализ`  
`описательная статистика`  
`проверка статистических гипотез`  

`Python`  
`Pandas`  
`Matplotlib`  
`Numpy`  
`Scipy`  
`Seaborn`  

## Содержание:  

1 Открытие файла и изучение общей информации  
1.1 Вывод  
2 Предобработка данных  
2.1 Замена названий столбцов  
2.2 Обработка пропусков  
2.3 Преобразование данных в нужные типы  
2.4 Расчет суммарных продаж  
2.5 Вывод  
3 Исследовательский анализ даных  
3.1 Выпуск игр по годам  
3.2 Изменение продаж по платформам  
3.3 Определение актуального периода для построения прогнозов  
3.4 Выбор потенциально прибыльных платформ  
3.5 Построение диаграммы размаха на основе глобальных продаж игр, в разбивке по платформам  
3.6 Влияние отзывов критиков и пользователей на продажи внутри популярной платформы (PS4)  
3.7 Соотнесение выводов о корреляции отзывов с продажами на других платформах  
3.8 Распределение игр по жанрам  
3.9 Вывод  
4 Составление портрета пользователя каждого региона (NA, EU, JP)  
4.1 Самые популярные платформы (топ-5) для пользователя каждого региона  
4.2 Самые популярные жанры (топ-5) для пользователя каждого региона  
4.3 Влияние рейтинга ESRB на продажи в отдельном регионе  
4.4 Вывод  
5 Проверка гипотез   
6 Общий вывод  
