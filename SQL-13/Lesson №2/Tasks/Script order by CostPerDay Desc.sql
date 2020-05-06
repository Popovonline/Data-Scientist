select film_id as FilmID,
title as FilmTitle,
description as FilmDescription,
release_year as FilmReleaseYear,
rental_duration/rental_rate as CostPerDay
from Film
order by CostPerDay desc;

select distinct release_year from Film; 

select * from film
where rating = 'PG-13';