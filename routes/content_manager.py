"""
Content Manager Routes
Handles CRUD operations for artists, albums, and songs
"""

from flask import Blueprint, render_template, request, redirect, url_for, session, flash
from models import db, Artist, Album, Song, SongMoods, AlbumMoods
from sqlalchemy import func
from datetime import datetime

bp = Blueprint('content_manager', __name__, url_prefix='/content-manager')

def content_manager_required(f):
    """Decorator to require content manager role"""
    from functools import wraps
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session:
            flash('Please login to access this page', 'warning')
            return redirect(url_for('auth.login'))
        if session.get('role') != 'Content_Manager':
            flash('Access denied. Content Manager role required.', 'error')
            return redirect(url_for('dashboard.home'))
        return f(*args, **kwargs)
    return decorated_function

@bp.route('/')
@content_manager_required
def index():
    """Content manager dashboard"""
    total_artists = Artist.query.count()
    total_albums = Album.query.count()
    total_songs = Song.query.count()
    
    recent_songs = Song.query.order_by(Song.song_id.desc()).limit(10).all()
    recent_artists = Artist.query.order_by(Artist.artist_id.desc()).limit(10).all()
    
    return render_template('content_manager/index.html',
                         total_artists=total_artists,
                         total_albums=total_albums,
                         total_songs=total_songs,
                         recent_songs=recent_songs,
                         recent_artists=recent_artists)

# ============ ARTIST MANAGEMENT ============

@bp.route('/artists')
@content_manager_required
def artists():
    """List all artists"""
    page = int(request.args.get('page', 1))
    per_page = 20
    
    pagination = Artist.query.order_by(Artist.name).paginate(
        page=page, per_page=per_page, error_out=False
    )
    
    return render_template('content_manager/artists.html',
                         artists=pagination.items,
                         pagination=pagination)

@bp.route('/artists/new', methods=['GET', 'POST'])
@content_manager_required
def new_artist():
    """Create a new artist"""
    if request.method == 'POST':
        name = request.form.get('name')
        artist_type = request.form.get('artist_type')
        country = request.form.get('country')
        formation_date = request.form.get('formation_date')
        active_status = request.form.get('active_status') == 'on'
        
        # Get next artist_id
        max_id = db.session.query(func.max(Artist.artist_id)).scalar() or 0
        new_artist = Artist(
            artist_id=max_id + 1,
            name=name,
            artist_type=artist_type,
            country=country,
            formation_date=datetime.strptime(formation_date, '%Y-%m-%d').date(),
            active_status=active_status
        )
        
        try:
            db.session.add(new_artist)
            db.session.commit()
            flash(f'Artist "{name}" created successfully!', 'success')
            return redirect(url_for('content_manager.artists'))
        except Exception as e:
            db.session.rollback()
            flash(f'Error creating artist: {str(e)}', 'error')
    
    return render_template('content_manager/artist_form.html', artist=None)

@bp.route('/artists/<int:artist_id>/edit', methods=['GET', 'POST'])
@content_manager_required
def edit_artist(artist_id):
    """Edit an existing artist"""
    artist = Artist.query.get_or_404(artist_id)
    
    if request.method == 'POST':
        artist.name = request.form.get('name')
        artist.artist_type = request.form.get('artist_type')
        artist.country = request.form.get('country')
        artist.formation_date = datetime.strptime(request.form.get('formation_date'), '%Y-%m-%d').date()
        artist.active_status = request.form.get('active_status') == 'on'
        
        try:
            db.session.commit()
            flash(f'Artist "{artist.name}" updated successfully!', 'success')
            return redirect(url_for('content_manager.artists'))
        except Exception as e:
            db.session.rollback()
            flash(f'Error updating artist: {str(e)}', 'error')
    
    return render_template('content_manager/artist_form.html', artist=artist)

@bp.route('/artists/<int:artist_id>/delete', methods=['POST'])
@content_manager_required
def delete_artist(artist_id):
    """Delete an artist"""
    artist = Artist.query.get_or_404(artist_id)
    
    try:
        db.session.delete(artist)
        db.session.commit()
        flash(f'Artist "{artist.name}" deleted successfully!', 'success')
    except Exception as e:
        db.session.rollback()
        flash(f'Error deleting artist: {str(e)}', 'error')
    
    return redirect(url_for('content_manager.artists'))

# ============ ALBUM MANAGEMENT ============
# Album and song management coming soon - templates not yet created

