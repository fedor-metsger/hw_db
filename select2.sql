
-- Количество исполнителей в каждом жанре

  SELECT g.genre_name, COUNT(gs.genre_id)
    FROM genre AS g, genre_singer AS gs
   WHERE g.genre_id = gs.genre_id
GROUP BY g.genre_id;

-- Количество треков, вошедших в альбомы 2019–2020 годов

  SELECT COUNT(t.track_id)
    FROM album AS a, track AS t
   WHERE a.album_id = t.album_id
	 AND a.release_year BETWEEN 2019 AND 2020;
	 
-- Средняя продолжительность треков по каждому альбому

  SELECT TO_CHAR(ROUND(AVG(playing_time)) / 60, '99') || ':' || TO_CHAR(ROUND(AVG(playing_time)) % 60, '00')
    FROM album AS a, track AS t
   WHERE a.album_id = t.album_id;
   
-- Все исполнители, которые не выпустили альбомы в 2020 году

  SELECT s.name
    FROM singer s
   WHERE s.singer_id NOT IN (
         SELECT sa.singer_id
           FROM album a, singer_album sa
          WHERE a.album_id = sa.album_id
 	        AND a.release_year between 2020 AND 2020
   );
   
   -- Названия сборников, в которых присутствует конкретный исполнитель
   
   SELECT DISTINCT c.title 
     FROM singer s, singer_album sa, track t, collection_track ct, collection c
    WHERE sa.singer_id = s.singer_id
      AND t.album_id = sa.album_id
      AND ct.track_id = t.track_id
      AND c.collection_id = ct.collection_id
      AND s.name = 'Beatles';
    
-- Названия альбомов, в которых присутствуют исполнители более чем одного жанра
      
   SELECT a.title, count(gs.genre_id) 
     FROM singer s, singer_album sa, genre_singer gs, album a
    WHERE s.singer_id = sa.singer_id
      AND gs.singer_id = s.singer_id
      AND sa.album_id = a.album_id 
 GROUP BY a.album_id, a.title
   HAVING count(gs.genre_id) > 1;

-- Наименования треков, которые не входят в сборники
   
         SELECT t.title
           FROM track t
LEFT OUTER JOIN collection_track ct
             ON t.track_id = ct.track_id
          WHERE ct.collection_id IS NULL;

-- Исполнитель или исполнители, написавшие самый короткий по продолжительности трек
          
  SELECT s.name
    FROM track t, singer_album sa, singer s
   WHERE t.album_id = sa.album_id 
     AND sa.album_id = t.album_id
     AND sa.singer_id = s.singer_id
     AND t.playing_time = (SELECT MIN(playing_time) FROM track);

-- Названия альбомов, содержащих наименьшее количество треков
  
  SELECT title FROM (
      SELECT a2.title title, COUNT(t2.track_id) cnt
        FROM album a2, track t2
       WHERE t2.album_id = a2.album_id
    GROUP BY a2.album_id
  ) s1
  WHERE s1.cnt = (
      SELECT COUNT(t.track_id)
        FROM album a, track t
       WHERE t.album_id = a.album_id
    GROUP BY a.album_id
    ORDER BY COUNT(t.track_id)
       LIMIT 1
  )
