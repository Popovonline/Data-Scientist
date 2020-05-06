/*Check*/
select 
actor.actor_id as actor_id,
actor.first_name as name_actor,
actor.last_name as family_actor,
count (distinct film_actor.film_id) as Total
from actor
join film_actor on actor.actor_id = film_actor.actor_id
where actor.actor_id = 13
group by actor.actor_id;

select 
actor.actor_id as actor_id,
actor.first_name as name_actor,
actor.last_name as family_actor,
film.title as Film_name,
count (distinct film_actor.film_id) as Total
from actor
join film_actor on actor.actor_id = film_actor.actor_id
join film on film.film_id = actor.actor_id
group by actor.actor_id, film.film_id;

/* Практика №1 */
select
film.title as film_name,
actor.first_name as name_actor,
count (film_actor.film_id) over (partition by actor.actor_id) as Total_movies -- применяем оконную функцию
from actor
join film_actor on actor.actor_id = film_actor.actor_id                       -- соединяем сущности (таблицы)
join film on film.film_id = film_actor.film_id
order by film.film_id;

/* Практика №2 */
with cte_Employer as (							   -- создаю CTE временный результат запроса  
	select 
	staff.staff_id as ID,
	staff.first_name as Name_Employer,
	staff.last_name as Family_Employer,
	count (distinct rental_id) as Total_Sell	   -- считаем количество продаж сотрудника
	from rental
	join staff on staff.staff_id = rental.staff_id -- соединяем сущности
	group by rental.staff_id, staff.staff_id)
select * from cte_Employer;

/* Практика №3 */
create view My_query as 												-- создание именного запроса ПРЕДСТАВЛЕНИЯ 
	select 
	customer.first_name as Name_Client,
	customer.last_name as Family_Client,
	customer.email as Email_client,
	film.title as Film,
	rental.rental_date as Date_rental
	from customer
	join rental on rental.customer_id = customer.customer_id
	join inventory on inventory.inventory_id = rental.inventory_id
	join film on film.film_id = inventory.film_id
	order by rental.rental_date desc
	limit all offset 1;

select * from my_query;			-- вызов запроса
drop view my_query;				-- удаление именованного запроса ПРЕДСТАВЛЕНИЯ

/* Практика №4 */

