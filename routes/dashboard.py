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
    
    # Monthly listening trends
    monthly_stats = db.session.query(
        extract('month', UserListensSong.timestamp_start).label('month'),
        func.count(UserListensSong.song_id).label('play_count')
    ).filter(
        UserListensSong.user_id == user_id,
        extract('year', UserListensSong.timestamp_start) == current_year
    ).group_by('month').all()
    
    # Find top month
    top_month = None
    top_month_count = 0
    if monthly_stats:
        for month, count in monthly_stats:
            if count > top_month_count:
                top_month_count = count
                top_month = month
    
    return render_template('dashboard/home.html',
                         user=user,
                         username=user.username,
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
                         monthly_stats=monthly_stats,
                         top_month=top_month,
                         top_month_count=top_month_count,
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


