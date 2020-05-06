/* Task #1: —делайте запрос к таблице rental. ƒобавьте колонку с пор€дковым номером аренды (сортировать по rental_date) дл€ каждого юзера */

create view my_query as					-- —оздаем представление данных 
	select rental_id, customer_id
	from rental
	order by rental_date;

select * from my_query;					-- получаем данные запроса 
drop view my_query;						-- удалем запрос представлени€ данных 

/* Task #2: ƒл€ каждого пользовател€ подсчитайте сколько он брал в аренду фильмов со специальным атрибутом Behind the Scenes  */

-- Option #1
select 
customer.customer_id as ID_client,
count (distinct film.film_id) as Total
from customer
join rental on rental.customer_id = customer.customer_id
join inventory on inventory.inventory_id = rental.inventory_id
join film on film.film_id = inventory.film_id
where special_features = '{Behind the Scenes}'
group by customer.customer_id;

-- Option #2 for myself
select 
customer.customer_id as ID_client, 
film.title as Film,
count (film.film_id) over (partition by customer.customer_id) as Total -- используем оконную функцию 
from customer
join rental on rental.customer_id = customer.customer_id
join inventory on inventory.inventory_id = rental.inventory_id
join film on film.film_id = inventory.film_id
where special_features = '{Behind the Scenes}'
group by customer.customer_id, film.film_id;

-- Materialized View of Option #1
create materialized view view_my_query  -- создаем матеиализованное представление
as 
	select 
	customer.customer_id as ID_client,
	count (distinct film.film_id) as Total
	from customer
	join rental on rental.customer_id = customer.customer_id
	join inventory on inventory.inventory_id = rental.inventory_id
	join film on film.film_id = inventory.film_id
	where special_features = '{Behind the Scenes}'
	group by customer.customer_id
with data;

select * from view_my_query;				-- получаем данные запроса
refresh materialized view view_my_query;	-- обновл€ем материализованное представление
drop materialized view view_my_query;		-- удал€ем материализованное представление

-- explain for Option #1
explain										-- делаем запрос explain
	select 
	customer.customer_id as ID_client,
	count (distinct film.film_id) as Total
	from customer
	join rental on rental.customer_id = customer.customer_id
	join inventory on inventory.inventory_id = rental.inventory_id
	join film on film.film_id = inventory.film_id
	where special_features = '{Behind the Scenes}'
	group by customer.customer_id

	/*  раткое описание данного запроса:
	 * ¬ резульате запроса explain - перва€ строка и все строки, начинающиес€ с У->" Ц это операции. 
	 * ќстальные строки Ц дополнительна€ информаци€ к операции выше. 
	 * ¬ нашем случае есть всего 11 операций: GroupAggregate, sort, hash join, nasted loop и т.д. */
	
