/* HOME WORK #4*/

	/* Create Table of Language*/
create table LangX (
	id_language	serial primary key,
	name_language varchar (50) unique not null);

select * from langX;
drop table langX;

	/* Fill in Table of Language*/
insert into LangX (name_language)
values 
	('����������'),
	('�������'),
	('��������'),
	('���������'),
	('�����������');

	/* Create Table of Nationality*/
create table nationalityX (
	id_nationality serial primary key,
	name_nationality varchar (50) unique not null,
	id_language integer references langX (id_language)); -- ������� ����

select * from nationalityX;
drop table nationalityX;

	/* Fill in Table of Nationality*/
insert into nationalityX (name_nationality, id_language)
values 
	('�������', 2),
	('�����', 3),
	('��������', 1),
	('�������', 4),
	('������', 4);

	/* Create Table of Country*/
create table CountryX (
	id_country serial primary key,
	id_nationality integer references nationalityX (id_nationality), -- ������� ����
	name_country varchar (50) not null);

select * from countryX;
drop table countryX;

	/* Fill in Table of Country*/
insert into CountryX (name_country, id_nationality)
values 
	('������', 1),
	('������', 2),
	('������', 3),
	('��������', 4),
	('�������', 4);

	