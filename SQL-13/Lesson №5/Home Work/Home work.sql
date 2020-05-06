/* Task #1: �������� ������ � ������� rental. �������� ������� � ���������� ������� ������ (����������� �� rental_date) ��� ������� ����� */

create view my_query as					-- ������� ������������� ������ 
	select rental_id, customer_id
	from rental
	order by rental_date;

select * from my_query;					-- �������� ������ ������� 
drop view my_query;						-- ������ ������ ������������� ������ 

/* Task #2: ��� ������� ������������ ����������� ������� �� ���� � ������ ������� �� ����������� ��������� Behind the Scenes  */

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
count (film.film_id) over (partition by customer.customer_id) as Total -- ���������� ������� ������� 
from customer
join rental on rental.customer_id = customer.customer_id
join inventory on inventory.inventory_id = rental.inventory_id
join film on film.film_id = inventory.film_id
where special_features = '{Behind the Scenes}'
group by customer.customer_id, film.film_id;

-- Materialized View of Option #1
create materialized view view_my_query  -- ������� ���������������� �������������
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

select * from view_my_query;				-- �������� ������ �������
refresh materialized view view_my_query;	-- ��������� ����������������� �������������
drop materialized view view_my_query;		-- ������� ����������������� �������������

-- explain for Option #1
explain										-- ������ ������ explain
	select 
	customer.customer_id as ID_client,
	count (distinct film.film_id) as Total
	from customer
	join rental on rental.customer_id = customer.customer_id
	join inventory on inventory.inventory_id = rental.inventory_id
	join film on film.film_id = inventory.film_id
	where special_features = '{Behind the Scenes}'
	group by customer.customer_id

	/* ������� �������� ������� �������:
	 * � ��������� ������� explain - ������ ������ � ��� ������, ������������ � �->" � ��� ��������. 
	 * ��������� ������ � �������������� ���������� � �������� ����. 
	 * � ����� ������ ���� ����� 11 ��������: GroupAggregate, sort, hash join, nasted loop � �.�. */
	
