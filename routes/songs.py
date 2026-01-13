"""
Song Routes
Handles song details and related information
"""

from flask import Blueprint, render_template, session, redirect, url_for, flash, request
from models import db, Song, Artist, SongMoods, UserListensSong, UserLikesSong, Album
from sqlalchemy import func, desc, extract
from datetime import datetime

bp = Blueprint('songs', __name__, url_prefix='/songs')

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

@bp.route('/<int:song_id>')
@login_required
def detail(song_id):
    """Show detailed information about a song"""
    user_id = session.get('user_id')
    
    # Get song with artist and album info
    song = db.session.query(Song, Artist, Album).join(
        Artist, Song.artist_id == Artist.artist_id
    ).outerjoin(
        Album, Song.album_id == Album.album_id
    ).filter(
        Song.song_id == song_id
    ).first()
    
    if not song:
        flash('Song not found', 'error')
        return redirect(url_for('dashboard.home'))
    
    song_obj, artist_obj, album_obj = song
    
    # Get song moods
    moods = db.session.query(SongMoods.mood).filter(
        SongMoods.song_id == song_id
    ).all()
    moods = [m[0] for m in moods]
    mood_str = ', '.join(moods) if moods else 'Unknown'
    
    # Get user's play count for this song
    user_play_count = UserListensSong.query.filter_by(
        user_id=user_id,
        song_id=song_id
    ).count()
    
    # Get total play count across all users
    total_play_count = UserListensSong.query.filter_by(
        song_id=song_id
    ).count()
    
    # Get user's rank for this song (how it ranks in their most played)
    user_rank = db.session.query(
        func.count(func.distinct(UserListensSong.song_id))
    ).filter(
        UserListensSong.user_id == user_id,
        UserListensSong.song_id.in_(
            db.session.query(UserListensSong.song_id).filter(
                UserListensSong.user_id == user_id
            ).group_by(UserListensSong.song_id).having(
                func.count(UserListensSong.song_id) >= user_play_count
            )
        )
    ).scalar() or 0
    
    # Get monthly listening data for 2025
    monthly_stats = db.session.query(
        extract('month', UserListensSong.timestamp_start).label('month'),
        func.count(UserListensSong.song_id).label('play_count')
    ).filter(
        UserListensSong.user_id == user_id,
        UserListensSong.song_id == song_id,
        extract('year', UserListensSong.timestamp_start) == 2025
    ).group_by(
        extract('month', UserListensSong.timestamp_start)
    ).all()
    
    # Calculate top month
    top_month = None
    top_month_count = 0
    max_count = 0
    if monthly_stats:
        for month, count in monthly_stats:
            if count > top_month_count:
                top_month = int(month)
                top_month_count = count
            if count > max_count:
                max_count = count
    
    # Get overall monthly stats for this song (all users)
    overall_monthly_stats = db.session.query(
        extract('month', UserListensSong.timestamp_start).label('month'),
        func.count(UserListensSong.song_id).label('play_count')
    ).filter(
        UserListensSong.song_id == song_id,
        extract('year', UserListensSong.timestamp_start) == 2025
    ).group_by(
        extract('month', UserListensSong.timestamp_start)
    ).all()
    
    # Calculate overall top month
    overall_top_month = None
    overall_top_month_count = 0
    overall_max_count = 0
    if overall_monthly_stats:
        for month, count in overall_monthly_stats:
            if count > overall_top_month_count:
                overall_top_month = int(month)
                overall_top_month_count = count
            if count > overall_max_count:
                overall_max_count = count
    
    return render_template('songs/detail.html',
                         song=song_obj,
                         artist=artist_obj,
                         album=album_obj,
                         mood_str=mood_str,
                         user_play_count=user_play_count,
                         total_play_count=total_play_count,
                         user_rank=user_rank if user_rank > 0 else 'N/A',
                         monthly_stats=monthly_stats,
                         top_month=top_month,
                         top_month_count=top_month_count,
                         max_count=max_count,
                         overall_monthly_stats=overall_monthly_stats,
                         overall_top_month=overall_top_month,
                         overall_top_month_count=overall_top_month_count,
                         overall_max_count=overall_max_count)

@bp.route('/<int:song_id>/like', methods=['POST'])
@login_required
def like(song_id):
    """Toggle like status for a song"""
    user_id = session.get('user_id')
    
    existing_like = UserLikesSong.query.filter_by(
        user_id=user_id,
        song_id=song_id
    ).first()
    
    if existing_like:
        # Unlike
        db.session.delete(existing_like)
        db.session.commit()
        flash('Song removed from liked songs', 'info')
    else:
        # Like
        new_like = UserLikesSong(
            user_id=user_id,
            song_id=song_id,
            date_liked=datetime.now().date()
        )
        db.session.add(new_like)
        db.session.commit()
        flash('Song added to liked songs', 'success')
    
    return redirect(url_for('songs.detail', song_id=song_id))

@bp.route('/search')
@login_required
def search():
    """Search for songs"""
    query = request.args.get('q', '')
    
    if query:
        results = db.session.query(Song, Artist).join(
            Artist, Song.artist_id == Artist.artist_id
        ).filter(
            Song.title.like(f'%{query}%')
        ).limit(50).all()
    else:
        results = []
    
    return render_template('songs/search.html', results=results, query=query)
