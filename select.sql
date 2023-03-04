
SELECT title, release_year
FROM album
WHERE release_year = 2018;

SELECT title, playing_time
FROM track
ORDER BY playing_time DESC
LIMIT 1

SELECT title
FROM track
WHERE playing_time >= '00:03:30'

SELECT title
FROM collection
WHERE release_year BETWEEN 2018 AND 2020

SELECT name
FROM singer
WHERE (LENGTH(name) - LENGTH(replace(name, ' ', ''))) = 0

SELECT title
FROM track
WHERE title LIKE '%my%'