# @bp.route('/albums')
# @content_manager_required
# def albums():
#     """List all albums"""
#     page = int(request.args.get('page', 1))
#     per_page = 20
#     
#     albums_query = db.session.query(Album, Artist).join(
#         Artist, Album.artist_id == Artist.artist_id
#     ).order_by(Album.title)
#     
#     pagination = albums_query.paginate(page=page, per_page=per_page, error_out=False)
#     
#     return render_template('content_manager/albums.html',
#                          albums=pagination.items,
#                          pagination=pagination)

# @bp.route('/albums/new', methods=['GET', 'POST'])
# @content_manager_required
# def new_album():
#     """Create a new album"""
#     if request.method == 'POST':
#         title = request.form.get('title')
#         album_type = request.form.get('album_type')
#         genre = request.form.get('genre')
#         release_date = request.form.get('release_date')
#         artist_id = request.form.get('artist_id')
#         moods = request.form.getlist('moods')
#         
#         # Get next album_id
#         max_id = db.session.query(func.max(Album.album_id)).scalar() or 0
#         new_album = Album(
#             album_id=max_id + 1,
#             title=title,
#             album_type=album_type,
#             genre=genre,
#             release_date=datetime.strptime(release_date, '%Y-%m-%d').date(),
#             artist_id=int(artist_id)
#         )
#         
#         try:
#             db.session.add(new_album)
#             db.session.flush()  # Get the album_id
#             
#             # Add moods
#             for mood in moods:
#                 album_mood = AlbumMoods(album_id=new_album.album_id, mood=mood)
#                 db.session.add(album_mood)
#             
#             db.session.commit()
#             flash(f'Album "{title}" created successfully!', 'success')
#             return redirect(url_for('content_manager.albums'))
#         except Exception as e:
#             db.session.rollback()
#             flash(f'Error creating album: {str(e)}', 'error')
#     
#     artists = Artist.query.order_by(Artist.name).all()
#     return render_template('content_manager/album_form.html', album=None, artists=artists)

# @bp.route('/albums/<int:album_id>/edit', methods=['GET', 'POST'])
# @content_manager_required
# def edit_album(album_id):
#     """Edit an existing album"""
#     album = Album.query.get_or_404(album_id)
#     
#     if request.method == 'POST':
#         album.title = request.form.get('title')
#         album.album_type = request.form.get('album_type')
#         album.genre = request.form.get('genre')
#         album.release_date = datetime.strptime(request.form.get('release_date'), '%Y-%m-%d').date()
#         album.artist_id = int(request.form.get('artist_id'))
#         
#         # Update moods
#         AlbumMoods.query.filter_by(album_id=album_id).delete()
#         moods = request.form.getlist('moods')
#         for mood in moods:
#             album_mood = AlbumMoods(album_id=album_id, mood=mood)
#             db.session.add(album_mood)
#         
#         try:
#             db.session.commit()
#             flash(f'Album "{album.title}" updated successfully!', 'success')
#             return redirect(url_for('content_manager.albums'))
#         except Exception as e:
#             db.session.rollback()
#             flash(f'Error updating album: {str(e)}', 'error')
#     
#     artists = Artist.query.order_by(Artist.name).all()
#     current_moods = [m.mood for m in AlbumMoods.query.filter_by(album_id=album_id).all()]
#     return render_template('content_manager/album_form.html', 
#                          album=album, 
#                          artists=artists,
#                          current_moods=current_moods)

# @bp.route('/albums/<int:album_id>/delete', methods=['POST'])
# @content_manager_required
# def delete_album(album_id):
#     """Delete an album"""
#     album = Album.query.get_or_404(album_id)
#     
#     try:
#         db.session.delete(album)
#         db.session.commit()
#         flash(f'Album "{album.title}" deleted successfully!', 'success')
#     except Exception as e:
#         db.session.rollback()
#         flash(f'Error deleting album: {str(e)}', 'error')
#     
#     return redirect(url_for('content_manager.albums'))

# ============ SONG MANAGEMENT ============

# @bp.route('/songs')
# @content_manager_required
# def songs():
#     """List all songs"""
#     page = int(request.args.get('page', 1))
#     per_page = 20
#     
#     songs_query = db.session.query(Song, Artist).join(
#         Artist, Song.artist_id == Artist.artist_id
#     ).order_by(Song.title)
#     
#     pagination = songs_query.paginate(page=page, per_page=per_page, error_out=False)
#     
#     return render_template('content_manager/songs.html',
#                          songs=pagination.items,
#                          pagination=pagination)

