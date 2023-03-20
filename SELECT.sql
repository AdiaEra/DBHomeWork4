--1 Количество исполнителей в каждом жанре
SELECT g.title_of_genre, COUNT(name_nickname) 
FROM genre g 
JOIN genre_performer gp ON g.id = gp.genre_id 
JOIN performer p ON gp.performer_id = p.id 
GROUP BY title_of_genre;

--2 Количество треков, вошедших в альбомы 2019–2020 годов
SELECT a.title, COUNT(t.id) FROM album a
JOIN track t ON t.album_id = a.id
WHERE year_of_release IN(2019, 2020)
GROUP BY a.title;
--доработано:
SELECT COUNT(t.title) FROM track t
JOIN album a ON t.album_id = a.id
WHERE year_of_release BETWEEN 2019 AND 2020;

--3 Средняя продолжительность треков по каждому альбому
SELECT a.title, AVG(t.duration)
FROM album a JOIN track t
ON a.id = t.album_id
GROUP BY a.title;

--4 Все исполнители, которые не выпустили альбомы в 2020 году
SELECT DISTINCT p.name_nickname FROM performer p 
JOIN album_performer ap ON p.id = ap.performer_id
JOIN album ON ap.album_id = album.id
WHERE year_of_release NOT IN (2020);
--доработано:
SELECT name_nickname
FROM performer
WHERE name_nickname NOT IN (SELECT name_nickname
			    FROM performer p
			    JOIN album_performer ap ON p.id = ap.performer_id 
			    JOIN album a ON ap.album_id = a.id
			    WHERE year_of_release = 2020);
              
--5 Названия сборников, в которых присутствует конкретный исполнитель
SELECT DISTINCT c.title 
FROM  collection c
JOIN track_collection tc ON c.id = tc.collection_id
JOIN track t ON tc.track_id = t.id
JOIN album a ON t.album_id = a.id
JOIN album_performer ap ON a.id = ap.album_id
JOIN performer p ON ap.performer_id = p.id
WHERE name_nickname =  'The Cure';

--6 Названия альбомов, в которых присутствуют исполнители более чем одного жанра
SELECT a.title
FROM album a 
JOIN album_performer ap ON a.id = ap.album_id 
JOIN performer p ON ap.performer_id = p.id 
JOIN genre_performer gp ON p.id = gp.performer_id 
JOIN genre g ON gp.genre_id = g.id 
GROUP BY a.title 
HAVING  COUNT(g.id) > 1;
--доработано:
SELECT DISTINCT a.title
FROM album a 
JOIN album_performer ap ON a.id = ap.album_id
JOIN performer p ON ap.performer_id = p.id 
JOIN genre_performer gp ON p.id = gp.performer_id 
GROUP BY a.title, p.id 
HAVING COUNT(gp.genre_id) > 1;	

--7 Наименования треков, которые не входят в сборники
SELECT title  
FROM track			 
WHERE id NOT IN (SELECT  track_id FROM track_collection);
--доработано:
SELECT t.title FROM track t
LEFT JOIN track_collection tc ON t.id = tc.track_id
WHERE tc.track_id is NULL;

--8 Исполнитель или исполнители, написавшие самый короткий по продолжительности трек, — теоретически таких треков может быть несколько
SELECT name_nickname
FROM performer p
JOIN album_performer ap ON p.id = ap.performer_id
JOIN album a ON ap.album_id = a.id
JOIN track t ON a.id = t.album_id
WHERE duration = (SELECT MIN(duration) FROM track);

--9 Названия альбомов, содержащих наименьшее количество треков
SELECT a.title
FROM album a 
JOIN track t ON a.id = t.album_id
GROUP BY a.title
HAVING COUNT(t.title) = (SELECT COUNT(t.title)
			 FROM track t JOIN album a ON t.album_id = a.id
			 GROUP BY a.title
			 ORDER BY COUNT(t.title)
			 LIMIT 1);
