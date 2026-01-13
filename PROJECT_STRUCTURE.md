# Music Wrapped - Complete Project Structure & Documentation

## Table of Contents
1. [Project Overview](#project-overview)
2. [Database Foundation](#database-foundation)
3. [Web Application Development](#web-application-development)
4. [File Structure](#file-structure)
5. [Architecture & Design Patterns](#architecture--design-patterns)
6. [Key Features](#key-features)
7. [Database Schema](#database-schema)
8. [Design Philosophy](#design-philosophy)

---

## Project Overview

**Music Wrapped** is a retro 90's DOS/terminal-styled web application that transforms a music listening database into an interactive "Wrapped" experience, similar to Spotify Wrapped.

**Technology Stack:**
- **Backend:** Flask 3.0.0 (Python web framework)
- **Database:** MySQL 8.0 with SQLAlchemy ORM
- **Frontend:** HTML5, CSS3, JavaScript (Vanilla)
- **Design:** DOS/Terminal aesthetic with VT323 font

---

## Database Foundation

### Database Schema (14 Tables)
The MySQL database consists of 14 interconnected tables:

1. **user** - User accounts with roles (End_User, Content_Manager, Data_Analyst, Artist, Administrator)
2. **artist** - Musicians/bands with countries and formation dates
3. **album** - Albums with genres and types (Studio, Single, Live, EP, Soundtrack)
4. **song** - Individual tracks with lyrics, duration, genre, language
5. **song_moods** - Song-to-mood relationships (10 moods)
6. **album_moods** - Album-to-mood relationships
7. **playlist** - User-created playlists
8. **playlist_moods** - Playlist-to-mood relationships
9. **playlist_contains_song** - Songs within playlists
10. **user_listens_song** - Complete listening history with timestamps
11. **user_likes_song** - Liked songs by users
12. **user_follows_artist** - Artist follows
13. **user_follows_user** - User-to-user follows
14. **user_jams_user** - Jam sessions (simultaneous listening)

### Data Population
**Initial Foundation:**
- **8 core artists:** Lady Gaga, Queen, Billie Eilish, Fontaines D.C., Eminem, Metallica, Arctic Monkeys, The Weeknd
- **8 core albums** covering all 5 genres (Pop, Rock, Indie, Rap, Metal)
- **Original users** and listening history structure
- **6 analytical SQL queries** in `database/query1.sql` through `query6.sql`

**Expanded During Development:**
- **Added 6 artists:** Depeche Mode, Sade, Interpol, Radiohead, Massive Attack, Tame Impala
- **Added 6 albums:** Violator, Diamond Life, Turn On the Bright Lights, OK Computer, Mezzanine, Deadbeat
- **Added 11 songs** from new artists (total 21 songs)
- **Expanded to 10 users** across 5 roles and 7 countries
- **120+ listening sessions** spanning 2025 for comprehensive wrapped statistics

**Final Dataset:**
- **14 artists** from 8 countries (USA, UK, Ireland, Canada, Australia)
- **14 albums** with complete metadata and mood tags
- **21 songs** with full lyrics, moods, and duration
- **10 moods:** Happy, Melancholic, Energetic, Dark, Calm, Focused, Relaxing, Dramatic, Aggressive, Cool
- **5 genres:** Pop, Rock, Indie, Rap, Metal

### Database Enums & Constraints
- **Countries:** Greece, Germany, Italy, France, UK, Spain, Australia (users) + USA, Canada, Ireland, Australia (artists)
- **Genres:** Pop, Rock, Indie, Rap, Metal
- **Album Types:** Studio, Single, Live, EP, Soundtrack
- **Device Types:** Mobile, Desktop, Tablet, Smart TV, Web Player,
- **Artist Types:** Solo, Band
- **User Roles:** End_User, Content_Manager (Data_Analyst, Artist, Administrator for feature update)

---

## Web Application Development

### Backend Architecture

#### 1. Flask Application (`app.py`)
- Modular blueprint registration
- Database connection with connection pooling
- Environment-based configuration
- Session management with secret keys
- Error handling and flash messages

#### 2. Configuration Management (`config.py`)
- Environment variable loading with `python-dotenv`
- Secure database credential management
- `.env` file support for local development
- SQLAlchemy URI construction

#### 3. ORM Models (`models.py`)
- 14 SQLAlchemy model classes mapping to database tables
- Relationships with backref navigation
- Enum validation
- Custom methods (e.g., `get_duration_formatted()`)

#### 4. Route Blueprints (5 modules)

**a) `routes/auth.py`**
- Login/logout functionality
- Role-based authentication
- Session management
- Password validation (plaintext for demo)
- Redirect logic based on user role

**b) `routes/dashboard.py` **
- **Home route:** Wrapped 2025 statistics
  - Total listening time (TIMESTAMPDIFF calculation)
  - Top 5 songs, artists, albums (GROUP BY + COUNT)
  - Monthly listening distribution (EXTRACT month)
  - Mood analysis (JOIN with song_moods)
  - Genre distribution by play count
  - Jam session analysis (partner detection, count)
  - Interactive terminal with 8 query commands
  - Boot sequence animation
  - Scroll-triggered terminal reveal
  
- **History route:** Paginated listening history
  - Song-artist-album JOIN queries
  - Date-based filtering
  - Pagination (20 items per page)
  - Device type display

- **Stats route:** Detailed analytics
  - Genre breakdown charts
  - Device usage statistics
  - Listening patterns

**c) `routes/content_manager.py` **
- Dashboard with counts (artists, albums, songs)
- **Artist CRUD:**
  - Create artist form
  - Edit artist (update)
  - Delete artist (cascade handling)
  - List all artists

**d) `routes/artists.py` **
- Artist detail page with:
  - Artist metadata (type, country, formation date)
  - Top songs by this artist
  - Album discography
  - User's listen count for this artist
  - Monthly listening charts (user + overall)

**e) `routes/songs.py` **
- Song detail page with:
  - Song metadata (duration, genre, language)
  - Full lyrics display
  - Mood tags
  - Artist and album information
  - User's play count vs global play count
  - User's rank for this song
  - Monthly listening charts (user + overall)

### Frontend Layer

#### Templates (Jinja2 - 11 HTML files)

**`templates/base.html`** 
- DOS-style navigation header with box-drawing characters (╔═══╗)
- Role-based menu items (Home/History for End_User, Dashboard/Artists/Albums/Songs for Content_Manager)
- User display with username
- Flash message system
- Footer with VT323 font
- Included CSS: `style.css`, `interactive-terminal.css`
- Hidden on boot/hero, revealed on scroll (updated for terminal experience)

**`templates/auth/login.html`** 
- Terminal-style login form
- Dropdown for user type selection
- Example credentials display
- Error message handling
- DOS aesthetic with green text

**`templates/dashboard/home.html`** 
- **Boot Sequence:** Full-screen black background with left-aligned boot text
  - 7 animated lines with staggered delays (0s → 4.5s)
  - Fixed position overlay (z-index: 9999)
  - 5.5s timeout before transition
  
- **Hero Section:** Centered display after boot
  - "> LOADING_USER_DATA.exe" prompt
  - "THIS IS WHAT YOUR SOUND LOOKED LIKE IN 2025" title
  - Total minutes display
  - Scroll arrow with bounce animation
  - No navbar visible yet
  
- **Interactive Terminal:** Revealed on scroll (100px threshold)
  - Terminal header with box-drawing characters (═══)
  - Command history (scrollable, overflow-x hidden)
  - Command input with prompt: `SYS://username@MUSIC_WRAPPED >`
  - 8 query commands with custom loading animations
  - Help command (42 chars wide, box-drawing borders)
  - Clear command
  
- **JavaScript Functionality:**
  - Data globals: topArtistsData, topSongsData, topAlbumsData, monthlyData, totalMinutes
  - Command system with Map-based routing
  - executeQueryToHistory(index) for query execution
  - Processing animations (3 steps × 800ms + 500ms = ~2.9s)
  - Result rendering with index-based conditional logic
  - Navbar reveal on scroll
  
- **Query Results:**
  - **Index 0 (total_plays):** Box with === borders, plays/minutes with inline progress bars
  - **Index 1 (top_artists):** Table format with diversity index bar
  - **Index 2 (top_songs):** Table format with diversity index bar
  - **Index 3 (top_albums):** Table format with diversity index bar
  - **Index 4 (jam_sessions):** Centered text with >>> SOLO MODE <<< or partner name
  - **Index 5 (mood_analysis):** Centered "This year you chose to be >>> MOOD <<<"
  - **Index 6 (top_genre):** Centered "This year you chose your sound to be >>> GENRE <<<"
  - **Index 7 (monthly_chart):** Bar chart with trend indicators (↑↓), consistency % with bar, longest streak

**`templates/dashboard/history.html`** 
- Paginated listening history table
- Song-artist-album display
- Device type icons
- Pagination controls
- DOS table styling

**`templates/dashboard/stats.html`** 
- Detailed statistics dashboard
- Genre distribution charts
- Device usage breakdown
- Listening patterns visualization

**`templates/artists/detail.html`**
- Artist profile header
- Top songs section
- Album discography
- User statistics
- Follow/unfollow button
- Monthly listening charts 

**`templates/songs/detail.html`** 
- Song metadata display
- Full lyrics section
- Mood tags
- Artist/album links
- Play count comparison (user vs global)
- Like/unlike button
- Monthly listening charts 

**`templates/content_manager/index.html`** 
- Dashboard with entity counts
- Quick links to management pages
- Terminal-style cards

**`templates/content_manager/artists.html`** 
- Artist list table
- Edit/Delete actions
- Add new artist button
- DOS table styling

**`templates/content_manager/artist_form.html`** 
- Form for creating/editing artists
- Dropdown for artist type (Solo/Band)
- Country selection
- Formation date picker
- Active status checkbox
- Validation messages

### Static Assets

#### CSS Files

**`static/css/style.css`** (2613 lines)
- **Global Variables:**
  - Primary color: #A8CC8C (sage green)
  - Background: #0a0a0a (nearly black)
  - Card background: #111
  - Text color: #e0e0e0
  
- **Typography:**
  - Headings: VT323 monospace
  - Body: Courier Prime monospace
  - Sizes: 16px base, 20-36px headings
  
- **Navigation (lines 125-250):**
  - .navbar with DOS header box-drawing
  - .dos-header-line with ╔═══╗ borders
  - Role-based menu items
  - User display and logout button
  
- **Dashboard Components:**
  - .dashboard-container (max-width: 1400px, increased from 1000px)
  - .wrapped-hero (min-height: 100vh, flexbox centered)
  - .terminal-cursor-line (flex column with arrow and text)
  - .scroll-arrow (2.5rem, slowBounce animation)
  
- **Result Display Styles:**
  - .result-box: Box-drawing character containers
  - .result-table: Table format for rankings
  - .result-chart: Bar chart display
  - .result-centered: Centered text for mood/genre/jam
  - .chart-stats: Consistency and streak metrics
  
- **Animations:**
  - fadeIn, fadeInUp, fadeInLine (opacity transitions)
  - slowBounce (scroll arrow)
  - typeIn (typewriter effect)
  - blink (cursor)
  - dots (loading ellipsis)
  - fadeInStep (processing steps)
  
- **Responsive Design:**
  - Mobile breakpoints at 768px
  - Tablet adjustments
  - Font scaling

**`static/css/interactive-terminal.css`**
- Terminal-specific styles
- Command history scrolling
- Processing animations
- Progress bar styles
- Help command box-drawing
- Input styling
- Overflow management

#### JavaScript

**`static/js/main.js`** 
- Alert auto-dismiss (3 seconds)
- Form validation helpers
- Modal controls
- Delete confirmation dialogs

### Database Integration

#### Query Patterns Used

**1. Aggregation Queries:**
```sql
-- Total listening time
SELECT SUM(TIMESTAMPDIFF(MINUTE, timestamp_start, timestamp_end))
FROM user_listens_song
WHERE user_id = ? AND YEAR(timestamp_start) = 2025

-- Top 5 artists
SELECT a.name, COUNT(*) as play_count
FROM user_listens_song uls
JOIN song s ON uls.song_id = s.song_id
JOIN artist a ON s.artist_id = a.artist_id
WHERE uls.user_id = ?
GROUP BY a.artist_id
ORDER BY play_count DESC
LIMIT 5
```

**2. JOIN Queries:**
```sql
-- Song details with artist and album
SELECT s.*, a.name, al.title
FROM song s
JOIN artist a ON s.artist_id = a.artist_id
LEFT JOIN album al ON s.album_id = al.album_id
WHERE s.song_id = ?
```

**3. Temporal Queries:**
```sql
-- Monthly listening distribution
SELECT EXTRACT(MONTH FROM timestamp_start) as month,
       COUNT(*) as play_count
FROM user_listens_song
WHERE user_id = ? AND YEAR(timestamp_start) = 2025
GROUP BY EXTRACT(MONTH FROM timestamp_start)
```

**4. Mood Analysis:**
```sql
-- User's dominant mood
SELECT sm.mood, COUNT(*) as mood_count
FROM user_listens_song uls
JOIN song s ON uls.song_id = s.song_id
JOIN song_moods sm ON s.song_id = sm.song_id
WHERE uls.user_id = ?
GROUP BY sm.mood
ORDER BY mood_count DESC
LIMIT 1
```

**5. Jam Session Detection:**
```sql
-- Find jam partners
SELECT ujm.user_id_2, u.username,
       COUNT(*) as jam_count,
       SUM(TIMESTAMPDIFF(MINUTE, ujm.timestamp_start, ujm.timestamp_end)) as total_minutes
FROM user_jams_user ujm
JOIN user u ON ujm.user_id_2 = u.user_id
WHERE ujm.user_id_1 = ?
GROUP BY ujm.user_id_2
ORDER BY jam_count DESC
```

---

## File Structure

```
MusicWrapped/
│
├── .env                          # Environment variables (DB credentials) - NOT in git
├── .env.example                  # Example .env file template
├── .gitignore                    # Git exclusions (includes .env, __pycache__, .venv)
│
├── app.py                        # Main Flask application (blueprint registration)
├── config.py                     # Configuration management (DB URI, secret key)
├── models.py                     # SQLAlchemy ORM models (14 classes)
├── requirements.txt              # Python dependencies
├── setup.ps1                     # PowerShell setup script
│
├── database/                     # SQL files and database documentation
│   ├── dbdump.sql               # Full database dump (original baseline)
│   ├── users.sql                # User password hashes
│   ├── add_user_roles.sql       # Adds role column to user table
│   ├── database_additions.sql   # Post-deliverable additions (6 artists, 6 albums, 11 songs, user 10)
│   ├── query1.sql               # Original query 1 (listening history)
│   ├── query2.sql               # Original query 2 (artist songs with moods)
│   ├── query3.sql               # Original query 3 (users without playlists)
│   ├── query4.sql               # Original query 4 (songs by genre)
│   ├── query5.sql               # Original query 5 (user's top artists)
│   ├── query6.sql               # Original query 6 (jam sessions)
│   └── README.md                # Database documentation
│
├── routes/                       # Flask blueprints (controllers)
│   ├── auth.py                  # Authentication (login/logout)
│   ├── dashboard.py             # User dashboard (wrapped, history, stats)
│   ├── content_manager.py       # Content management (CRUD)
│   ├── artists.py               # Artist detail pages
│   └── songs.py                 # Song detail pages
│
├── templates/                    # Jinja2 HTML templates
│   ├── base.html                # Base layout with navigation
│   ├── auth/
│   │   └── login.html           # Login page
│   ├── dashboard/
│   │   ├── home.html            # Wrapped 2025 with interactive terminal
│   │   ├── history.html         # Listening history
│   │   └── stats.html           # Detailed statistics
│   ├── artists/
│   │   └── detail.html          # Artist profile
│   ├── songs/
│   │   └── detail.html          # Song detail
│   └── content_manager/
│       ├── index.html           # CM dashboard
│       ├── artists.html         # Artist list
│       └── artist_form.html     # Add/edit artist form
│
├── static/                       # Static assets
│   ├── css/
│   │   ├── style.css            # Main stylesheet (2613 lines)
│   │   └── interactive-terminal.css  # Terminal styles (593 lines)
│   └── js/
│       └── main.js              # JavaScript utilities
│
├── README.md                     # Main project documentation
├── QUICKSTART.md                 # Quick setup guide
├── DATA_ADDITIONS.md             # Artists, albums, songs added during development
├── PROJECT_STRUCTURE.md          # This file - comprehensive structure guide
└── user_credentials.md           # Test user credentials
```

---

## Architecture & Design Patterns

### 1. MVC Pattern (Model-View-Controller)
- **Model:** SQLAlchemy ORM (`models.py`) - Database entities and relationships
- **View:** Jinja2 templates (`templates/`) - HTML presentation layer
- **Controller:** Flask blueprints (`routes/`) - Business logic and routing

### 2. Blueprint Architecture
- Modular route organization
- Namespace separation (auth, dashboard, content_manager, artists, songs)
- Easy to extend with new features
- Clear separation of concerns

### 3. Repository Pattern
- Database queries encapsulated in route functions
- SQLAlchemy ORM abstracts SQL
- Reusable query patterns

### 4. Decorator Pattern
- `@login_required` decorator for authentication
- `@bp.route()` for URL routing
- Consistent authorization checks

### 5. Template Inheritance
- `base.html` provides common structure
- Child templates extend base
- Block system for content injection
- DRY principle

### 6. Configuration Management
- Environment-based configuration
- `.env` file for secrets
- Centralized config in `config.py`
- Security best practices (credentials not in code)

---

## Key Features

### Wrapped 2025 Statistics
- **Total Playback:** Plays and minutes with inline progress bars
  - **Percentile Ranking:** Shows user's rank compared to all users
  - Progress bars represent percentile position (not absolute values)
  - Dynamic messages based on ranking (top 10%, top 25%, etc.)
- **Top Rankings:** Artists, songs, albums with diversity index
- **Jam Sessions:** Solo mode or partner detection
- **Mood Analysis:** Dominant emotional profile
- **Genre Identity:** Primary genre with description
- **Monthly Chart:** Bar graph with trend indicators (↑↓), consistency %, longest streak

### 2. Percentile Ranking Calculation
- Compares user's activity against all users in the database
- **Plays Percentile:** (users with fewer plays / total users) × 100
- **Minutes Percentile:** (users with fewer minutes / total users) × 100
- **Average Percentile:** (plays_percentile + minutes_percentile) / 2
- **Dynamic Messages:**
  - ≥90%: "You were in the top X% of most active users!"
  - ≥75%: "You were in the top X% of listeners — impressive!"
  - ≥50%: "You kept the music spinning all year long."
  - ≥25%: "A solid year of listening."
  - <25%: "Music was part of your year."
- Progress bars in `total_plays` output show percentile, not absolute values

### 3. Diversity Index Calculation
- Measures evenness of play distribution
- Formula: `1 - (stdDev / mean)`
- **Edge case:** Returns 0% when only 1 item (no diversity possible)
- Higher score = more balanced listening (e.g., 80% means very even distribution)
- Lower score = concentrated favorites (e.g., 20% means one dominant item)
- Displayed with 25-character progress bars

### 4. Consistency Metrics
- **Consistency %:** Months with ≥5 plays / 12 * 100
- **Longest Streak:** Consecutive active months
- **Dynamic Messages:** Based on consistency level
  - ≥75%: "You kept the music flowing steadily — your Wrapped is consistent!"
  - ≥50%: "Solid listening habits — you showed up for the music."
  - ≥25%: "Your listening came in waves — you had your moments."
  - <25%: "You kept it selective — quality over quantity."

### 4. Trend Indicators
- ↑ for month-over-month increase
- ↓ for month-over-month decrease
- Compares each month to previous month
- Visual feedback for listening patterns

### 5. Role-Based Access Control
- Different interfaces for different roles
- Content managers see CRUD operations
- End users see Wrapped and history
- Menu items change based on role
- Protected routes with decorators

### 6. Proportional Chart Heights
- Monthly charts scale based on max_count
- User charts and overall charts independent
- Formula: `(count / max_count) * 100%`
- Visual comparison of listening patterns

---

## Database Schema

### Core Entities

**user**
- user_id (PK)
- username (unique)
- password (plaintext for demo)
- email
- country (ENUM)
- age
- role (ENUM: End_User, Content_Manager, Data_Analyst, Artist, Administrator)

**artist**
- artist_id (PK)
- name (unique)
- artist_type (ENUM: Solo, Band)
- country (ENUM)
- formation_date (DATE)
- active_status (BOOLEAN)

**album**
- album_id (PK)
- title
- album_type (ENUM: Studio, Single, Live, EP, Soundtrack)
- genre (ENUM: Pop, Rock, Indie, Rap, Metal)
- release_date (DATE)
- artist_id (FK → artist)

**song**
- song_id (PK)
- title
- duration (TIME)
- genre (ENUM)
- release_date (DATE)
- lyrics (TEXT)
- language
- artist_id (FK → artist)
- album_id (FK → album, nullable)
- album_track_number

### Relationship Tables

**song_moods**
- song_id (PK, FK → song)
- mood (PK, ENUM: 10 moods)

**album_moods**
- album_id (PK, FK → album)
- mood (PK, ENUM: 10 moods)

**playlist**
- playlist_id (PK)
- name
- creation_date (DATE)
- is_public (BOOLEAN)
- user_id (FK → user)

**playlist_moods**
- playlist_id (PK, FK → playlist)
- mood (PK, ENUM)

**playlist_contains_song**
- playlist_id (PK, FK → playlist)
- song_id (PK, FK → song)
- playlist_track_number

### Activity Tracking

**user_listens_song**
- user_id (PK, FK → user)
- song_id (PK, FK → song)
- timestamp_start (PK, DATETIME)
- timestamp_end (DATETIME)
- device_type (ENUM: 5 device types)

**user_likes_song**
- user_id (PK, FK → user)
- song_id (PK, FK → song)
- date_liked (DATE)

**user_follows_artist**
- user_id (PK, FK → user)
- artist_id (PK, FK → artist)
- date_followed (DATE)

**user_follows_user**
- follower_id (PK, FK → user)
- followed_id (PK, FK → user)
- date_followed (DATE)

**user_jams_user**
- user_id_1 (PK, FK → user)
- user_id_2 (PK, FK → user)
- timestamp_start (PK, DATETIME)
- timestamp_end (DATETIME)

---