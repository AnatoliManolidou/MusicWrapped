# Music Wrapped - Interactive Music Analytics Platform

This project is the third deliverable for the course Data Bases (ECE AUTH, 2025–2026). Our team:

Ομάδα 25<br> 
Μανωλίδου Ανατολή 10874 amanolid@ece.auth.gr<br> 
Σκλαβενίτης Γεώργιος 10708 gsklaven@ece.auth.gr<br> 
Τζίνα Θεοδώρα 10715 tzinatheod@ece.auth.gr<br> 

A Flask web application with a unique DOS/terminal aesthetic that transforms a comprehensive music listening database into an interactive "Wrapped" experience. Built on a MySQL database with 14 tables tracking users, artists, albums, songs, and listening history.

##  Project Overview

Music Wrapped provides two distinct experiences:
- **End Users:** Interactive terminal-based "Wrapped 2025" statistics with 8 analytical queries
- **Content Managers:** Full CRUD interface for managing artists, albums, and songs

**Key Features:**
- Interactive command-line interface with boot sequence
- Comprehensive music analytics (top songs, artists, albums, moods, genres)
- Monthly listening charts with trend indicators (↑↓)
- Diversity index and consistency metrics
- Role-based access control (2 user roles out of 5 were implemented)

**Database Foundation:**
- 14 interconnected tables
- 14 artists from 8 countries
- 14 albums across 5 genres
- 21 songs with full metadata
- 10 users with role-based permissions
- 120+ listening sessions for 2025 analytics

## 📁 Project Structure

```
MusicWrapped/
├── app.py                      # Main Flask application
├── config.py                   # Database configuration
├── models.py                   # SQLAlchemy ORM models (14 tables)
├── requirements.txt            # Python dependencies
├── setup.ps1                   # PowerShell setup script
├── .env.example                # Environment configuration template
├── .gitignore                  # Git ignore rules
├── README.md                   # This file (project overview)
├── PROJECT_STRUCTURE.md        # Detailed architecture documentation
├── DATA_ADDITIONS.md           # Added artists/albums/songs details
├── QUICKSTART.md               # Quick setup guide
├── user_credentials.md         # Test user login credentials
├── database/                   # SQL database files
│   ├── dbdump.sql             # Complete database dump
│   ├── users.sql              # MySQL user creation
│   ├── add_user_roles.sql     # User role assignments
│   ├── database_additions.sql # Additional data
│   └── query1-6.sql           # Analytical queries
├── routes/                     # Flask blueprints (controllers)
│   ├── auth.py                # Authentication (login/logout)
│   ├── dashboard.py           # Wrapped stats, history, analytics
│   ├── songs.py               # Song detail pages
│   ├── artists.py             # Artist detail pages
│   └── content_manager.py     # CRUD operations
├── templates/                  # Jinja2 HTML templates
│   ├── base.html              # Base template with DOS navigation
│   ├── auth/
│   │   └── login.html         # Login page
│   ├── dashboard/             # Wrapped, history, stats pages
│   │   ├── home.html          # Interactive terminal
│   │   ├── history.html       # Listening history
│   │   └── stats.html         # Statistics page
│   ├── songs/
│   │   └── detail.html        # Song detail page
│   ├── artists/
│   │   └── detail.html        # Artist detail page
│   └── content_manager/       # Management interfaces
│       ├── index.html         # Manager dashboard
│       ├── artists.html       # Artist list
│       └── artist_form.html   # Artist create/edit form
└── static/                     # Static assets
    ├── css/
    │   ├── style.css          # Main stylesheet 
    │   └── interactive-terminal.css  # Terminal styles 
    └── js/
        └── main.js            # JavaScript utilities
```

##  Features

### End User Features

