/* �������� �1*/

	/* Create Table*/
CREATE TABLE Avtor (
	id_avtor	serial	PRIMARY KEY,	-- ������������� id ����� ������
	NameAvtor	varchar(30)	NOT NULL,	-- ��������� ��� ������, ������������ ���� ��� ���������� (��������� �����������)
	nickname	varchar(30)	UNIQUE,		-- ��������� ������� (������������� ��� ����������)
	born_date	date	NOT NULL);	-- ��������� ���� �������� 

	/* check out table*/
select * from avtor;
drop table avtor; 

/* �������� �2*/

	/* Fill in table*/
insert into avtor (nameavtor, nickname, born_date) 
values 
	('Zoom', 'Zone' , '01/08/2010'),				-- ��������� ������� ���� �������� 
	('Zine', 'Fox',	'01/12/2010'),
	('Zill', 'Trade', '01/12/1988');

	/* Create a new column*/
alter table Avtor add column City_born varchar(30);	-- ��������� ������� � ��������

	/* Add information*/
update avtor										-- ������ ������ � ����� �������
set city_born = 'New York'
where id_avtor = 1;

/* �������� �3*/

	/* Create Table*/
create table Proza (
	id_proza serial primary key,					-- ����������� id ����� ������������
	proza_name varchar (80) unique not null,		-- ��������� ��� ������������
	url varchar(50) not null,						-- ��������� ������ �� ������������
	year_proza date not null,						-- ��������� ���� �������� ������������
	id_avtor integer references avtor(id_avtor));	-- ������� ���� � ������������ ��������

select * from proza;
drop table proza; 

	/* Fill in table*/
insert into proza (proza_name, url,year_proza, id_avtor)		-- ��������� ������ � �������
values
	('Fuck','www.google.com','01/09/1990', 1),
	('Shark','www.yahoo.com','01/09/1990', 2),
	('Dark','www.yahoo.com','01/09/1990', 3);

	/*Try to delete a avtor*/
delete from avtor
where id_avtor = 1;

/* �������� �4*/
	/* Create Table*/
create table orders (
	ID serial primary key,
	info json not null);

select * from orders;
drop table orders;

	/* Fill in table*/
insert into orders(info)
values 
(
'{"customer":"John Doe", "items": {"product": "Beer", "qty": 6}}'
),
(
'{"customer": "Lily Bush", "items":{"product": "Deaper","qty": 24}}'
),
(
'{"customer": "Josh William", "items":{"product": "Toy Car","qty": 1}}'
),
(
'{"customer": "Mary Clark", "items":{"product": "Toy train","qty": 2}}'
);

select 
sum (cast (info -> 'items' ->> 'qty' as integer))
from orders;

/* �������� �5*/
 select count(special_features)
 from film
 where special_features is not null;

