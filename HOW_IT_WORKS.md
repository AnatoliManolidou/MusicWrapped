# Music Wrapped - How It All Works

## Overview

Your Music Wrapped application is a **Flask web application** that connects to a MySQL database to show users their music listening statistics (like Spotify Wrapped) and allows content managers to manage the music catalog.

---

## Architecture: How Everything Fits Together

```
┌─────────────┐
│   Browser   │ ← User opens http://127.0.0.1:5000
└──────┬──────┘
       │ HTTP Request (GET /dashboard/)
       ↓
┌─────────────────────┐
│   Flask App         │ ← app.py receives the request
│   (app.py)          │
└──────┬──────────────┘
       │ Routes request to correct blueprint
       ↓
┌─────────────────────┐
│   Dashboard Route   │ ← routes/dashboard.py handles it
│   (Blueprint)       │
└──────┬──────────────┘
       │ Queries database using SQLAlchemy
       ↓
┌─────────────────────┐
│   SQLAlchemy ORM    │ ← models.py defines structure
│   (models.py)       │
└──────┬──────────────┘
       │ Executes SQL query
       ↓
┌─────────────────────┐
│   MySQL Database    │ ← Your musicwrappeddatabase
│                     │
└──────┬──────────────┘
       │ Returns data (songs, artists, etc.)
       ↓
┌─────────────────────┐
│   Jinja2 Template   │ ← templates/dashboard/home.html
│   (HTML + Python)   │
└──────┬──────────────┘
       │ Rendered HTML with data
       ↓
┌─────────────┐
│   Browser   │ ← User sees their Wrapped stats!
└─────────────┘
```

---

## 1. Entry Point: app.py

**What it does:** The main "control center" of your application.

```python
app = Flask(__name__)  # Create the Flask application
app.config.from_object(Config)  # Load settings from config.py

# Session configuration (for keeping users logged in)
app.config['SESSION_COOKIE_SAMESITE'] = 'Lax'
app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(hours=24)

# Connect to database
db.init_app(app)

# Register blueprints (route groups)
app.register_blueprint(auth.bp)      # /auth/* routes
app.register_blueprint(dashboard.bp)  # /dashboard/* routes
app.register_blueprint(content_manager.bp)  # /content-manager/* routes
```

**Think of it as:** The main entrance to a building that directs people to different departments.

---

## 2. Configuration: config.py

**What it does:** Stores all settings and credentials.

```python
# Loads from .env file
SECRET_KEY = os.environ.get('SECRET_KEY')  # For encrypting sessions
DB_PASSWORD = os.environ.get('DB_PASSWORD')  # MySQL password

# Builds database connection URL
SQLALCHEMY_DATABASE_URI = f'mysql+pymysql://root:{ENCODED_PASSWORD}@localhost/musicwrappeddatabase'
```

**Why it matters:** 
- Keeps passwords out of code (security!)
- Makes it easy to change settings without editing code
- URL-encodes special characters in password (like `@` becomes `%40`)

---

## 3. Database Models: models.py

**What it does:** Defines the structure of your database tables in Python.

```python
class User(db.Model):
    __tablename__ = 'user'
    
    user_id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(25), unique=True)
    password = db.Column(db.String(45))
    role = db.Column(db.Enum('End_User', 'Content_Manager', ...))
```

**This means:**
- Instead of writing SQL: `SELECT * FROM user WHERE username = 'nikos_89'`
- You write Python: `User.query.filter_by(username='nikos_89').first()`

**Benefits:**
- ✅ No SQL injection attacks
- ✅ Easier to read and write
- ✅ Python checks for errors before running
- ✅ Works with any database (MySQL, PostgreSQL, etc.)

---

## 4. Authentication Flow: routes/auth.py

### When User Logs In:

```python
Step 1: User enters username + password
        ↓
Step 2: Query database: User.query.filter_by(username=username).first()
        ↓
Step 3: Check password: if user and user.password == password
        ↓
Step 4: Create session:
        session['user_id'] = user.user_id
        session['username'] = user.username
        session['role'] = user.role  # ← This is key!
        ↓
Step 5: Redirect based on role:
        if role == 'Content_Manager' → /content-manager/
        else → /dashboard/
```

