--ex1 (bài này cái oceania của em cũng lệch 1 đơn vị em cũng k hiểu tại sao)
select b.continent as continent, floor(avg(a.population)) as avg_population from city as a
inner join country as b
On a.countrycode =b.code
Group by b.continent
Order by avg_population
--ex2
Select round(cast(count(b.email_id)as decimal)/cast(count(a.email_id) as decimal),2) as activation_rate FROM
Emails as a
LEFT JOIN texts as b 
on a.email_id=b.email_id
And b.signup_action = 'Confirmed'
--ex3
Select b.age_bucket,
ROUND(sum(Case when activity_type='send'then time_spent else 0 end)*100.0 / 
sum(Case when activity_type in ('send','open') then time_spent else 0 end),2) as send_perc,
round(sum(Case when activity_type='open'then time_spent else 0 end)*100.0 / 
sum(Case when activity_type in ('send','open') then time_spent else 0 end),2) as open_perc
From activities as a  
Left join age_breakdown as b 
On a.user_id=b.user_id
Group by b.age_bucket
--ex4
SELECT a.customer_id
FROM customer_contracts as a
Left join products as b 
On a.product_id = b.product_id
Group by a.customer_id
having count ( DISTINCT b.product_category) =3
--ex5 (bài này em cứ round cái avg(emp.age) là nó ra kết quả khác hẳn ấy ạ)
Select mng.employee_id,mng.name,count(emp.reports_to) as reports_count,round(avg(emp.age)) as average_age
From employees as emp
Join employees as mng
On emp.reports_to=mng.employee_id
Group by mng.employee_id, mng.name
order by mng.employee_id
--ex6
select b.product_name, sum(a.unit) as unit
From orders as a
Left join products as b
On a.product_id = b.product_id
where a.order_date between '2020-02-01' and '2020-02-28'
Group by b.product_name
having sum(a.unit)>=100
--ex7
SELECT a.page_id 
FROM pages as a 
Left join page_likes as b
On a.page_id = b.page_id
where liked_date is null
Order by a.page_id

--Mid course test
--ex1
select distinct replacement_cost from film
Order by replacement_cost
Limit 1
--ex2
SELECT 
  CASE 
    WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'low'
    WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 'medium'
    WHEN replacement_cost BETWEEN 25.00 AND 29.99 THEN 'high'
  END AS cost_range,
  COUNT(*) AS total_movies
FROM movies
GROUP BY cost_range
--ex3
select a.title, a.length, c.name 
from film as a
Join film_category as b on a.film_id = b.film_id
Join category as c on c.category_id = b.category_id
where c.name in ('Drama','Sports')
Order by a.length desc
--ex4
select count(a.title) as so_luong, c.name 
from film as a
Join film_category as b on a.film_id = b.film_id
Join category as c on c.category_id = b.category_id
group by c.name
Order by so_luong desc
--ex5
select b.first_name, b.last_name, 
	count(film_id) as so_luong
from film_actor as a
Left join actor as b on a.actor_id = b.actor_id
Group by b.first_name, b.last_name
Order by so_luong desc
--ex6
select count(a.address_id) 
from address as a
Left join customer as b on a.address_id = b.address_id
where b.address_id is Null
--ex7
select d.city,sum(a.amount) 
from payment as a
Join customer as b on a.customer_id = b.customer_id
Join address as c on c.address_id = b.address_id
Join city as d on c.city_id = d.city_id
Group by d.city
Order by  sum(a.amount) desc
--ex8 (câu này hình như câu hỏi hoặc đáp án sai ạ, phải là thành phố của đất nước nào đat doanh thu THẤP nhất)
select concat (d.city,',',' ',e.country),sum(a.amount) 
from payment as a
Join customer as b on a.customer_id = b.customer_id
Join address as c on c.address_id = b.address_id
Join city as d on c.city_id = d.city_id
join country as e on e.country_id = d.country_id
Group by concat (d.city,',',' ',e.country)
Order by  sum(a.amount)