#### **Wrapped 2025 Dashboard** (Interactive Terminal)
- **Interactive Terminal:** Command-line interface with 8 queries
  1. `run total_plays` - Total playback with progress bars
  2. `run top_artists` - Top 5 artists with diversity index
  3. `run top_songs` - Top 5 tracks with diversity index
  4. `run top_albums` - Top 5 albums with diversity index
  5. `run jam_sessions` - Music soulmate detection (solo/partner mode)
  6. `run mood_analysis` - Emotional profile (10 moods)
  7. `run top_genre` - Sound identity (5 genres)
  8. `run monthly_chart` - Year overview with trend indicators (↑↓), consistency %, longest streak
  - `help` - Show all commands
  - `clear` - Clear terminal history

#### **Statistics & Analytics**
- **Percentile Ranking:** Compares user activity to all users ("top X% of listeners")
  - Calculates percentile based on total plays and minutes
  - Dynamic messages: top 10% ("most active"), top 25% ("impressive"), etc.
- **Diversity Index:** Measures evenness of play distribution (0-100%, 0% when only 1 item)
- **Dynamic Messages:** Total playback message adapts to actual listening (500+ min vs 10 min)
- **Consistency Metrics:** Active months percentage with dynamic messages
- **Longest Streak:** Consecutive months with ≥5 plays
- **Trend Indicators:** Month-over-month changes (↑ increase, ↓ decrease)
- **Mood Descriptions:** Personalized messages for 10 moods
- **Genre Descriptions:** Custom text for 5 genres

#### **Listening History**
- Paginated view of all listening sessions (20 per page)
- Song-artist-album information
- Device type display
- Date and time stamps
  
#### **Song Details**
- Full lyrics display
- Mood tags
- Play count (personal vs global)
- Personal rank for this song
- Monthly listening charts (user + overall)

#### **Artist Details**
- Artist metadata (type, country, formation date)
- Top songs by artist
- Album discography
- Personal listen count
- Monthly listening charts (user + overall)

### Content Manager Features
- **Dashboard:** Entity counts (artists, albums, songs)
- **Artist Management:** Create, edit, delete artists with validation


---

##  Installation & Setup

### Prerequisites
- Python 3.8 or higher
- MySQL Server 8.0+
- Git (optional)

### Step 1: Configure Database Connection 

Copy `.env.example` to `.env` and update with your MySQL password:

```powershell
Copy-Item .env.example .env
notepad .env
```

In the `.env` file, replace `your_mysql_password_here` with your actual MySQL root password:

```env
DB_PASSWORD=your_actual_password
```

### Step 2: Run Setup Script (Recommended)

```powershell
cd d:\MusicWrapped
.\setup.ps1
```

This will:
- Check Python and MySQL
- Create virtual environment
- Install dependencies

### Step 3: Manual Setup (Alternative)

If the setup script doesn't work, use manual setup:

```powershell
# Create and activate virtual environment
python -m venv venv
.\venv\Scripts\Activate

# Install dependencies
pip install -r requirements.txt
```

### Step 4: Import the Database

If you haven't already imported the database, open Command Prompt (cmd) and run:

```cmd
cd /d D:\MusicWrapped
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p musicwrappeddatabase < database\dbdump.sql
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p musicwrappeddatabase < database\users.sql
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p musicwrappeddatabase < database\add_user_roles.sql
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p musicwrappeddatabase < database\database_additions.sql
```

**Note:** Adjust the MySQL path if you have a different version (e.g., `MySQL Server 8.4`).

### Step 5: Run the Application

Make sure to activate the virtual environment, if it has not been activated yet:

```powershell
cd d:\MusicWrapped
.\venv\Scripts\Activate
python app.py
```

The application will start on `http://localhost:5000`

##  Usage

### For End Users

1. Navigate to `http://localhost:5000`
2. Login with test credentials:
   - **Username:** `vinylcollector`
   - **Password:** `password123`
3. Experience the boot sequence → hero section → interactive terminal
4. Try commands:
   - Type `help` to see all available commands
   - Type `run total_plays` to see your playback stats
   - Type `run monthly_chart` to visualize your year
5. Explore song/artist details by clicking from any list

### For Content Managers