**The Session:**
- Like a "login token" stored in browser cookies
- Encrypted with SECRET_KEY
- Lasts 24 hours (PERMANENT_SESSION_LIFETIME)
- Checked on every page request

---

## 5. Role-Based Access Control

### How It Works:

```python
# Decorator checks if user is logged in
@login_required
def some_page():
    # Only runs if 'user_id' in session
    
# Decorator checks if user is Content Manager
@content_manager_required
def manage_artists():
    # Only runs if session['role'] == 'Content_Manager'
```

### User Types:

| Role | Can Do |
|------|--------|
| **End_User** | View Wrapped stats, listening history, like songs, follow artists |
| **Content_Manager** | All End_User features + Create/Edit/Delete artists/albums/songs |
| **Data_Analyst** | View all data (not implemented in web app) |

---

## 6. Dashboard: How Wrapped Stats Work

### Example: Top Songs Query

**What you want:** "Show my top 5 most-played songs"

**Python code (routes/dashboard.py):**
```python
top_songs = db.session.query(
    Song, 
    func.count(UserListensSong.song_id).label('play_count')
).join(UserListensSong)\
 .filter(UserListensSong.user_id == user_id)\
 .group_by(Song.song_id)\
 .order_by(desc('play_count'))\
 .limit(5)\
 .all()
```

**What this SQL looks like:**
```sql
SELECT song.*, COUNT(user_listens_song.song_id) as play_count
FROM song
JOIN user_listens_song ON song.song_id = user_listens_song.song_id
WHERE user_listens_song.user_id = 1
GROUP BY song.song_id
ORDER BY play_count DESC
LIMIT 5;
```

**Result:** Top 5 songs with play counts → sent to template → displayed in HTML

---

## 7. Templates: How Data Becomes HTML

### Jinja2 Template Engine

**templates/dashboard/home.html:**
```html
<h2>Your Top Songs</h2>
{% for song, count in top_songs %}
    <div class="song-item">
        <h3>{{ song.title }}</h3>
        <p>Played {{ count }} times</p>
    </div>
{% endfor %}
```

**What happens:**
1. Flask runs the query, gets data
2. Passes data to template: `render_template('dashboard/home.html', top_songs=top_songs)`
3. Jinja2 loops through data and creates HTML
4. Browser receives complete HTML page

---

## 8. Content Manager CRUD

### Example: Editing an Artist

**Step-by-Step Flow:**

```
1. Content Manager clicks "Edit" on Arctic Monkeys
   ↓
2. Browser: GET /content-manager/artists/7/edit
   └─> This RETRIEVES the edit form (read-only operation)
   ↓
3. Flask route: @bp.route('/artists/<int:artist_id>/edit', methods=['GET', 'POST'])
   ↓
4. Query database: artist = Artist.query.get(artist_id)
   ↓
5. Show form with current data (pre-filled)
   ↓
6. Manager changes "active_status" to inactive and clicks "Save"
   ↓
7. Browser: POST /content-manager/artists/7/edit
   └─> This SUBMITS the form data (write operation)
   ↓
8. Flask updates database:
   artist.active_status = form.get('active_status')
   db.session.commit()  # ← Saves to MySQL!
   ↓
9. Redirect back to artists list
   ↓
10. Database now has updated record!
```

**Why GET then POST (not just PUT)?**

- **GET** - "Show me the edit form" (retrieves current data to display)
- **POST** - "Save these changes" (submits the modified data)
- **PUT** - RESTful alternative, but HTML forms only support GET/POST

**In REST APIs you'd use:**
- `GET /artists/7` - View artist
- `PUT /artists/7` - Update artist
- `DELETE /artists/7` - Delete artist

**In web forms (what we use):**
- `GET /artists/7/edit` - Show edit form
- `POST /artists/7/edit` - Save changes
- `POST /artists/7/delete` - Delete artist

---

## 9. Database Connection Details

### How Flask Connects to MySQL:

