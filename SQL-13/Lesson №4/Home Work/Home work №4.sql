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
	('Английский'),
	('Русский'),
	('Немецкий'),
	('Испанский'),
	('Французский');

	/* Create Table of Nationality*/
create table nationalityX (
	id_nationality serial primary key,
	name_nationality varchar (50) unique not null,
	id_language integer references langX (id_language)); -- внешний ключ

select * from nationalityX;
drop table nationalityX;

	/* Fill in Table of Nationality*/
insert into nationalityX (name_nationality, id_language)
values 
	('Русский', 2),
	('Немец', 3),
	('Британец', 1),
	('Француз', 4),
	('Монгол', 4);

	/* Create Table of Country*/
create table CountryX (
	id_country serial primary key,
	id_nationality integer references nationalityX (id_nationality), -- внешний ключ
	name_country varchar (50) not null);

select * from countryX;
drop table countryX;

	/* Fill in Table of Country*/
insert into CountryX (name_country, id_nationality)
values 
	('Россия', 1),
	('Россия', 2),
	('Англия', 3),
	('Германия', 4),
	('Франция', 4);

	