/* Практика №1 */
/*  Выведите список названий всех фильмов и их языков (таблица language) */
select 
film.title FilmTitle, 
language.name languageFilm
from film
inner join language on film.language_id = language.language_id;

/* Выведите список всех актеров, снимавшихся в фильме Lambs Cincinatti (?lm_id = 508). Надо использовать 2 join'а и один where */
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

/* Практика №2 Количество актеров в фильме*/
select 
count (distinct actor_id) as TotalActor 
from film_actor
where film_id = 384;

/* Практика №3 Выведите список фильмов, в которых снималось больше 10 актеров*/
select 
film_id as Film, 
count(distinct actor_id) as TotalActor
from film_actor
group by film_id
having count(distinct actor_id) > 10;

/* Практика №4 Выведите таблицу с 3-мя полями: название фильма, имя актера и количества фильмов, в которых он снимался */
select 
actor_id as Actor,
count (distinct film_id) as TotalFilm
from film_actor
group by actor_id;



 

 		
 		
 	




