CREATE TABLE Genre
(
	id serial PRIMARY KEY,
	title_of_genre varchar(40) NOT NULL
);

CREATE TABLE Performer
(
	id serial PRIMARY KEY,
	name_nickname varchar(40) NOT NULL
);

CREATE TABLE Album
(
	id serial PRIMARY KEY,
	title varchar(80) NOT NULL,
	year_of_release int 
		CONSTRAINT CHK_album_year_of_release 
		CHECK (year_of_release > 1980) NOT NULL
);

CREATE TABLE Track
(
	id serial PRIMARY KEY,
	title varchar(80) NOT NULL,
	duration int CHECK (duration BETWEEN 30 AND 900) NOT NULL,
	album_id int REFERENCES Album(id)
);

CREATE TABLE Genre_performer
(
	genre_id int REFERENCES Genre(id),
	performer_id int REFERENCES Performer(id),
	CONSTRAINT GenrePerformer_pkey PRIMARY KEY (genre_id, performer_id)
);

CREATE TABLE Album_performer
(
	album_id int REFERENCES Album(id),
	performer_id int REFERENCES Performer(id),
	CONSTRAINT AlbumPerformer_pkey PRIMARY KEY (album_id, performer_id)
);

CREATE TABLE Collection
(
	id serial PRIMARY KEY,
	title varchar(80) NOT NULL,
	year_of_release int 
		CONSTRAINT CHK_collection_year_of_release 
		CHECK (year_of_release > 1980) NOT NULL
);

CREATE TABLE Track_collection
(
	track_id int REFERENCES Track(id),
	collection_id int REFERENCES Collection(id),
	CONSTRAINT TrackCollection_pkey PRIMARY KEY (track_id, collection_id)
)
