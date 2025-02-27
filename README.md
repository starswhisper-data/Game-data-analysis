# Проект «Секреты Темнолесья»
Цель проекта — изучить влияние характеристик игроков и их игровых персонажей на покупку внутриигровой валюты «райские лепестки», а также оценить активность игроков при совершении внутриигровых покупок.
Анализ был проведен в СУБД PostgreSQL.
Автор:  Лазарева Елизавета Сергеевна


 Выводы и аналитические комментарии
## 1. Результаты исследовательского анализа данных:
   
## 1.1. Какая доля платящих игроков характерна для всей игры и как раса персонажа влияет на изменение этого показателя?

Доля платящих игроков для всей игры составляет 0,1769. Для расы “Demon” самая высокая доля платящих игроков, она составляет 0,1937. Всего за расу “Demon” играют 1 229 пользователей, платящих игроков - 238. Минимальная доля платящих у расы “Elf” - 0,1707. За эту расу играет 2501 пользователь, 427 из них – платящие. Можно заметить, что корреляция в разрезе расы небольшая и составляет 0,023.

![image](https://github.com/user-attachments/assets/f050b5b6-c9f5-4be6-a9c0-1259decfd0fe)

![image](https://github.com/user-attachments/assets/274335f9-70d8-4325-98de-c909cdc217f6)


## 1.2. Сколько было совершено внутриигровых покупок и что можно сказать об их стоимости (минимум и максимум, есть ли различие между средним значением и медианой, какой разброс данных)?

Внутри игры было совершено 1 307 678 покупок. Максимальная сумма покупки составляет 486 615,1, минимальная - 0. Минимальная стоимость без учета нулевых покупок составила 0,01. Разброс данных составляет 2 517,35. Среднее значение равно 525,69, значение медианы гораздо меньше - 74,86, это означает наличие аномально крупных покупок.

![image](https://github.com/user-attachments/assets/280ca3c1-811d-4758-83bf-8b06f44891ca)



## 1.3. Есть ли аномальные покупки по стоимости? Если есть, то сколько их?

Среди покупок 907 - с аномальной нулевой стоимостью. Их доля незначительна и  составляет 0,0007 от всех покупок. Предметом, который был приобретен за нулевую стоимость, является “Book of Legend”. 72 игрока купили ее 907 раз, значит, у игроков было несколько возможностей приобрести данный предмет бесплатно.

![image](https://github.com/user-attachments/assets/f137c504-d991-48aa-8794-d2b14e05172c)

![image](https://github.com/user-attachments/assets/697e7ef7-34d1-49f8-96d8-4bc9a689d53a)


## 1.4. Сколько игроков совершают внутриигровые покупки и насколько активно? Сравните поведение платящих и неплатящих игроков.

Среди неплатящих игроков 11 348 человек совершает покупки, среднее количество покупок на игрока - 97, средняя общая стоимость - 48 592,7. 
Платящих игроков, совершающих покупки, значительно меньше -  2 444. На одного пользователя в среднем приходится 81 покупка. Средняя общая стоимость выше, чем для неплатящих игроков, она составляет 55 469,72.

![image](https://github.com/user-attachments/assets/9f964195-f817-4cc0-a59c-475524510d66)



## 1.5. Есть ли среди эпических предметов популярные, которые покупают чаще всего? 
Самым популярным эпическим предметом является “Book of Legends”, его купили 1 004 516 раз. На этот предмет приходится 76% от общего числа покупок. Доля игроков, хоть раз купивших этот предмет, составляет 0,54.
Вторым по популярности эпическим предметом является “Bag of Holding”, его купили 271 875 раз. На этот предмет приходится 21% от общего числа покупок. Доля игроков, хоть раз купивших этот предмет, составляет 0,53.

![image](https://github.com/user-attachments/assets/e704fbc5-bb91-43e5-aca3-6c7efffecd03)


## 2. Результаты решения ad hoc задачи
## 2.1. Существует ли зависимость активности игроков по совершению внутриигровых покупок от расы персонажа?
Наибольшее количество пользователей, совершивших покупки, приходится на расу “Human”, наименьшее количество пользователей у расы “Demon”. Наибольшая доля пользователей, совершивших покупки, приходится на расу “Orc” - 0,629, наименьшая доля пользователей у расы “Demon” - 0,6. Наибольшая доля платящих пользователей приходится на расу “Demon” - 0,2, наименьшая - на расу “Elf” - 0,16. Наибольшее среднее количество транзакций приходится на расу “Human” - 121, наименьшее - на расу “Demon” - 78. Наибольшая средняя сумма одной покупки у игроков с расой “Northman” - 761, наименьшая - у игроков с расой “Human” - 403. Наибольшая средняя сумма всех покупок у игроков с расой “Northman” - 62518, наименьшая - у игроков с расой “Demon” - 41 195.
Разница в долях пользователей, совершивших покупки составила 0,029, разница в долях платящих пользователей - 0,04. Не обнаружено явных признаков, что игра за какую-либо расу требует большего количества покупок эпических предметов, отклонения в значениях для разных рас небольшие и, скорее всего, они случайны.

![image](https://github.com/user-attachments/assets/26ea785e-920e-477f-bd47-1a7735320ad0)


# 3. Общие выводы и рекомендации
Среди игроков, совершающий покупки, очень большой разброс между платящими и неплатящими игроками, неплатящих игроков значительно больше. Покупательская способность игроков не связана с расой персонажа. Половина всех сумм покупок меньше 75 райских лепестков, при том, что максимальная сумма покупок 486 615,1, это значит, что многие игроки тратят мало игровой валюты на одну покупку, и также совершаются аномально крупные покупки. Предмет “Book of Legend” 907 раз был продан по нулевой стоимости, причем игроки могли купить его несколько раз. Это может быть связано, например, с проводимой среди игроков промо-кампанией, рекламирующей данный предмет или игру в целом.

Среди большого количества предметов в игре всего два пользуются большим спросом. Некоторые предметы купили всего один, два или три раза. Однако предметов, которые не купили ни разу, нет. Возможно, стоит меньше уделять ресурсов разработке большого количества предметов, а сосредоточиться на улучшении уже имеющихся и привлечении к ним внимания пользователей.

Чтобы стимулировать большее количество игроков перейти из неплатящих в платящие, можно прибегнуть к следующим стимулам:
-	Скидки на редкие товары с ограничением по времени, эффект дефицита(“Акция действует только сегодня”, “Осталось всего 10 предметов”, сезонные праздничные предметы и т.д.)
-	Гача-механики. За фиксированную сумму можно случайным образом выиграть предмет из определенного набора. Это создаст азарт у пользователей и они будут пробовать снова и снова.
-	Система подписки. Например, по подписке пользователю дается больше здоровья/маны, какие-либо предметы в подарок или другие преимущества перед пользователями без подписки.
