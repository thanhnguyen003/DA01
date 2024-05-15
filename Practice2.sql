--Ex1
select distinct city from station
where (id % 2) in (0,2,4,6,8)
--ex2
Select count(city) - count(distinct city) from station
--ex3: e không biết làm
--ex4
SELECT round(cast(sum(item_count*order_occurrences)/sum(order_occurrences) as decimal),1) 
as mean FROM items_per_order
--ex5
SELECT candidate_id FROM candidates
where skill in ('Python','Tableau','PostgreSQL')
Group by candidate_id
Having count(candidate_id) =3
Order by candidate_id
--ex6
select user_id, Date(max(post_date))-Date(min(post_date)) as days_between
from posts
where post_date between '01/01/2021' and '01/01/2022'
Group by user_id
Having count(user_id)>=2
--ex7
Select card_name, max(issued_amount)-min(issued_amount) as difference
From monthly_cards_issued
Group by card_name
Order by difference desc
--ex8
select manufacturer, 
Count(drug) as drug_count,
Abs(sum(cogs-total_sales)) as total_loss
From pharmacy_sales
where total_sales<cogs
Group by manufacturer
Order by total_loss desc
--ex9
Select id, movie, description, rating from cinema
where id%2 in (1,3,5,7,9) and description not like '%boring%'
order by rating desc
--ex10
select teacher_id,
Count(distinct subject_id) as cnt
From teacher
Group by teacher_id
--ex11
Select user_id, count(follower_id) as followers_count from Followers
Group by user_id
Order by user_id
--ex12
select class from Courses
Group by class
having count(student)>=5
