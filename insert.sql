
INSERT INTO genre (genre_id, genre_name) VALUES
	(1, 'Rock'), (2, 'Pop'), (3, 'Jazz'), (4, 'Classic'), (5, 'Techno');

INSERT INTO singer (singer_id, "name") VALUES
	(1, 'Beatles'),
	(2, 'Pink Floyd'),
	(3, 'Depeche Mode'),
	(4, 'Lennon John'),
	(5, 'Madonna'),
	(6, 'Malmsteen Yngwie'),
	(7, 'Marillion'),
	(8, 'Judas Priest'),
	(9, 'Sandra');

INSERT INTO genre_singer (genre_id, singer_id) VALUES
	(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8),
	(1, 9), (2, 1), (2, 2), (2, 3), (3, 5), (4, 1), (5, 6), (5, 7), (5, 8);

INSERT INTO album (album_id, title, release_year) VALUES
	(1, 'PLEASE PLEASE ME', 1963), (2, 'WITH THE BEATLES', 1963),
	(3, 'HARD DAYS NIGHT', 1964), (4, 'BEATLES FOR SALE', 1964),
	(5, 'RUBBER SOUL', 1965), (6, 'REVOLVER', 1966),
	(7, 'WHITE ALBUM', 1968), (8, 'YELLOW SUBMARINE', 1969),
	(9, 'ABBEY ROAD', 1969), (10, 'LET IT BE', 1970),
	(11, 'MAGICAL MYSTERY TOUR', 1967), (12, 'SOME GREAT REWARD', 1984),
	(13, 'IMAGINE      /SOUNDTRACK/', 1988), (14, 'WHOS THAT GIRL', 2018),
	(15, 'TRIAL BY FIRE-LIVE IN LEN', 1988), (16, 'B-SIDES THEMSELVES', 2018),
	(17, 'RAM IT DOWN /REMASTER+BON', 1986), (18, 'PIPER AT GATES OF DAWN', 1967),
	(19, 'SAUCERFUL OF SECRETS', 1968), (20, 'MORE /SOUNDTRACK,REMASTER', 1969),
	(21, 'UMMAGUMMA /REMASTER/', 1969), (22, 'INTO A SECRET LAND', 1988);

INSERT INTO singer_album (singer_id, album_id) VALUES
	(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8),
	(1, 9), (1, 10), (1, 11), (3, 12), (4, 13), (5, 14), (6, 15),
	(7, 16), (8, 17), (2, 18), (2, 19), (2, 20), (2, 21), (9, 22);

INSERT INTO track (track_id, album_id, title, playing_time) VALUES
	(1, 1, 'I Saw Her Standing There', '00:02:52'),
	(2, 1, 'Misery	', '00:01:47'), (3, 1, 'Anna (Go to Him)', '00:02:54'),
	(4, 2, 'Chains', '00:02:23'), (5, 3, 'Boys', '00:02:24'),
	(6, 4, 'Ask me why', '00:02:24'), (7, 5, 'Please please me', '00:02:00'),
	(8, 6, 'Love me do', '00:02:19'), (9, 7, 'P.S. I love you', '00:02:02'),
	(10, 8, 'Baby it''s you', '00:02:35'), (11, 9, 'Do you want to know my secret', '00:01:56'),
	(12, 10, 'A taste of honey', '00:02:01'), (13, 11, 'There''s a place', '00:01:49'),
	(14, 12, 'Twist and Shout', '00:02:33'), (15, 13, 'Grendel', '00:17:15'),
	(16, 14, 'Charting the single', '00:04:48'), (17, 15, 'Market Square Herous', '00:03:56'),
	(18, 16, 'Three boats down from the candy', '00:04:01'), (19, 17, 'Cinderella search', '00:04:21'),
	(20, 18, 'Lady Nina', '00:03:43'), (21, 19, 'Freaks', '00:04:02'),
	(22, 20, 'Tux on', '00:05:12'), (23, 21, 'Margaret', '00:12:17'),
	(24, 22, 'Secret land', '00:04:45'), (25, 22, 'Heaven can wait', '00:04:04');

INSERT INTO collection (collection_id, title, release_year) VALUES
	(1, 'Greatest hits 2000', 2000), (2, 'Greatest hits 2001', 2001),
	(3, 'Greatest hits 2002', 2002), (4, 'Greatest hits 2003', 2003),
	(5, 'Greatest hits 2004', 2004), (6, 'Greatest hits 2005', 2005),
	(7, 'Greatest hits 2018', 2018), (8, 'Greatest hits 2019', 2019);

INSERT INTO collection_track (collection_id, track_id) VALUES
	(1, 1), (1, 2), (1, 3), (1, 4), (2, 5), (2, 6),
	(2, 7), (2, 8), (3, 9), (3, 10), (3, 11), (3, 12), (3, 13), (4, 14),
	(4, 15), (4, 16), (4, 17), (4, 18), (4, 19), (4, 20), (5, 21), (5, 22),
	(5, 23), (5, 24), (5, 25), (3, 15), (2, 16), (4, 21), (5, 18), (2, 19);
