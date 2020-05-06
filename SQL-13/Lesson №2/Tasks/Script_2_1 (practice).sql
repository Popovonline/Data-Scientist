select film_id,
title as FilmTitle,
description as FilmDescription,
release_year as FilmReleaseYear,
rental_duration/rental_rate as CostPerDay
from Film;