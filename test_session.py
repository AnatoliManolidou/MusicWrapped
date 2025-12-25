# Quick test to verify session works
from flask import Flask, session, redirect, url_for
from config import Config

app = Flask(__name__)
app.config.from_object(Config)
app.config['SESSION_COOKIE_SAMESITE'] = 'Lax'
app.config['SESSION_COOKIE_SECURE'] = False

@app.route('/')
def index():
    if 'test' in session:
        return f"Session works! Value: {session['test']}"
    return '<a href="/set">Set session</a>'

@app.route('/set')
def set_session():
    session['test'] = 'Hello World'
    session.permanent = True
    return redirect(url_for('index'))

if __name__ == '__main__':
    print("Testing session...")
    print(f"SECRET_KEY: {app.config['SECRET_KEY'][:20]}...")
    app.run(debug=True, port=5001)
