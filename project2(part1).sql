--Ad-hoc
--ex1
with x as (Select 
*, extract(year from c.created_at)||'-'|| extract(month from c.created_at) as month_year
from bigquery-public-data.thelook_ecommerce.users as a
join bigquery-public-data.thelook_ecommerce.orders as c
On a.id=c.user_id
where c.status = 'Complete'
And extract(year from c.created_at)||'-'|| extract(month from c.created_at) between '2019-01' and '2022-04')
Select month_year,count(id) as total_user,count(order_id) as total_order
From x
Group by month_year
Order by month_year
--ex2
with y as (select distinct a.id as distinct_users,
extract(year from a.created_at)||'-'|| extract(month from a.created_at) as month_year,
D.sale_price as sale_price
from bigquery-public-data.thelook_ecommerce.order_items as d
inner join bigquery-public-data.thelook_ecommerce.users as a
on a.id=d.id
where extract(year from a.created_at)||'-'|| extract(month from a.created_at) between '2019-1' and '2022-4')

Select month_year,
Count(distinct_users) over(partition by month_year order by month_year)  as distinct_users,
Avg(sale_price) over(partition by month_year order by month_year) as average_order_value
From y
--ex3
with z as (select first_name, last_name, gender,age,
Case when
Age = min(age) over (partition by gender) then 'youngest'
when age = max(age) over (partition by gender) then 'oldest' else null
end as tag,
extract(year from created_at)||'-'|| extract(month from created_at) as month_year
from bigquery-public-data.thelook_ecommerce.users
where extract(year from created_at)||'-'|| extract(month from created_at) between '2019-01' and '2022-04')
Select first_name, last_name, gender,age, tag
From z
where tag = 'youngest' or tag = 'oldest'
order by gender,tag
--ex4
with k as (Select extract(year from d.created_at)||'-'|| extract(month from d.created_at) as month_year,
d.product_id,
b.name,
sum(sale_price) over (partition by extract(year from d.created_at)||'-'|| extract(month from d.created_at),d.product_id order by extract(year from d.created_at)||'-'|| extract(month from d.created_at)) as tong_sale,
sum(cost) over (partition by extract(year from d.created_at)||'-'|| extract(month from d.created_at),d.product_id order by extract(year from d.created_at)||'-'|| extract(month from d.created_at)) as tong_cost,
sum(sale_price) over (partition by extract(year from d.created_at)||'-'|| extract(month from d.created_at),d.product_id order by extract(year from d.created_at)||'-'|| extract(month from d.created_at)) 
- 
sum(cost) over (partition by extract(year from d.created_at)||'-'|| extract(month from d.created_at),d.product_id order by extract(year from d.created_at)||'-'|| extract(month from d.created_at)) as tong_profit
from bigquery-public-data.thelook_ecommerce.products as b
join bigquery-public-data.thelook_ecommerce.order_items as d
On b.id =d.id)
select month_year,product_id,product_name, sales,cost, profit, rank_per_month from  (Select month_year,product_id,name as product_name,tong_sale as sales,tong_cost as cost, tong_profit as profit,
dense_Rank()over(partition by month_year order by tong_profit desc) as rank_per_month
From k)
where rank_per_month<=5
--ex5
with j as (select
Extract(date from d.created_at) as dates,
E.product_category as product_categories,
sum(d.sale_price) over (partition by E.product_category order by Extract(date from d.created_at)) as revenue
from bigquery-public-data.thelook_ecommerce.inventory_items as e
join bigquery-public-data.thelook_ecommerce.order_items as d
On d.id = e.id)
Select dates,product_categories,revenue
From j
where dates between '2022-01-15' and '2022-04-15'