```python
# config.py builds this URL:
mysql+pymysql://root:!data123bases987%40@localhost/musicwrappeddatabase
     ↑        ↑    ↑                      ↑          ↑
  protocol  driver user:password        host    database
```

**Breaking it down:**
- `mysql+pymysql://` - Use MySQL with PyMySQL driver
- `root:!data123bases987%40` - Username:Password (@ encoded as %40)
- `@localhost` - Database is on same computer
- `/musicwrappeddatabase` - Connect to this database

### Session Management:

```python
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# Creates connection pool (reuses connections)
engine = create_engine(SQLALCHEMY_DATABASE_URI)

# Each request gets a session
session = sessionmaker(bind=engine)()
```

---

## 10. Security Features

### What You Implemented:

1. **Environment Variables (.env)**
   ```
   SECRET_KEY=my-super-secret-key-12345
   DB_PASSWORD=!data123bases987@
   ```
   - Not stored in code
   - Not committed to git (.gitignore)
   - Each developer has their own

2. **SQL Injection Prevention**
   ```python
   # ❌ DANGEROUS (SQL injection risk):
   query = f"SELECT * FROM user WHERE username = '{username}'"
   
   # ✅ SAFE (SQLAlchemy escapes input):
   User.query.filter_by(username=username).first()
   ```

3. **Session Security**
   - Cookies encrypted with SECRET_KEY
   - Can't be tampered with
   - Expire after 24 hours

4. **MySQL User Roles (users.sql)**
   - `End_User@localhost` - Can only SELECT
   - `Content_Manager@localhost` - Can modify artists/albums/songs
   - Database enforces permissions!

---

## 11. The Full Request Cycle

### What happens when you visit `/dashboard/`:

```
1. Browser sends: GET http://127.0.0.1:5000/dashboard/
   ↓
2. Flask (app.py) receives request
   ↓
3. Checks which blueprint handles /dashboard/* → dashboard.bp
   ↓
4. Runs decorator: @login_required
   Checks: Is 'user_id' in session?
   If not → redirect to /auth/login
   ↓
5. Runs route function: def home()
   ↓
6. Gets user_id from session: user_id = session.get('user_id')
   ↓
7. Queries database (4-5 queries):
   - Top songs
   - Top artists
   - Total listening time
   - Top genre
   ↓
8. SQLAlchemy converts Python → SQL → MySQL
   ↓
9. MySQL returns data (rows from tables)
   ↓
10. SQLAlchemy converts rows → Python objects (Song, Artist, etc.)
    ↓
11. Pass to template: render_template('dashboard/home.html', 
                                     top_songs=top_songs, 
                                     top_artists=top_artists, ...)
    ↓
12. Jinja2 template engine:
    - Loads base.html (navigation, header)
    - Inserts dashboard/home.html content
    - Loops through data, creates HTML
    ↓
13. Flask sends complete HTML to browser
    ↓
14. Browser renders page with CSS (static/css/style.css)
    ↓
15. User sees their Wrapped dashboard!
```

---

## 12. Why This Approach?

### Understanding Your SQL Files:

You have multiple SQL files, each with a **different purpose**:

| File | Purpose | When Used |
|------|---------|-----------|
| **dbdump.sql** | Creates database structure + inserts data | **ONCE** - Initial setup |
| **users.sql** | Creates MySQL user accounts with permissions | **ONCE** - Security setup |
| **add_user_roles.sql** | Adds role column to user table | **ONCE** - Schema migration |
| **query1-6.sql** | Example queries for Deliverable 2 | **Documentation only** |

### How They Work Together:

```
Step 1: Setup Database (ONE TIME)
   ↓
   mysql> source dbdump.sql;
   -- Creates all tables, inserts artists/songs/users/etc.
   ↓
   mysql> source users.sql;
   -- Creates End_User@localhost, Content_Manager@localhost, etc.
   ↓
   mysql> source add_user_roles.sql;
   -- Adds role column, updates existing users

Step 2: Run Flask App (EVERY TIME)
   ↓
   python app.py
   -- SQLAlchemy connects to the database created above
   -- Queries data dynamically based on logged-in user
```

