"""
Authentication Routes
Handles login, logout, and user session management
"""

from flask import Blueprint, render_template, request, redirect, url_for, session, flash
from models import db, User

bp = Blueprint('auth', __name__, url_prefix='/auth')

@bp.route('/login', methods=['GET', 'POST'])
def login():
    """Login page"""
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        
        # Authenticate user using root connection
        user = User.query.filter_by(username=username).first()
        
        if user and user.password == password:
            # Make session permanent
            session.permanent = True
            
            # Store user info in session
            session['user_id'] = user.user_id
            session['username'] = user.username
            session['role'] = user.role  # Get role from database, not form
            
            flash(f'Welcome back, {user.username}!', 'success')
            
            # Redirect based on user role from database
            if user.role == 'Content_Manager':
                return redirect(url_for('content_manager.index'))
            else:
                return redirect(url_for('dashboard.home'))
        else:
            flash('Invalid username or password', 'error')
    
    return render_template('auth/login.html')

@bp.route('/logout')
def logout():
    """Logout and clear session"""
    session.clear()
    flash('You have been logged out', 'success')
    return redirect(url_for('auth.login'))

@bp.route('/register', methods=['GET', 'POST'])
def register():
    """Registration page (to be implemented)"""
    return render_template('auth/register.html')


# Helper function for other routes
def get_current_user():
    """Get the current logged-in user"""
    if 'user_id' in session:
        return User.query.get(session['user_id'])
    return None

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

def content_manager_required(f):
    """Decorator to require content manager role"""
    from functools import wraps
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session:
            flash('Please login to access this page', 'warning')
            return redirect(url_for('auth.login'))
        if session.get('role') != 'Content_Manager':
            flash('You do not have permission to access this page', 'error')
            return redirect(url_for('dashboard.home'))
        return f(*args, **kwargs)
    return decorated_function
