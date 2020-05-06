-- ������� �1: � ����� ������� ������ ������ ���������? - 10 ������
select 
	city, 
	count (distinct airport_code) as total_airports  -- ������� ���������� ���������� � ������ ������
from airports
group by city
having count (distinct airport_code) > 1;

-- ������� �2: � ����� ���������� ���� �����, ������� ������������� ���������� � ������������ ���������� ���������? - 15 ������

	-- ������� ������
select distinct 
	airports.airport_name as Airoport
from airports
join flights on flights.departure_airport = airports.airport_code		-- ��������� ��� �������� �� �����
where aircraft_code = (
select aircraft_code
from aircrafts_data
where range = (select max (range) from aircrafts_data)
);

-- ������� �3: ���� �� �����, �� ������� �� ����������� ��������? - 15 ������
select 
	tickets.book_ref as Book_number,
	tickets.ticket_no as Ticket_number,
	tickets.passenger_name as name_passenger
from tickets
left join boarding_passes on tickets.ticket_no = boarding_passes.ticket_no	-- ��������� ��� �������� �� �����
where boarding_passes.boarding_no is null;


-- ������� �4: �������� ����� ������� ��������� ���������� % ���������? - 25 ������

	-- ���-3 ������, ������� ��������� ���������� ���������� ��������� � ���������
select 
	aircrafts.model as Model,
	count (distinct flights.flight_id) * 100 /(select count (*) from flights where status = 'Arrived') as Percentage
from flights
join aircrafts on aircrafts.aircraft_code = flights.aircraft_code
where flights.status = 'Arrived'
group  by aircrafts.model
order by Percentage desc
limit 3;							-- ����� ������ ���-3

	-- ���-3 ������, ������� ��������� ���������� ���������� ��������� � �������������� ���������
select 
	aircrafts.model as Model,
	count (distinct flights.flight_id) as Percentage
from flights
join aircrafts on aircrafts.aircraft_code = flights.aircraft_code
where flights.status = 'Arrived'
group  by aircrafts.model
order by Percentage desc
limit 3;							-- ����� ������ ���-3

	-- ����� ���������� ��������� 
select count(*) 
from flights 
where status = 'Arrived'

-- ������� �5: ���� �� ������, � ������� �����  ��������� ������ - ������� �������, ��� ������-�������? - 25 ������

	--�������� ����������������� ������������� � ������ � �������
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

select * from prices; 			-- ���������� ����������������� �������������
drop materialized view prices;	-- ������� ����������������� �������������


--�������� ������� ����� ������� ������� ������ ������
create index pr1 on prices (flight_id)

create index pr2 on prices (arrival_city)

create index pr3 on prices (departure_city)

--������� ��� �����������, ��� ���� �� ����� ����� ���� �������� ������ ������ ������, ��� ������
select distinct
	e.departure_city,
	e.arrival_city
from
prices e 
join prices b on e.arrival_city = b.arrival_city and e.departure_city = b.departure_city and e.flight_id = b.flight_id
where e.total_amount > b.total_amount and e.fare_conditions ='Economy' and b.fare_conditions ='Business'

-- ������� �6: ������ ������������ ����� �������� ������� ���������? - 25 ������
	-- ������� ������������ ������������� ��������� ��������� � �������� ����� ����������� �� ����� > ����� ����������� �� ����������
create materialized view Delay as ( 
select 
	flight_id as ID_flight,
	actual_departure - scheduled_departure as Num1
from flights
where status = 'Arrived' and actual_departure > scheduled_departure);

select * from delay;				-- �������� ������������������ ������������� 
drop materialized view delay;		-- �������� ������������������ ������������� 
	
	-- ������ ������������ ����� ��������
select 
	ID_flight,
	max (num1) 
from delay -- ����� 04:41:00;

-- ������ ���� ����(�) 	
select * 
from delay 
where num1 = '04:41:00'; -- ��� ����� ���� � ����� ��������� 

-- ������� �7: ����� ������ �������� ��� ������ ������*? - 35 ������
	-- ��������� ��� ��������� ���� �������
create materialized view City as (		-- �������� ���������������� �������������
select 
	a1.airport_code as Code1_city,
	a1.airport_name as First_city,
	a2.airport_name as Second_city,
	a2.airport_code as Code2_city
from airports a1
cross join airports a2
where a1.airport_name !=a2.airport_name);

select * from city;				-- ������������� �������������
drop materialized view city;	-- ������� �������������

	-- ��������� ������ ����� �������� ���������� ������ ����� 
select distinct 
First_city,
Second_city
from city
left join routes r on r.departure_airport != city.code1_city and r.arrival_airport != city.code2_city
where first_city is not null and second_city is not null;

	-- �������� ������������ ������� �� ����� �� ���� �������, ����� �������� ��� ������� �����
select * from routes
where departure_city = '��������' and arrival_city = '�������';

-- ������� �8: ����� ������ �������� ��������� ������ ���������? - 35 ������
--������� ������������ �������������
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

select * from passengers_flights;				-- ������������� �������������
drop materialized view passengers_flights;		-- ������� �������������

--�������� �������
create index id on passengers_flights (passenger_id)
create index iddep on passengers_flights (departure_airport)
create index idarr on passengers_flights (arrival_airport)
create index id1 on airports (airport_code)

--������� ���� ����������, �������� � �����������
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

select * from transits;				-- ������������� �������������
drop materialized view transits;	-- ������� �������������
	
--������� ������ ���������� ��������� �������, ����� �������� ���� ���������
	
select distinct  departure_city, arrival_city
from transits
order by 1,2
