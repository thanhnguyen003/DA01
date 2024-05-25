--ex1
with job_count as(
select company_id,title,description,
Count(job_id) as job_count
From job_listings
group by company_id, title, description)
select count(distinct company_id) as duplicate_companies
From job_count
where job_count >=2
--ex2: (select category,product,sum(spend) as total_spend
From product_spend
where extract (year from transaction_date) = '2022'
And category = 'appliance'
Group by category, product
order by total_spend desc
Limit 2)
UNION ALL
(select category,product,sum(spend) as total_spend
From product_spend
where extract (year from transaction_date) = '2022'
And category = 'electronics'
Group by category, product
order by total_spend desc
Limit 2)
--ex3
with cte as (select policy_holder_id,count(case_id) as count_case from callers
Group by policy_holder_id having count(case_id) >=3)
Select count(policy_holder_id) as policy_holder_count
From cte 
--ex4
SELECT a.page_id 
FROM pages as a 
Left join page_likes as b
On a.page_id = b.page_id
where liked_date is null
Order by a.page_id
--ex5:
with july as (select distinct user_id as a,
To_char (event_date, 'MM-YYYY') as thang from user_actions
where To_char (event_date, 'MM-YYYY') = '07-2022'),
june as (select DISTINCT user_id as b,
To_char (event_date, 'MM-YYYY') from user_actions
where To_char (event_date, 'MM-YYYY') = '06-2022')
Select count(july.a) as monthly_active_users
From june
join july 
On june.b=july.a
--ex6
with a as (select country, to_char(trans_date, 'YYYY-MM') as month, count(trans_date) as trans_count, sum(amount) as trans_total_amount
From transactions
group by country, month),
b as (select country, to_char(trans_date, 'YYYY-MM') as month, count(trans_date) as approved_count, sum(amount) as approved_total_amount
From transactions
where state ='approved'
group by country, month)
Select a.trans_count,a.trans_total_amount,b.approved_count,b.approved_total_amount, a.country,a.month
from a
left Join b
On a.month=b.month
Group by a.country,a.month,a.trans_count,a.trans_total_amount,b.approved_count,b.approved_total_amount
--ex7
with cte as (select product_id,min(year) as first_year
From sales
group by product_id)
Select cte.product_id,cte.first_year,sales.quantity, sales.price
From sales
join cte
On cte.product_id = sales.product_id
where cte.first_year = sales.year
--ex8
SELECT  customer_id FROM Customer GROUP BY customer_id
HAVING COUNT(distinct product_key) = (SELECT COUNT(product_key) FROM Product)
--ex9
select employees.employee_id from employees
where manager_id is not null
And manager_id not in (select a.manager_id
from employees as a
Join employees as b
On a.manager_id = b.employee_id)
--ex10
with job_count as(
select company_id,title,description,
Count(job_id) as job_count
From job_listings
group by company_id, title, description)
select count(distinct company_id) as duplicate_companies
From job_count
where job_count >=2
--ex11
with x as (select c.user_id,b.name,count(name)
From movierating as c
Left join users as b
On c.user_id = b.user_id
Group by c.user_id,b.name
order by count(name)desc,b.name asc
Limit 1),
y as (Select c.movie_id,avg(c.rating),a.title
From movierating as c
Left join movies as a
On c.movie_id = a.movie_id
where to_char(c.created_at, 'YYYY-MM') = '2020-02'
Group by c.movie_id,a.title
Order by avg(c.rating)desc,a.title asc
Limit 1)
Select x.name as results from x 
union select y.title from y
--ex12
with cte as (select requester_id as id from requestaccepted
Union all
Select accepter_id from requestaccepted)
Select id, count(id) as num from cte
Group by id
Order by num desc
Limit 1
