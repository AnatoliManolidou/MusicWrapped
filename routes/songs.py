"""
Song Routes
Handles song details and related information
"""

from flask import Blueprint, render_template, session, redirect, url_for, flash, request
from models import db, Song, Artist, SongMoods, UserListensSong, UserLikesSong, Album
from sqlalchemy import func, desc
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
    
    # Get user's play count for this song
    user_play_count = UserListensSong.query.filter_by(
        user_id=user_id,
        song_id=song_id
    ).count()
    
    # Get total play count across all users
    total_play_count = UserListensSong.query.filter_by(
        song_id=song_id
    ).count()
    
    # Check if user liked this song
    is_liked = UserLikesSong.query.filter_by(
        user_id=user_id,
        song_id=song_id
    ).first() is not None
    
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
    
    # Get first and last listen dates
    first_listen = db.session.query(
        func.min(UserListensSong.timestamp_start)
    ).filter(
        UserListensSong.user_id == user_id,
        UserListensSong.song_id == song_id
    ).scalar()
    
    last_listen = db.session.query(
        func.max(UserListensSong.timestamp_start)
    ).filter(
        UserListensSong.user_id == user_id,
        UserListensSong.song_id == song_id
    ).scalar()
    
    return render_template('songs/detail.html',
                         song=song_obj,
                         artist=artist_obj,
                         album=album_obj,
                         moods=moods,
                         user_play_count=user_play_count,
                         total_play_count=total_play_count,
                         is_liked=is_liked,
                         user_rank=user_rank if user_rank > 0 else 'N/A',
                         first_listen=first_listen,
                         last_listen=last_listen)

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
