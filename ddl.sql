
-- ganre definition

CREATE TABLE ganre (
	ganre_id serial4 NOT NULL,
	ganre_name varchar(20) NOT NULL,
	CONSTRAINT ganre_pk PRIMARY KEY (ganre_id)
);

-- singer definition

CREATE TABLE singer (
	singer_id serial4 NOT NULL,
	"name" varchar(40) NOT NULL,
	CONSTRAINT singer_pk PRIMARY KEY (singer_id)
);

-- ganre_singer definition

CREATE TABLE ganre_singer (
	ganre_id int4 NOT NULL,
	singer_id int4 NOT NULL,
	CONSTRAINT gs_pk PRIMARY KEY (ganre_id, singer_id)
);

-- ganre_singer foreign keys

ALTER TABLE ganre_singer ADD CONSTRAINT gs_ganre_id_fk FOREIGN KEY (ganre_id) REFERENCES ganre(ganre_id);
ALTER TABLE ganre_singer ADD CONSTRAINT gs_singer_id_fk FOREIGN KEY (singer_id) REFERENCES singer(singer_id);

-- album definition

CREATE TABLE album (
	album_id serial4 NOT NULL,
	title varchar(40) NOT NULL,
	release_year int4 NOT NULL,
	CONSTRAINT album_pk PRIMARY KEY (album_id)
);

-- singer_album definition

CREATE TABLE singer_album (
	singer_id int4 NOT NULL,
	album_id int4 NOT NULL,
	CONSTRAINT sa_pk PRIMARY KEY (singer_id, album_id)
);

-- singer_album foreign keys

ALTER TABLE singer_album ADD CONSTRAINT sa_album_id_fk FOREIGN KEY (album_id) REFERENCES album(album_id);
ALTER TABLE singer_album ADD CONSTRAINT sa_singer_id_fk FOREIGN KEY (singer_id) REFERENCES singer(singer_id);

-- track definition

CREATE TABLE track (
	track_id serial4 NOT NULL,
	album_id int4 NOT NULL,
	title varchar(40) NOT NULL,
	playing_time time NULL,
	CONSTRAINT track_pk PRIMARY KEY (track_id)
);

-- track foreign keys

ALTER TABLE track ADD CONSTRAINT track_fk FOREIGN KEY (album_id) REFERENCES album(album_id);

-- collection definition

CREATE TABLE collection (
	collection_id serial4 NOT NULL,
	title varchar(40) NOT NULL,
	release_year int4 NOT NULL,
	CONSTRAINT collection_pk PRIMARY KEY (collection_id)
);

-- public.collection_track definition

CREATE TABLE collection_track (
	collection_id int4 NOT NULL,
	track_id int4 NOT NULL,
	CONSTRAINT ct_pk PRIMARY KEY (collection_id, track_id)
);

-- public.collection_track foreign keys

ALTER TABLE collection_track ADD CONSTRAINT at_collection_id_fk FOREIGN KEY (collection_id) REFERENCES collection(collection_id);
ALTER TABLE collection_track ADD CONSTRAINT at_track_id_fk FOREIGN KEY (track_id) REFERENCES track(track_id);