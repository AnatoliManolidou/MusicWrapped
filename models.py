"""
Database Models for Music Wrapped Application
"""

from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

db = SQLAlchemy()

class User(db.Model):
    __tablename__ = 'user'
    
    user_id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(25), unique=True, nullable=False)
    password = db.Column(db.String(45), nullable=False)
    email = db.Column(db.String(45), nullable=False)
    country = db.Column(db.Enum('Greece', 'Germany', 'Italy', 'France', 'UK', 'Spain'), nullable=False)
    age = db.Column(db.Integer, nullable=False)
    role = db.Column(db.Enum('End_User', 'Content_Manager', 'Data_Analyst', 'Artist', 'Administrator'), nullable=False, default='End_User')
    
    # Relationships
    listens = db.relationship('UserListensSong', backref='user', lazy=True)
    liked_songs = db.relationship('UserLikesSong', backref='user', lazy=True)
    playlists = db.relationship('Playlist', backref='user', lazy=True)
    
    def __repr__(self):
        return f'<User {self.username}>'


class Artist(db.Model):
    __tablename__ = 'artist'
    
    artist_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(25), unique=True, nullable=False)
    artist_type = db.Column(db.Enum('Solo', 'Band'), nullable=False)
    country = db.Column(db.Enum('USA', 'UK', 'Germany', 'Ireland', 'France', 'Canada', 'Greece'), nullable=False)
    formation_date = db.Column(db.Date, nullable=False)
    active_status = db.Column(db.Boolean, nullable=False, default=True)
    
    # Relationships
    songs = db.relationship('Song', backref='artist', lazy=True)
    albums = db.relationship('Album', backref='artist', lazy=True)
    
    def __repr__(self):
        return f'<Artist {self.name}>'


class Album(db.Model):
    __tablename__ = 'album'
    
    album_id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(25), nullable=False)
    album_type = db.Column(db.Enum('Studio', 'Single', 'Live', 'EP', 'Soundtrack'), nullable=False)
    genre = db.Column(db.Enum('Pop', 'Rock', 'Indie', 'Rap', 'Metal'), nullable=False)
    release_date = db.Column(db.Date, nullable=False)
    artist_id = db.Column(db.Integer, db.ForeignKey('artist.artist_id'), nullable=False)
    
    # Relationships
    songs = db.relationship('Song', backref='album', lazy=True)
    moods = db.relationship('AlbumMoods', backref='album', lazy=True)
    
    def __repr__(self):
        return f'<Album {self.title}>'


class Song(db.Model):
    __tablename__ = 'song'
    
    song_id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(25), nullable=False)
    duration = db.Column(db.Time, nullable=False)
    genre = db.Column(db.Enum('Pop', 'Rock', 'Indie', 'Rap', 'Metal'), nullable=False)
    release_date = db.Column(db.Date, nullable=False)
    lyrics = db.Column(db.Text)
    language = db.Column(db.String(25), nullable=False)
    artist_id = db.Column(db.Integer, db.ForeignKey('artist.artist_id'), nullable=False)
    album_id = db.Column(db.Integer, db.ForeignKey('album.album_id'))
    album_track_number = db.Column(db.Integer)
    
    # Relationships
    moods = db.relationship('SongMoods', backref='song', lazy=True)
    listens = db.relationship('UserListensSong', backref='song', lazy=True)
    likes = db.relationship('UserLikesSong', backref='song', lazy=True)
    
    def __repr__(self):
        return f'<Song {self.title}>'
    
    def get_duration_formatted(self):
        """Return duration as MM:SS string"""
        if self.duration:
            return self.duration.strftime('%M:%S')
        return '00:00'


class SongMoods(db.Model):
    __tablename__ = 'song_moods'
    
    song_id = db.Column(db.Integer, db.ForeignKey('song.song_id'), primary_key=True)
    mood = db.Column(db.Enum('Happy', 'Melancholic', 'Energetic', 'Dark', 'Calm', 'Focused', 'Relaxing', 'Dramatic', 'Aggressive', 'Cool'), primary_key=True, nullable=False)


class AlbumMoods(db.Model):
    __tablename__ = 'album_moods'
    
    album_id = db.Column(db.Integer, db.ForeignKey('album.album_id'), primary_key=True)
    mood = db.Column(db.Enum('Happy', 'Melancholic', 'Energetic', 'Dark', 'Calm', 'Focused', 'Relaxing', 'Dramatic', 'Aggressive', 'Cool'), primary_key=True, nullable=False)


class Playlist(db.Model):
    __tablename__ = 'playlist'
    
    playlist_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(25), nullable=False)
    creation_date = db.Column(db.Date, nullable=False)
    is_public = db.Column(db.Boolean, nullable=False, default=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.user_id'), nullable=False)
    
    # Relationships
    songs = db.relationship('PlaylistContainsSong', backref='playlist', lazy=True)
    
    def __repr__(self):
        return f'<Playlist {self.name}>'


class PlaylistContainsSong(db.Model):
    __tablename__ = 'playlist_contains_song'
    
    playlist_id = db.Column(db.Integer, db.ForeignKey('playlist.playlist_id'), primary_key=True)
    song_id = db.Column(db.Integer, db.ForeignKey('song.song_id'), primary_key=True)
    playlist_track_number = db.Column(db.Integer, nullable=False)


class UserListensSong(db.Model):
    __tablename__ = 'user_listens_song'
    
    user_id = db.Column(db.Integer, db.ForeignKey('user.user_id'), primary_key=True)
    song_id = db.Column(db.Integer, db.ForeignKey('song.song_id'), primary_key=True)
    timestamp_start = db.Column(db.DateTime, primary_key=True, nullable=False)
    timestamp_end = db.Column(db.DateTime, nullable=False)
    device_type = db.Column(db.Enum('Mobile', 'Desktop', 'Tablet', 'Smart Speaker', 'Web', 'TV', 'Car', 'Wearable', 'Gaming Console', 'Other'), nullable=False)


class UserLikesSong(db.Model):
    __tablename__ = 'user_likes_song'
    
    user_id = db.Column(db.Integer, db.ForeignKey('user.user_id'), primary_key=True)
    song_id = db.Column(db.Integer, db.ForeignKey('song.song_id'), primary_key=True)
    date_liked = db.Column(db.Date, nullable=False)


class UserFollowsArtist(db.Model):
    __tablename__ = 'user_follows_artist'
    
    user_id = db.Column(db.Integer, db.ForeignKey('user.user_id'), primary_key=True)
    artist_id = db.Column(db.Integer, db.ForeignKey('artist.artist_id'), primary_key=True)
    date_followed = db.Column(db.Date, nullable=False)


class UserFollowsUser(db.Model):
    __tablename__ = 'user_follows_user'
    
    follower_id = db.Column(db.Integer, db.ForeignKey('user.user_id'), primary_key=True)
    followed_id = db.Column(db.Integer, db.ForeignKey('user.user_id'), primary_key=True)
    date_followed = db.Column(db.Date, nullable=False)


class UserJamsUser(db.Model):
    __tablename__ = 'user_jams_user'
    
    user_id_1 = db.Column(db.Integer, db.ForeignKey('user.user_id'), primary_key=True)
    user_id_2 = db.Column(db.Integer, db.ForeignKey('user.user_id'), primary_key=True)
    timestamp_start = db.Column(db.DateTime, primary_key=True, nullable=False)
    timestamp_end = db.Column(db.DateTime, nullable=False)