1. Navigate to `http://localhost:5000`
2. Login with manager credentials:
   - **Username:** `maria_bel` 
   - **Password:** `Maria_It3 `
3. Access management dashboard
4. Add/Edit/Delete artists

---

##  User Roles

The application supports five user roles defined in the database:

- **End_User:** View Wrapped statistics, history, explore songs/artists
- **Content_Manager:** Full CRUD operations on artists (albums and songs for future enhancement)
- **Data_Analyst:** Read-only access to all data (future enhancement)
- **Artist:** Artist-specific statistics (future enhancement)
- **Administrator:** Full system access (future enhancement)

---

##  Database Schema

The application uses 14 interconnected tables:

**Core Entities:**
- **user** - User accounts with roles and demographics
- **artist** - Musicians/bands with metadata
- **album** - Albums with genres and types
- **song** - Individual tracks with lyrics, duration, genre

**Relationships:**
- **song_moods** / **album_moods** / **playlist_moods** - Many-to-many mood assignments
- **playlist** - User-created playlists
- **playlist_contains_song** - Songs in playlists

**Activity Tracking:**
- **user_listens_song** - Complete listening history with timestamps
- **user_likes_song** - Liked songs
- **user_follows_artist** - Artist follows
- **user_follows_user** - User connections
- **user_jams_user** - Jam sessions (simultaneous listening)

**See [database/README.md](database/README.md) for complete schema documentation.**

---

## Technologies Used

**Backend:**
- Flask 3.0.0 (Python web framework)
- SQLAlchemy 3.1.1 (ORM)
- PyMySQL 1.1.0 (MySQL connector)
- python-dotenv (Environment variables)

**Database:**
- MySQL 8.0

**Frontend:**
- HTML5 with Jinja2 templating
- Custom CSS (~3200 lines)
- Vanilla JavaScript (no frameworks)

**Design:**
- VT323 font (retro terminal)
- Courier Prime font (monospace)
- DOS box-drawing characters (╔═══╗)
- Sage green (#A8CC8C) on black theme

---

##  Troubleshooting

### "Database password not found!" Error

**Solution:**
1. Create `.env` file in project root
2. Add: `DB_PASSWORD=your_mysql_password`
3. Restart the application

### Database Connection Issues

**Check MySQL status:**
```powershell
Get-Service MySQL*
```

**Test connection:**
```powershell
mysql -u root -p
USE musicwrappeddatabase;
SHOW TABLES;
```

### Module Import Errors

**Reinstall dependencies:**
```powershell
.\venv\Scripts\Activate
pip install -r requirements.txt
```

---

##  Documentation

- **[README.md](README.md)** - This file (overview and setup)
- **[PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)** - Complete project architecture and design decisions
- **[DATA_ADDITIONS.md](DATA_ADDITIONS.md)** - Details on artists, albums, and songs added during development
- **[QUICKSTART.md](QUICKSTART.md)** - Quick setup guide
- **[database/README.md](database/README.md)** - Database schema documentation
- **[user_credentials.md](user_credentials.md)** - Test user credentials

---

### Data Additions
See [DATA_ADDITIONS.md](DATA_ADDITIONS.md) for complete details on:
- **6 artists added:** Depeche Mode, Sade, Interpol, Radiohead, Massive Attack, Tame Impala
- **6 albums added:** Violator, Diamond Life, Turn On the Bright Lights, OK Computer, Mezzanine, Deadbeat
- **11 songs added** from new artists
- Expanded listening history for comprehensive wrapped analytics  

---

##  License

This project is created for educational purposes as part of a database systems course.

---

##  Project Architecture

**Database Foundation:**  
MySQL database with 14 interconnected tables tracking users, artists, albums, songs, playlists, and listening history. Enhanced during development with additional artists and albums to support comprehensive analytics.

**Web Application:**  
Flask framework with blueprint architecture, SQLAlchemy ORM, and Jinja2 templating. Features a unique DOS/terminal aesthetic with interactive command-line interface.

---
