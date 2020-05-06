-- Задание №1: В каких городах больше одного аэропорта? - 10 баллов
select 
	city, 
	count (distinct airport_code) as total_airports  -- считаем количество аэропортов в каждом городе
from airports
group by city
having count (distinct airport_code) > 1;

-- Задание №2: В каких аэропортах есть рейсы, которые обслуживаются самолетами с максимальной дальностью перелетов? - 15 баллов

	-- Решение задачи
select distinct 
	airports.airport_name as Airoport
from airports
join flights on flights.departure_airport = airports.airport_code		-- соединяем две сущности по ключу
where aircraft_code = (
select aircraft_code
from aircrafts_data
where range = (select max (range) from aircrafts_data)
);

-- Задание №3: Были ли брони, по которым не совершались перелеты? - 15 баллов
select 
	tickets.book_ref as Book_number,
	tickets.ticket_no as Ticket_number,
	tickets.passenger_name as name_passenger
from tickets
left join boarding_passes on tickets.ticket_no = boarding_passes.ticket_no	-- соединяем две сущности по ключу
where boarding_passes.boarding_no is null;


-- Задание №4: Самолеты каких моделей совершают наибольший % перелетов? - 25 баллов

	-- ТОП-3 модели, которые совершают наибольшее количество перелетов в процентах
select 
	aircrafts.model as Model,
	count (distinct flights.flight_id) * 100 /(select count (*) from flights where status = 'Arrived') as Percentage
from flights
join aircrafts on aircrafts.aircraft_code = flights.aircraft_code
where flights.status = 'Arrived'
group  by aircrafts.model
order by Percentage desc
limit 3;							-- вывод первых ТОП-3

	-- ТОП-3 модели, которые совершают наибольшее количество перелетов в количественном выражении
select 
	aircrafts.model as Model,
	count (distinct flights.flight_id) as Percentage
from flights
join aircrafts on aircrafts.aircraft_code = flights.aircraft_code
where flights.status = 'Arrived'
group  by aircrafts.model
order by Percentage desc
limit 3;							-- вывод первых ТОП-3

	-- Общее количество перелетов 
select count(*) 
from flights 
where status = 'Arrived'

-- Задание №5: Были ли города, в которые можно  добраться бизнес - классом дешевле, чем эконом-классом? - 25 баллов

	--создадим материализованное представление с ценами и рейсами
create materialized view prices as(
select
	a1.city as departure_city,
	a2.city as arrival_city,
	s.fare_conditions,
	b.total_amount,
	f.flight_id 
from 
bookings b 
join tickets t on b.book_ref = t.book_ref 
join boarding_passes bp on t.ticket_no = bp.ticket_no 
join flights f on f.flight_id = bp.flight_id 
join airports a1 on a1.airport_code = f.departure_airport 
join airports a2 on a2.airport_code = f.arrival_airport  
join seats s on s.seat_no = bp.seat_no and f.aircraft_code = s.aircraft_code 
where 
s.fare_conditions in('Economy', 'Business')
);

select * from prices; 			-- посмотреть материализованное представление
drop materialized view prices;	-- удалить материализованное представление


--создадим индексы чтобы быстрее работал второй запрос
create index pr1 on prices (flight_id)

create index pr2 on prices (arrival_city)

create index pr3 on prices (departure_city)

--выберем все направления, где хоть на одном рейсе были замечены билеты эконом дороже, чем бизнес
select distinct
	e.departure_city,
	e.arrival_city
from
prices e 
join prices b on e.arrival_city = b.arrival_city and e.departure_city = b.departure_city and e.flight_id = b.flight_id
where e.total_amount > b.total_amount and e.fare_conditions ='Economy' and b.fare_conditions ='Business'

-- Задание №6: Узнать максимальное время задержки вылетов самолетов? - 25 баллов
	-- Сделаем материальное представление прибывших самолетов с условием время отправления по факту > время отправления по расписанию
create materialized view Delay as ( 
select 
	flight_id as ID_flight,
	actual_departure - scheduled_departure as Num1
from flights
where status = 'Arrived' and actual_departure > scheduled_departure);

select * from delay;				-- просмотр материализованного представления 
drop materialized view delay;		-- удаление материализованного представления 
	
	-- найдем максимальное время задержки
select 
	ID_flight,
	max (num1) 
from delay -- Ответ 04:41:00;

-- найдем этот рейс(ы) 	
select * 
from delay 
where num1 = '04:41:00'; -- Два рейса были с такой задержкой 

-- Задание №7: Между какими городами нет прямых рейсов*? - 35 баллов
	-- Определим все возможные пары городов
create materialized view City as (		-- создадим материализованое представление
select 
	a1.airport_code as Code1_city,
	a1.airport_name as First_city,
	a2.airport_name as Second_city,
	a2.airport_code as Code2_city
from airports a1
cross join airports a2
where a1.airport_name !=a2.airport_name);

select * from city;				-- просматриваем представление
drop materialized view city;	-- удаляем представление

	-- Определим города между которыми отсутсвуют прямые рейсы 
select distinct 
First_city,
Second_city
from city
left join routes r on r.departure_airport != city.code1_city and r.arrival_airport != city.code2_city
where first_city is not null and second_city is not null;

	-- проверка правильности решения по одной из пары городов, между которыми нет прямого рейса
select * from routes
where departure_city = 'Белгород' and arrival_city = 'Нальчик';

-- Задание №8: Между какими городами пассажиры делали пересадки? - 35 баллов
--Сделаем материальное представление
create materialized view passengers_flights as
select
	t.passenger_id,
	t.passenger_name,
	tf.flight_id,
	f.actual_departure,
	f.actual_arrival,
	f.scheduled_departure,
	f.scheduled_arrival,
	f.arrival_airport,
	f.departure_airport 
from 
	tickets t,
	ticket_flights tf,
	flights f 
where 
	t.ticket_no=tf.ticket_no
	and f.flight_id = tf.flight_id 
	order by t.passenger_name;

select * from passengers_flights;				-- просматриваем представление
drop materialized view passengers_flights;		-- удаляем представление

--создадим индексы
create index id on passengers_flights (passenger_id)
create index iddep on passengers_flights (departure_airport)
create index idarr on passengers_flights (arrival_airport)
create index id1 on airports (airport_code)

--выведем всех пассажиров, летевших с пересадками
create materialized view transits as (
select
	pf.passenger_name,
	a1.city as departure_city,
	a2.city as transit_city,
	a3.city as arrival_city,
	(pf1.scheduled_departure-pf.scheduled_arrival) as TransitTime
from 
	passengers_flights pf join passengers_flights pf1 on pf.passenger_id = pf1.passenger_id
	join airports a1 on a1.airport_code = pf.departure_airport 
	join airports a2 on a2.airport_code = pf.arrival_airport 
	join airports a3 on a3.airport_code = pf1.arrival_airport 
where 
	pf.arrival_airport = pf1.departure_airport 
	and pf.departure_airport != pf1.arrival_airport 
	and pf1.scheduled_departure < pf.scheduled_arrival + interval '24 hours' 
	and pf1.scheduled_departure > pf.scheduled_arrival 
	);

select * from transits;				-- просматриваем представление
drop materialized view transits;	-- удаляем представление
	
--Оставим только уникальные сочетания городов, между которыми были пересадки
	
select distinct  departure_city, arrival_city
from transits
order by 1,2
