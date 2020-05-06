/* �������� �1 */
/*  �������� ������ �������� ���� ������� � �� ������ (������� language) */
select 
film.title FilmTitle, 
language.name languageFilm
from film
inner join language on film.language_id = language.language_id;

/* �������� ������ ���� �������, ����������� � ������ Lambs Cincinatti (?lm_id = 508). ���� ������������ 2 join'� � ���� where */
select 
actor.first_name as NameActor,
actor.last_name as FamilyActor
from actor
join film_actor on actor.actor_id = film_actor.actor_id
join film on film_actor.film_id = film.film_id
where film.film_id = 508;
 
select * from film
where film_id= 508;

select * from film_actor 
where film_id= 508;

/* �������� �2 ���������� ������� � ������*/
select 
count (distinct actor_id) as TotalActor 
from film_actor
where film_id = 384;

/* �������� �3 �������� ������ �������, � ������� ��������� ������ 10 �������*/
select 
film_id as Film, 
count(distinct actor_id) as TotalActor
from film_actor
group by film_id
having count(distinct actor_id) > 10;

/* �������� �4 �������� ������� � 3-�� ������: �������� ������, ��� ������ � ���������� �������, � ������� �� �������� */
select 
actor_id as ActorID,
count (distinct film_id) as TotalFilm
from film_actor
group by actor_id;
 
select 
film.title as film,
actor.first_name as Actor,
count (distinct film_actor.film_id) as TotalFilm
from film_actor
join actor on actor.actor_id = film_actor.actor_id
join film on film.film_id = actor.actor_id
group by film_actor.actor_id, actor.first_name, film.title;





