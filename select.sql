
  SELECT title, release_year
    FROM album
   WHERE release_year = 2018;

  SELECT title, TO_CHAR(playing_time / 60, '99') || ':' || TO_CHAR(playing_time % 60, '00') AS playing_time
    FROM track
   WHERE playing_time = (SELECT MAX(playing_time) FROM track);
   		  
  SELECT title
    FROM track
   WHERE playing_time >= 210;

  SELECT title
    FROM collection
   WHERE release_year BETWEEN 2018 AND 2020;

  SELECT name
    FROM singer
   WHERE (LENGTH(name) - LENGTH(REPLACE(name, ' ', ''))) = 0;
  
  SELECT title
    FROM track
   WHERE title LIKE '%my%' OR title LIKE '%мой%';