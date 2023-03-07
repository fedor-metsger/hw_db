
-- genre definition

CREATE TABLE genre (
	genre_id   SERIAL4     PRIMARY KEY,
	genre_name VARCHAR(20) NOT NULL UNIQUE
);

-- singer definition

CREATE TABLE singer (
	singer_id SERIAL4     PRIMARY KEY,
	"name"    VARCHAR(40) NOT NULL UNIQUE
);

-- genre_singer definition

CREATE TABLE genre_singer (
	genre_id   INT4  REFERENCES  genre(genre_id),
	singer_id  INT4  REFERENCES  singer(singer_id),
	CONSTRAINT gs_pk PRIMARY KEY (genre_id, singer_id)
);

-- genre_singer foreign keys
/*
ALTER TABLE genre_singer ADD
     CONSTRAINT gs_genre_id_fk
    FOREIGN KEY genre_id
     REFERENCES genre(genre_id);

ALTER TABLE genre_singer ADD
     CONSTRAINT gs_singer_id_fk
    FOREIGN KEY singer_id
     REFERENCES singer(singer_id);
*/
-- album definition

CREATE TABLE album (
	album_id     SERIAL4     PRIMARY KEY,
	title        VARCHAR(40) NOT NULL,
	release_year INT4        NOT NULL CHECK (release_year > 1900)
);

-- singer_album definition

CREATE TABLE singer_album (
	singer_id  INT4 REFERENCES singer(singer_id),
	album_id   INT4 REFERENCES album(album_id),
	CONSTRAINT sa_pk PRIMARY KEY (singer_id, album_id)
);

-- singer_album foreign keys
/*
ALTER TABLE singer_album ADD CONSTRAINT sa_album_id_fk FOREIGN KEY (album_id) REFERENCES album(album_id);
ALTER TABLE singer_album ADD CONSTRAINT sa_singer_id_fk FOREIGN KEY (singer_id) REFERENCES singer(singer_id);
*/
-- track definition

CREATE TABLE track (
	track_id     SERIAL4     PRIMARY KEY,
	album_id     INT4        REFERENCES album(album_id),
	title        VARCHAR(40) NOT NULL,
	playing_time INT4        NOT NULL
);

-- track foreign keys
/*
ALTER TABLE track ADD CONSTRAINT track_fk FOREIGN KEY (album_id) REFERENCES album(album_id);
*/
-- collection definition

CREATE TABLE collection (
	collection_id SERIAL4     PRIMARY KEY,
	title         VARCHAR(40) NOT NULL,
	release_year  INT4        CHECK (release_year > 1900)
);

-- public.collection_track definition

CREATE TABLE collection_track (
	collection_id    INT4 REFERENCES collection(collection_id),
	track_id         INT4 REFERENCES track(track_id),
	CONSTRAINT ct_pk PRIMARY KEY (collection_id, track_id)
);

-- public.collection_track foreign keys
/*
ALTER TABLE collection_track ADD CONSTRAINT at_collection_id_fk FOREIGN KEY (collection_id) REFERENCES collection(collection_id);
ALTER TABLE collection_track ADD CONSTRAINT at_track_id_fk FOREIGN KEY (track_id) REFERENCES track(track_id);
*/