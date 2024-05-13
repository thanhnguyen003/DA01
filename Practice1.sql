-- Ex1
select name from CITY
where population > 120000
And countrycode = 'USA'
--EX2
select * from City
where countrycode = 'JPN'
--EX3
select city, state from station
-- Ex4
Select distinct city from station
where city like 'A%' or city like 'E%' or city like 'I%' or city like 'O%' or city like 'U%'
--EX5
Select distinct city from station
where city like '%a' or city like '%e' or city like '%i' or city like '%o' or city like '%u'
-- EX6
Select distinct city from station
where not (city like 'A%' or city like 'O%' or city like 'I%' or city like 'E%' or city like 'U%')
--EX7
Select name from employee
Order by name
--EX8
Select name from employee
where salary >2000 and months < 10
Order by employee_id
--Ex9
select product_id from products
where low_fats ='Y' and recyclable = 'Y'
-- Ex10
select name from customer
where referee_id = 1 or referee_id is null
-- ex11
select name, population, area from World
where area >= 3000000 or population >=25000000
--ex12
select distinct author_id as id from views
where author_id = viewer_id
Order by author_id
--ex13
SELECT part,assembly_step FROM parts_assembly
where finish_date is NULL
--ex14
select * from lyft_drivers
where yearly_salary <= 30000 or >= 70000
--ex15
select advertising_channel from uber_advertising
where money_spent > 100000
And year = 2019
