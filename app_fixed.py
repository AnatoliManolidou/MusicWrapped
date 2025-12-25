"""
Music Wrapped - Main Application File
Flask web application for Music Wrapped Database
"""

from flask import Flask, redirect, url_for, session
from config import Config
from datetime import timedelta

# Initialize Flask app
app = Flask(__name__)
app.config.from_object(Config)

# Session configuration
app.config['SESSION_COOKIE_SAMESITE'] = 'Lax'
app.config['SESSION_COOKIE_SECURE'] = False
app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(hours=24)

# Initialize database
from models import db
db.init_app(app)

# Import and register blueprints
from routes import auth, dashboard, content_manager, songs, artists

app.register_blueprint(auth.bp)
app.register_blueprint(dashboard.bp)
app.register_blueprint(content_manager.bp)
app.register_blueprint(songs.bp)
app.register_blueprint(artists.bp)

# Home route
@app.route('/')
def index():
    """Redirect to login or dashboard based on auth status"""
    if 'user_id' in session:
        return redirect(url_for('dashboard.home'))
    return redirect(url_for('auth.login'))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
