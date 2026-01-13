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
    
    # Get user's top 3 albums from this artist
    user_top_albums = db.session.query(
        Album,
        func.count(UserListensSong.song_id).label('play_count')
    ).join(
        Song, Album.album_id == Song.album_id
    ).join(
        UserListensSong, Song.song_id == UserListensSong.song_id
    ).filter(
        Song.artist_id == artist_id,
        UserListensSong.user_id == user_id
    ).group_by(
        Album.album_id
    ).order_by(
        desc('play_count')
    ).limit(3).all()
    
    # Get overall top 3 albums from this artist (all users)
    overall_top_albums = db.session.query(
        Album,
        func.count(UserListensSong.song_id).label('play_count')
    ).join(
        Song, Album.album_id == Song.album_id
    ).outerjoin(
        UserListensSong, Song.song_id == UserListensSong.song_id
    ).filter(
        Song.artist_id == artist_id
    ).group_by(
        Album.album_id
    ).order_by(
        desc('play_count')
    ).limit(3).all()
    
    # Get user's top 3 songs from this artist
    user_top_songs = db.session.query(
        Song,
        func.count(UserListensSong.song_id).label('play_count')
    ).join(
        UserListensSong, Song.song_id == UserListensSong.song_id
    ).filter(
        Song.artist_id == artist_id,
        UserListensSong.user_id == user_id
    ).group_by(
        Song.song_id
    ).order_by(
        desc('play_count')
    ).limit(3).all()
    
    # Get overall top 3 songs from this artist (all users)
    overall_top_songs = db.session.query(
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
    ).limit(3).all()
    
    # Get user's play count for this artist
    user_play_count = db.session.query(
        func.count(UserListensSong.song_id)
    ).join(
        Song, UserListensSong.song_id == Song.song_id
    ).filter(
        UserListensSong.user_id == user_id,
        Song.artist_id == artist_id
    ).scalar() or 0
    
    # Get user's rank for this artist (how it ranks in their most played artists)
    artist_rank = db.session.query(
        func.count(func.distinct(Song.artist_id))
    ).select_from(Song).join(
        UserListensSong, Song.song_id == UserListensSong.song_id
    ).filter(
        UserListensSong.user_id == user_id,
        Song.artist_id.in_(
            db.session.query(Song.artist_id).join(
                UserListensSong, Song.song_id == UserListensSong.song_id
            ).filter(
                UserListensSong.user_id == user_id
            ).group_by(Song.artist_id).having(
                func.count(UserListensSong.song_id) >= user_play_count
            )
        )
    ).scalar() or 0
    
    # Get user's albums listened count for this artist
    user_albums_count = db.session.query(
        func.count(func.distinct(Song.album_id))
    ).join(
        UserListensSong, Song.song_id == UserListensSong.song_id
    ).filter(
        UserListensSong.user_id == user_id,
        Song.artist_id == artist_id,
        Song.album_id.isnot(None)
    ).scalar() or 0
    
    # Get monthly listening data for 2025
    monthly_stats = db.session.query(
        extract('month', UserListensSong.timestamp_start).label('month'),
        func.count(UserListensSong.song_id).label('play_count')
    ).join(
        Song, UserListensSong.song_id == Song.song_id
    ).filter(
        UserListensSong.user_id == user_id,
        Song.artist_id == artist_id,
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
    
    # Get overall monthly listening data for 2025 (all users)
    overall_monthly_stats = db.session.query(
        extract('month', UserListensSong.timestamp_start).label('month'),
        func.count(UserListensSong.song_id).label('play_count')
    ).join(
        Song, UserListensSong.song_id == Song.song_id
    ).filter(
        Song.artist_id == artist_id,
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
    
    # Total songs by artist
    total_songs = Song.query.filter_by(artist_id=artist_id).count()
    
    return render_template('artists/detail.html',
                         artist=artist,
                         user_top_songs=user_top_songs,
                         user_top_albums=user_top_albums,
                         overall_top_songs=overall_top_songs,
                         overall_top_albums=overall_top_albums,
                         user_play_count=user_play_count,
                         user_albums_count=user_albums_count,
                         artist_rank=artist_rank if artist_rank > 0 else 'N/A',
                         monthly_stats=monthly_stats,
                         top_month=top_month,
                         top_month_count=top_month_count,
                         max_count=max_count,
                         overall_monthly_stats=overall_monthly_stats,
                         overall_top_month=overall_top_month,
                         overall_top_month_count=overall_top_month_count,
                         overall_max_count=overall_max_count,
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
