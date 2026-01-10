"""
Dashboard Routes for End Users
Shows wrapped statistics, listening history, and insights
"""

from flask import Blueprint, render_template, session, redirect, url_for, flash, request
from models import db, User, Song, Artist, UserListensSong, UserLikesSong, Playlist, PlaylistMoods, Album
from sqlalchemy import func, desc, extract, text
from datetime import datetime, timedelta

bp = Blueprint('dashboard', __name__, url_prefix='/dashboard')

def login_required(f):
    """Decorator to require login"""
    from functools import wraps
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session:
            flash('Please login to access this page', 'warning')
            return redirect(url_for('auth.login'))
        return f(*args, **kwargs)
    return decorated_function

@bp.route('/')
@login_required
def home():
    """Main dashboard with wrapped statistics"""
    user_id = session.get('user_id')
    
    try:
        user = User.query.get(user_id)
        
        if not user:
            flash('User not found', 'error')
            return redirect(url_for('auth.login'))
    except Exception as e:
        flash(f'Database error: {str(e)}', 'error')
        return redirect(url_for('auth.login'))
    
    # Get current year for "wrapped"
    current_year = 2025
    
    # Total listening time (in minutes)
    total_time_query = db.session.query(
        func.sum(
            func.timestampdiff(
                db.text('MINUTE'),
                UserListensSong.timestamp_start,
                UserListensSong.timestamp_end
            )
        )
    ).filter(
        UserListensSong.user_id == user_id,
        extract('year', UserListensSong.timestamp_start) == current_year
    ).scalar() or 0
    
    # Top 5 songs
    top_songs = db.session.query(
        Song,
        Artist,
        func.count(UserListensSong.song_id).label('play_count')
    ).join(
        UserListensSong, Song.song_id == UserListensSong.song_id
    ).join(
        Artist, Song.artist_id == Artist.artist_id
    ).filter(
        UserListensSong.user_id == user_id,
        extract('year', UserListensSong.timestamp_start) == current_year
    ).group_by(
        Song.song_id
    ).order_by(
        desc('play_count')
    ).limit(5).all()
    
    # Top 5 artists
    top_artists = db.session.query(
        Artist,
        func.count(UserListensSong.song_id).label('play_count')
    ).join(
        Song, Artist.artist_id == Song.artist_id
    ).join(
        UserListensSong, Song.song_id == UserListensSong.song_id
    ).filter(
        UserListensSong.user_id == user_id,
        extract('year', UserListensSong.timestamp_start) == current_year
    ).group_by(
        Artist.artist_id
    ).order_by(
        desc('play_count')
    ).limit(5).all()
    
    # Favorite genre
    favorite_genre = db.session.query(
        Song.genre,
        func.count(UserListensSong.song_id).label('count')
    ).join(
        UserListensSong, Song.song_id == UserListensSong.song_id
    ).filter(
        UserListensSong.user_id == user_id,
        extract('year', UserListensSong.timestamp_start) == current_year
    ).group_by(
        Song.genre
    ).order_by(
        desc('count')
    ).first()
    
    # Total unique songs
    unique_songs = db.session.query(
        func.count(func.distinct(UserListensSong.song_id))
    ).filter(
        UserListensSong.user_id == user_id,
        extract('year', UserListensSong.timestamp_start) == current_year
    ).scalar() or 0
    
    # Total plays (all listening sessions)
    total_plays = db.session.query(
        func.count(UserListensSong.timestamp_start)
    ).filter(
        UserListensSong.user_id == user_id,
        extract('year', UserListensSong.timestamp_start) == current_year
    ).scalar() or 0
    
    # Liked songs count
    liked_count = UserLikesSong.query.filter_by(user_id=user_id).count()
    
    # Top 5 albums
    top_albums = db.session.query(
        Album,
        Artist,
        func.count(UserListensSong.song_id).label('play_count')
    ).join(
        Song, Album.album_id == Song.album_id
    ).join(
        Artist, Song.artist_id == Artist.artist_id
    ).join(
        UserListensSong, Song.song_id == UserListensSong.song_id
    ).filter(
        UserListensSong.user_id == user_id,
        extract('year', UserListensSong.timestamp_start) == current_year
    ).group_by(
        Album.album_id, Artist.artist_id
    ).order_by(
        desc('play_count')
    ).limit(5).all()
    
    # Top mood from listened songs
    from models import SongMoods
    top_mood = db.session.query(
        SongMoods.mood,
        func.count(UserListensSong.song_id).label('count')
    ).join(
        Song, SongMoods.song_id == Song.song_id
    ).join(
        UserListensSong, Song.song_id == UserListensSong.song_id
    ).filter(
        UserListensSong.user_id == user_id,
        extract('year', UserListensSong.timestamp_start) == current_year
    ).group_by(
        SongMoods.mood
    ).order_by(
        desc('count')
    ).first()
    
    # Jam sessions stats
    from models import UserJamsUser
    jam_sessions = db.session.query(
        UserJamsUser,
        User.username
    ).outerjoin(
        User,
        db.or_(
            User.user_id == UserJamsUser.user_id_2,
            User.user_id == UserJamsUser.user_id_1
        )
    ).filter(
        db.or_(
            UserJamsUser.user_id_1 == user_id,
            UserJamsUser.user_id_2 == user_id
        ),
        User.user_id != user_id,
        extract('year', UserJamsUser.timestamp_start) == current_year
    ).all()
    
    # Find longest jam session
    top_jam = None
    top_jam_partner = None
    top_jam_duration = 0
    total_jam_count = len(jam_sessions)
    
    for jam, partner_name in jam_sessions:
        duration = (jam.timestamp_end - jam.timestamp_start).total_seconds() / 60
        if duration > top_jam_duration:
            top_jam_duration = duration
            top_jam_partner = partner_name
            top_jam = jam
    
    return render_template('dashboard/home.html',
                         user=user,
                         total_time=total_time_query,
                         top_songs=top_songs,
                         top_artists=top_artists,
                         top_albums=top_albums,
                         favorite_genre=favorite_genre[0] if favorite_genre else 'N/A',
                         unique_songs=unique_songs,
                         total_plays=total_plays,
                         liked_count=liked_count,
                         top_mood=top_mood[0] if top_mood else 'Mixed',
                         jam_count=total_jam_count,
                         top_jam_partner=top_jam_partner,
                         top_jam_duration=int(top_jam_duration),
                         year=current_year)

