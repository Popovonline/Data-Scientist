/*Home work 2 part - �������� � ������� ���������� ����� � ������� �� ����� */
select 
/*customer.customer_id as CustomerID,
city.city_id as CityID,*/
customer.first_name as FirstName,
customer.last_name as LastName,
city.city as City
from customer
join address on address.address_id = customer.address_id
join city on city.city_id = address.city_id;

/* ��� �������� (��� ����)*/
select * from address
where address_id = 530;
select * from city
where city_id = 419;
select * from customer
where customer_id = 524;

/* �������� �������� - ��� �������� (��� ����)*/
select * from address;
select * from city;
select count (distinct customer_id) from customer;