### Why SQLAlchemy Instead of dbdump.sql?

**dbdump.sql creates the database, SQLAlchemy uses it!**

**You CANNOT use dbdump.sql for querying because:**
- ❌ It's designed to CREATE tables, not SELECT data
- ❌ It has hardcoded INSERT statements, not dynamic queries
- ❌ It doesn't know which user is logged in
- ❌ It can't take user input from forms

**Example - Why SQLAlchemy is necessary:**

```sql
-- dbdump.sql (static, runs once):
CREATE TABLE artist (...);
INSERT INTO artist VALUES (1, 'Arctic Monkeys', ...);

-- query5.sql (static, for documentation):
SELECT song.title, COUNT(*) as play_count
FROM user_listens_song
WHERE user_id = (SELECT user_id FROM user WHERE username = 'nikos_89')
LIMIT 5;
```

```python
# Flask with SQLAlchemy (dynamic, runs per request):
user_id = session.get('user_id')  # Different for each user!

top_songs = db.session.query(Song, func.count(...))\
    .filter(UserListensSong.user_id == user_id)\  # ← Uses logged-in user
    .limit(5)\
    .all()
```

### SQLAlchemy ORM vs Raw SQL Files:

**The Flask app uses SQLAlchemy because:**

| Feature | Raw SQL Files | SQLAlchemy ORM |
|---------|--------------|----------------|
| **Security** | SQL injection risk | Prevents injection |
| **Dynamic Data** | Hardcoded values (e.g., 'nikos_89') | Uses session variables |
| **Maintainability** | Hard to modify | Easy to change |
| **User Input** | Can't safely handle form data | Validates and escapes |
| **Code Reuse** | Copy-paste SQL | Reusable Python functions |

### What Your Professor Expects (from Lecture 8):

According to the "Databases on the Web" lecture:

✅ **You DID use your SQL files:**
- dbdump.sql created your database schema
- users.sql configured security
- query1-6.sql demonstrate your understanding

✅ **You ALSO used an ORM (SQLAlchemy):**
- Modern best practice for web applications
- Prevents SQL injection attacks
- Makes code maintainable and reusable

**This is the CORRECT approach!** The lecture teaches both:
1. Raw SQL for schema design (Deliverable 1 & 2)
2. ORM for web applications (Deliverable 3)

**Example from your queries:**
```python
# query5.sql shows you UNDERSTAND SQL:
# "Top 5 songs for nikos_89 in 2025"

# Flask shows you can BUILD WEB APPS:
def get_top_songs(user_id, year, limit):
    return db.session.query(...).filter(...).all()
    # Works for ANY user, ANY year!
```

---

## Summary: The Big Picture

**Your Music Wrapped app is a 3-tier web application:**

```
┌─────────────────────────────────┐
│   PRESENTATION LAYER            │
│   - HTML Templates (Jinja2)     │ ← What user sees
│   - CSS Styling (Spotify theme) │
│   - JavaScript (interactions)   │
└────────────┬────────────────────┘
             │
┌────────────▼────────────────────┐
│   APPLICATION LAYER             │
│   - Flask (web framework)       │ ← Business logic
│   - Routes (blueprints)         │
│   - Authentication (sessions)   │
│   - Role-based access control   │
└────────────┬────────────────────┘
             │
┌────────────▼────────────────────┐
│   DATA LAYER                    │
│   - SQLAlchemy (ORM)            │ ← Data management
│   - MySQL Database              │
│   - Models (User, Song, etc.)   │
└─────────────────────────────────┘
```

**When you run `python app.py`:**
1. Flask starts a web server on port 5000
2. Loads configuration from .env
3. Connects to MySQL database
4. Registers all routes (blueprints)
5. Waits for HTTP requests
6. For each request:
   - Checks authentication
   - Runs appropriate route function
   - Queries database if needed
   - Renders template with data
   - Returns HTML to browser

**That's it!** Your application is a working, professional-grade web app that demonstrates database integration, authentication, role-based access control, and CRUD operations - exactly what Deliverable 3 asked for! 🎉
