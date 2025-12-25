"""
Artist Routes
Handles artist details and statistics
"""

from flask import Blueprint, render_template, session, redirect, url_for, flash, request
from models import db, Artist, Song, Album, UserListensSong, UserFollowsArtist
from sqlalchemy import func, desc, extract
from datetime import datetime

bp = Blueprint('artists', __name__, url_prefix='/artists')

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

@bp.route('/<int:artist_id>')
@login_required
def detail(artist_id):
    """Show detailed information about an artist"""
    user_id = session.get('user_id')
    
    # Get artist
    artist = Artist.query.get(artist_id)
    
    if not artist:
        flash('Artist not found', 'error')
        return redirect(url_for('dashboard.home'))
    
    # Get artist's albums
    albums = Album.query.filter_by(artist_id=artist_id).all()
    
    # Get artist's top songs (by total plays)
    top_songs = db.session.query(
        Song,
        func.count(UserListensSong.song_id).label('play_count')
    ).outerjoin(
        UserListensSong, Song.song_id == UserListensSong.song_id
    ).filter(
        Song.artist_id == artist_id
    ).group_by(
        Song.song_id
    ).order_by(
        desc('play_count')
    ).limit(10).all()
    
    # Get user's play count for this artist
    user_play_count = db.session.query(
        func.count(UserListensSong.song_id)
    ).join(
        Song, UserListensSong.song_id == Song.song_id
    ).filter(
        UserListensSong.user_id == user_id,
        Song.artist_id == artist_id
    ).scalar() or 0
    
    # Check if user follows this artist
    is_following = UserFollowsArtist.query.filter_by(
        user_id=user_id,
        artist_id=artist_id
    ).first() is not None
    
    # Get total listeners (unique users who listened to this artist)
    total_listeners = db.session.query(
        func.count(func.distinct(UserListensSong.user_id))
    ).join(
        Song, UserListensSong.song_id == Song.song_id
    ).filter(
        Song.artist_id == artist_id
    ).scalar() or 0
    
    # Get user's first listen
    first_listen = db.session.query(
        func.min(UserListensSong.timestamp_start)
    ).join(
        Song, UserListensSong.song_id == Song.song_id
    ).filter(
        UserListensSong.user_id == user_id,
        Song.artist_id == artist_id
    ).scalar()
    
    # Total songs by artist
    total_songs = Song.query.filter_by(artist_id=artist_id).count()
    
    return render_template('artists/detail.html',
                         artist=artist,
                         albums=albums,
                         top_songs=top_songs,
                         user_play_count=user_play_count,
                         is_following=is_following,
                         total_listeners=total_listeners,
                         first_listen=first_listen,
                         total_songs=total_songs)

@bp.route('/<int:artist_id>/follow', methods=['POST'])
@login_required
def follow(artist_id):
    """Toggle follow status for an artist"""
    user_id = session.get('user_id')
    
    existing_follow = UserFollowsArtist.query.filter_by(
        user_id=user_id,
        artist_id=artist_id
    ).first()
    
    if existing_follow:
        # Unfollow
        db.session.delete(existing_follow)
        db.session.commit()
        flash('Artist unfollowed', 'info')
    else:
        # Follow
        new_follow = UserFollowsArtist(
            user_id=user_id,
            artist_id=artist_id,
            date_followed=datetime.now().date()
        )
        db.session.add(new_follow)
        db.session.commit()
        flash('Artist followed', 'success')
    
    return redirect(url_for('artists.detail', artist_id=artist_id))

@bp.route('/browse')
@login_required
def browse():
    """Browse all artists"""
    page = int(request.args.get('page', 1))
    per_page = 20
    
    # Get all artists with pagination
    pagination = Artist.query.order_by(Artist.name).paginate(
        page=page, per_page=per_page, error_out=False
    )
    
    return render_template('artists/browse.html',
                         artists=pagination.items,
                         pagination=pagination)