# @bp.route('/songs/new', methods=['GET', 'POST'])
# @content_manager_required
# def new_song():
#     """Create a new song"""
#     if request.method == 'POST':
#         title = request.form.get('title')
#         duration = request.form.get('duration')  # Format: HH:MM:SS
#         genre = request.form.get('genre')
#         release_date = request.form.get('release_date')
#         lyrics = request.form.get('lyrics')
#         language = request.form.get('language')
#         artist_id = request.form.get('artist_id')
#         album_id = request.form.get('album_id') or None
#         album_track_number = request.form.get('album_track_number') or None
#         moods = request.form.getlist('moods')
#         
#         # Get next song_id
#         max_id = db.session.query(func.max(Song.song_id)).scalar() or 0
#         new_song = Song(
#             song_id=max_id + 1,
#             title=title,
#             duration=datetime.strptime(duration, '%H:%M:%S').time(),
#             genre=genre,
#             release_date=datetime.strptime(release_date, '%Y-%m-%d').date(),
#             lyrics=lyrics,
#             language=language,
#             artist_id=int(artist_id),
#             album_id=int(album_id) if album_id else None,
#             album_track_number=int(album_track_number) if album_track_number else None
#         )
#         
#         try:
#             db.session.add(new_song)
#             db.session.flush()
#             
#             # Add moods
#             for mood in moods:
#                 song_mood = SongMoods(song_id=new_song.song_id, mood=mood)
#                 db.session.add(song_mood)
#             
#             db.session.commit()
#             flash(f'Song "{title}" created successfully!', 'success')
#             return redirect(url_for('content_manager.songs'))
#         except Exception as e:
#             db.session.rollback()
#             flash(f'Error creating song: {str(e)}', 'error')
#     
#     artists = Artist.query.order_by(Artist.name).all()
#     albums = Album.query.order_by(Album.title).all()
#     return render_template('content_manager/song_form.html', 
#                          song=None, 
#                          artists=artists,
#                          albums=albums)

# @bp.route('/songs/<int:song_id>/edit', methods=['GET', 'POST'])
# @content_manager_required
# def edit_song(song_id):
#     """Edit an existing song"""
#     song = Song.query.get_or_404(song_id)
#     
#     if request.method == 'POST':
#         song.title = request.form.get('title')
#         song.duration = datetime.strptime(request.form.get('duration'), '%H:%M:%S').time()
#         song.genre = request.form.get('genre')
#         song.release_date = datetime.strptime(request.form.get('release_date'), '%Y-%m-%d').date()
#         song.lyrics = request.form.get('lyrics')
#         song.language = request.form.get('language')
#         song.artist_id = int(request.form.get('artist_id'))
#         album_id = request.form.get('album_id')
#         song.album_id = int(album_id) if album_id else None
#         album_track_number = request.form.get('album_track_number')
#         song.album_track_number = int(album_track_number) if album_track_number else None
#         
#         # Update moods
#         SongMoods.query.filter_by(song_id=song_id).delete()
#         moods = request.form.getlist('moods')
#         for mood in moods:
#             song_mood = SongMoods(song_id=song_id, mood=mood)
#             db.session.add(song_mood)
#         
#         try:
#             db.session.commit()
#             flash(f'Song "{song.title}" updated successfully!', 'success')
#             return redirect(url_for('content_manager.songs'))
#         except Exception as e:
#             db.session.rollback()
#             flash(f'Error updating song: {str(e)}', 'error')
#     
#     artists = Artist.query.order_by(Artist.name).all()
#     albums = Album.query.order_by(Album.title).all()
#     current_moods = [m.mood for m in SongMoods.query.filter_by(song_id=song_id).all()]
#     return render_template('content_manager/song_form.html',
#                          song=song,
#                          artists=artists,
#                          albums=albums,
#                          current_moods=current_moods)

# @bp.route('/songs/<int:song_id>/delete', methods=['POST'])
# @content_manager_required
# def delete_song(song_id):
#     """Delete a song"""
#     song = Song.query.get_or_404(song_id)
#     
#     try:
#         db.session.delete(song)
#         db.session.commit()
#         flash(f'Song "{song.title}" deleted successfully!', 'success')
#     except Exception as e:
#         db.session.rollback()
#         flash(f'Error deleting song: {str(e)}', 'error')
#     
#     return redirect(url_for('content_manager.songs'))
