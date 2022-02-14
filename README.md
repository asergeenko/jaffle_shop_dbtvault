# Data Vault building / Построение Data Vault

Для построения PIT таблицы я решил воспользоваться макросом pit, который появился в версии dbtvault 0.7.6-b1, поэтому в файле packages.yml ссылка на мой fork репозитория dbtvault, где эта ветка доработана для поддержки Postgres (с помощью вашего репозитория и Slack-сообщества dbtvault).

### 1. Постройте витрину данных над Data Vault
Динамика изменения количества заказов в разрезе календарной недели и статуса заказа

Включите код витрины в проект dbt, экспериментируйте с [материализацией](https://docs.getdbt.com/docs/building-a-dbt-project/building-models/materializations) – table, view.

<figure class="image">
  <img src="" alt="Загрузка данных">
  <figcaption>Загрузка данных</figcaption>
</figure>

<figure class="image">
  <img src="" alt="Слой stage">
  <figcaption>Слой stage</figcaption>
</figure>

<figure class="image">
  <img src="" alt="Слой DataVault">
  <figcaption>Слой DataVault</figcaption>
</figure>

<figure class="image">
  <img src="" alt="Слой витрины">
  <figcaption>Слой витрины</figcaption>
</figure>

<figure class="image">
  <img src="" alt="Динамика изменения количества заказов в разрезе календарной недели">
  <figcaption>Динамика изменения количества заказов в разрезе календарной недели</figcaption>
</figure>


Для витрины по изменениям динамики количества заказов была построена таблица num_orders

~~~
with sat_order_details as (
    select * from {{ ref('sat_order_details') }}
)

select date_part('year', order_date)::numeric as year,
       date_part('week', order_date)::numeric AS week,
 status, count(*) as num_orders
from sat_order_details
group by year,week, status
order by year,week, status
~~~

### 2. Покажите изменения атрибутного состава клиентов

Постройте представление Point-in-time table которое покажет актуальные атрибуты клиента (first name, last name, email) на заданный момент времени.

Используя полученное представление и запись клиента, для которой были [инициированы изменения](https://docs.google.com/document/d/1t_P0Cww9MgHYeGkIC6p-V4ZXddFaXj31_PrE1vLKPdU/edit#heading=h.hodqcf9p74pl), покажите как менялся атрибутный состав.

Point-in-table построена с помощью макроса: https://dbtvault.readthedocs.io/en/v0.7.6-b1/tutorial/tut_point_in_time/

Изменим фамилию одного из пользователей:
Было:
~~~
1,Michael,Perez,mperez0@chronoengine.com
~~~
Стало:
~~~
1,Michael,Perez-Holmes,mperez0@chronoengine.com
~~~

Применим полученные изменения и сделаем запрос к  PIT представлению (поле as_of_date сгенерировано с интервалом в один час):

![картинка]()


### 3. Предположим, что у вас появился новый источник данных о клиентах.

Для этого создайте в директории ./data/ новый csv-файл source_customers_crm.csv следующего содержания:

![картинка]()

Включите новый источник (файл) в наполнение детального слоя Data Vault:

Добавьте данные из нового файла в Hub customer
Добавьте новые атрибуты в отдельный Satellite
Обновите представление Point-in-time table которое покажет все актуальные атрибуты клиента (first name, last name, email) 

Покажите, как данные отражаются в Хабе и Сателлите.

<figure class="image">
  <img src="" alt="Сателлит sat_customer_crm">
  <figcaption>Сателлит sat_customer_crm</figcaption>
</figure>

<p align="center">
  <img src="https://user-images.githubusercontent.com/25080503/65772647-89525700-e132-11e9-80ff-12ad30a25466.png">
</p>

### dbt models for dbtvault Snowflake Demonstration

This is a downloadable example dbt project using [dbtvault](https://github.com/Datavault-UK/dbtvault) to create a Data Vault 2.0 Data Warehouse
based on the Snowflake TPC-H dataset.

---

#### dbtvault Docs
[![Documentation Status](https://readthedocs.org/projects/dbtvault/badge/?version=latest)](https://dbtvault.readthedocs.io/en/latest/?badge=latest)

Click the button above to read the latest dbtvault docs.

A guide for using this demo is available [here](https://dbtvault.readthedocs.io/en/latest/worked_example/we_worked_example/)

---
[dbt](https://www.getdbt.com/) is a registered trademark of [Fishtown Analytics](https://www.fishtownanalytics.com/).

Check them out below:

#### DBT Docs
- [What is dbt](https://dbt.readme.io/docs/overview)?
- Read the [dbt viewpoint](https://dbt.readme.io/docs/viewpoint)
- [Installation](https://dbt.readme.io/docs/installation)
- Join the [chat](http://ac-slackin.herokuapp.com/) on Slack for live questions and support.
---