@bp.route('/history')
@login_required
def history():
    """Show user's listening history"""
    user_id = session.get('user_id')
    page = int(request.args.get('page', 1))
    per_page = 50
    
    # Get listening history with pagination
    history_query = db.session.query(
        UserListensSong,
        Song,
        Artist
    ).join(
        Song, UserListensSong.song_id == Song.song_id
    ).join(
        Artist, Song.artist_id == Artist.artist_id
    ).filter(
        UserListensSong.user_id == user_id
    ).order_by(
        desc(UserListensSong.timestamp_start)
    )
    
    pagination = history_query.paginate(page=page, per_page=per_page, error_out=False)
    
    return render_template('dashboard/history.html',
                         history=pagination.items,
                         pagination=pagination)

@bp.route('/stats')
@login_required
def stats():
    """Detailed statistics page"""
    user_id = session.get('user_id')
    
    # Get monthly listening trends for the current year
    current_year = 2025
    monthly_stats = db.session.query(
        extract('month', UserListensSong.timestamp_start).label('month'),
        func.count(UserListensSong.song_id).label('play_count')
    ).filter(
        UserListensSong.user_id == user_id,
        extract('year', UserListensSong.timestamp_start) == current_year
    ).group_by('month').all()
    
    # Most listened device
    device_stats = db.session.query(
        UserListensSong.device_type,
        func.count(UserListensSong.song_id).label('count')
    ).filter(
        UserListensSong.user_id == user_id
    ).group_by(
        UserListensSong.device_type
    ).order_by(
        desc('count')
    ).all()
    
    # Jam sessions stats
    from models import UserJamsUser, User
    jam_sessions = db.session.query(
        UserJamsUser,
        User.username
    ).outerjoin(
        User,
        db.or_(
            User.user_id == UserJamsUser.user_id_2,
            User.user_id == UserJamsUser.user_id_1
        )
    ).filter(
        db.or_(
            UserJamsUser.user_id_1 == user_id,
            UserJamsUser.user_id_2 == user_id
        ),
        User.user_id != user_id
    ).all()
    
    # Calculate total jam time
    total_jam_time = 0
    jam_partners = set()
    for jam, partner_name in jam_sessions:
        duration = (jam.timestamp_end - jam.timestamp_start).total_seconds() / 60
        total_jam_time += duration
        if partner_name:
            jam_partners.add(partner_name)
    
    # Number of playlists created by the user
    playlist_count = db.session.query(func.count()).select_from(Playlist).filter_by(user_id=user_id).scalar()

    # Most common mood in user's playlists
    playlist_mood = db.session.query(
        PlaylistMoods.mood,
        func.count(PlaylistMoods.mood).label('count')
    ).join(Playlist, Playlist.playlist_id == PlaylistMoods.playlist_id)
    playlist_mood = playlist_mood.filter(Playlist.user_id == user_id)
    playlist_mood = playlist_mood.group_by(PlaylistMoods.mood).order_by(desc('count')).first()

    # User's favorite album (most songs listened from)
    favorite_album = db.session.query(
        Album.title,
        func.count(UserListensSong.song_id).label('count')
    ).join(Song, Song.album_id == Album.album_id)
    favorite_album = favorite_album.join(UserListensSong, UserListensSong.song_id == Song.song_id)
    favorite_album = favorite_album.filter(UserListensSong.user_id == user_id)
    favorite_album = favorite_album.group_by(Album.album_id).order_by(desc('count')).first()

    # Distribution of user's listening by genre
    genre_dist = db.session.query(
        Song.genre,
        func.count(UserListensSong.song_id).label('count')
    ).join(UserListensSong, UserListensSong.song_id == Song.song_id)
    genre_dist = genre_dist.filter(UserListensSong.user_id == user_id)
    genre_dist = genre_dist.group_by(Song.genre).order_by(desc('count')).all()

    return render_template('dashboard/stats.html',
                         monthly_stats=monthly_stats,
                         device_stats=device_stats,
                         jam_count=len(jam_sessions),
                         total_jam_time=int(total_jam_time),
                         jam_partners=len(jam_partners),
                         year=current_year,
                         playlist_count=playlist_count,
                         playlist_mood=playlist_mood[0] if playlist_mood else None,
                         favorite_album=favorite_album[0] if favorite_album else None,
                         genre_dist=genre_dist)
