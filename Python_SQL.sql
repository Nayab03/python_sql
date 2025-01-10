-- FIND TOP 10 HIGHEST REVENUE GENERATING PRODUCTS

select top 10 product_id, sum(sale_price) as sales
from df_orders
group by product_id
order by sales desc;

--FIND TOP 5 HIGHEST SELLING PRODUCTS IN EACH REGION

with cte as (
select region, product_id, sum(sale_price) as sales
from df_orders
group by region, product_id
)
select * from (
select *
, row_number() over(partition by region order by sales desc) as rn
from cte) as A
where rn<=5

--FIND MONTH OVER MONTH GROWTH COMPARISON FOR 2022 AND 2023 SALES EG: JAN 2022 VS JAN 2023

with cte as(
select year(order_date) as order_year, month(order_date) as order_month, sum(sale_price) as sales
from df_orders
group by year(order_date), month(order_date)
)
select order_month, 
sum(case when order_year = 2022 then sales else 0 end) as sales_2022,
sum(case when order_year = 2023 then sales else 0 end) as sales_2023
from cte
group by order_month
order by order_month;

--FOR EACH CATEGORY WHICH MONTH HAD HIGHEST SALES
with cte as (
select category, format(order_date,'yyyyMM') as order_year_month, sum(sale_price) as sales
from df_orders
group by category, format(order_date, 'yyyyMM')
)
select * from (
select *, row_number() over(partition by category order by sales desc) as rn
from cte) as A
where rn=1

--WHICH SUB CATEGORY HAD HIGHEST GROWTH BY PROFIT IN 2023 COMPARE TO 2022
with cte as(
select sub_category, year(order_date) as order_year, sum(sale_price) as sales
from df_orders
group by sub_category, year(order_date)
),
cte2 as (
select sub_category,
sum(case when order_year = 2022 then sales else 0 end) as sales_2022,
sum(case when order_year = 2023 then sales else 0 end) as sales_2023
from cte
group by sub_category
)
select top 1 *, (sales_2023-sales_2022)
from cte2
order by (sales_2023-sales_2022) desc;









