--ex1
SELECT
SUM(CASE
WHEN device_type = 'laptop' then 1 else 0
end) as laptop_views,
sum(case
when device_type in ('tablet','phone') then 1 else 0
End )as mobile_views
FROM viewership
--ex2
select x,y,z,
Case
when x+y>z then 'Yes'
Else 'No'
End as triangle
From Triangle
--ex4
select
name
From customer
where referee_id is null or referee_id != 2
--ex5
select
Case
when survived = 1 then 'survivors'
Else 'non-survivors' end as Category,
sum(Case
when pclass=1 then 1
Else 0
End) as first_class,
sum(case
when pclass=2 then 1 else 0 end) as second_class,
Sum(case when
pclass=3 then 1 else 0 end) as third_class
from titanic
Group by category
--ex3, bài này em tính đúng rồi (5.500000000) mà cứ round là nó lên thành 10.00 thay vì 5.5. Anh chữa giúp e với ạ
SELECT
round(cast(sum(Case
when call_category ='n/a'then 1.0
when call_category is NULL then 1.0 else 0.0
End) as decimal)/ 
cast(count(policy_holder_id) as decimal),1) *100.0
as uncategorised_call_pct
FROM callers
