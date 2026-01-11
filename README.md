# Music Wrapped - Interactive Music Analytics Platform

A Flask web application with a unique DOS/terminal aesthetic that transforms a comprehensive music listening database into an interactive "Wrapped" experience. Built on a MySQL database with 14 tables tracking users, artists, albums, songs, and listening history.

## 🎵 Project Overview

Music Wrapped provides two distinct experiences:
- **End Users:** Interactive terminal-based "Wrapped 2025" statistics with 8 analytical queries
- **Content Managers:** Full CRUD interface for managing artists, albums, and songs

**Key Features:**
- Retro DOS/terminal aesthetic with sage green (#A8CC8C) on black
- Interactive command-line interface with boot sequence
- Comprehensive music analytics (top songs, artists, albums, moods, genres)
- Monthly listening charts with trend indicators (↑↓)
- Diversity index and consistency metrics
- Role-based access control (5 user roles)

**Database Foundation:**
- 14 interconnected tables
- 14 artists from 8 countries
- 14 albums across 5 genres
- 20 songs with full metadata
- 10 users with role-based permissions
- 135+ listening sessions for 2025 analytics

## 📁 Project Structure

```
MusicWrapped/
├── app.py                      # Main Flask application
├── config.py                   # Database configuration
├── models.py                   # SQLAlchemy ORM models (14 tables)
├── requirements.txt            # Python dependencies
├── routes/                     # Flask blueprints (controllers)
│   ├── auth.py                # Authentication (login/logout)
│   ├── dashboard.py           # Wrapped stats, history, analytics
│   ├── songs.py               # Song detail pages
│   ├── artists.py             # Artist detail pages
│   └── content_manager.py     # CRUD operations
├── templates/                  # Jinja2 HTML templates
│   ├── base.html              # Base template with DOS navigation
│   ├── auth/                  # Login page
│   ├── dashboard/             # Wrapped, history, stats pages
│   │   └── home.html          # Interactive terminal (1200+ lines)
│   ├── songs/                 # Song detail templates
│   ├── artists/               # Artist detail templates
│   └── content_manager/       # Management interfaces
└── static/                     # Static assets
    ├── css/
    │   ├── style.css          # Main stylesheet (2600+ lines)
    │   └── interactive-terminal.css  # Terminal styles (590+ lines)
    └── js/
        └── main.js            # JavaScript utilities
```

## ✨ Features

### End User Features

#### **Wrapped 2025 Dashboard** (Interactive Terminal)
- **Boot Sequence:** Full-screen DOS-style boot animation (5.5s)
- **Hero Section:** Total listening time display with scroll prompt
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
- Like/unlike functionality

#### **Artist Details**
- Artist metadata (type, country, formation date)
- Top songs by artist
- Album discography
- Personal listen count
- Monthly listening charts (user + overall)
- Follow/unfollow functionality

### Content Manager Features
- **Dashboard:** Entity counts (artists, albums, songs)
- **Artist Management:** Create, edit, delete artists with validation
- **Album Management:** Manage albums with mood tags
- **Song Management:** Full CRUD with lyrics, moods, artist/album relationships
- **Form Validation:** Server-side validation and error handling

---

## 🚀 Installation & Setup

### Prerequisites
- Python 3.8 or higher
- MySQL Server 8.0+
- Git (optional)

### Step 1: Clone/Navigate to the Project

```powershell
cd d:\MusicWrapped
```

### Step 2: Create a Virtual Environment

```powershell
python -m venv venv
```

### Step 3: Activate the Virtual Environment

```powershell
.\venv\Scripts\Activate
```

### Step 4: Install Dependencies

```powershell
pip install -r requirements.txt
```

### Step 5: Set Up the Database

1. Make sure MySQL is running

2. Import the database dump:

```powershell
# Import the database (SQL files are in the database folder)
mysql -u root -p < database\dbdump.sql

# Create users and assign privileges
mysql -u root -p < database\users.sql
```

### Step 6: Configure Database Connection (IMPORTANT!)

**Create a `.env` file** in the MusicWrapped directory with your database credentials:

```powershell
# Create the .env file
New-Item -Path .env -ItemType File

# Open it in notepad
notepad .env
```

**Add this content to the `.env` file:**

```env
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_HOST=localhost
DB_NAME=musicwrappeddatabase
```

Replace `your_mysql_password` with your actual MySQL root password.

**Important Notes:**
- ✅ The `.env` file is in `.gitignore` - your password won't be uploaded to GitHub
- ✅ See [`.env.example`](.env.example) for a template
- ✅ See [SETUP_PASSWORD.md](SETUP_PASSWORD.md) for detailed instructions
- ⚠️ The app will NOT run without a `.env` file!

### Step 7: Run the Application

```powershell
# Make sure you're in the MusicWrapped directory
cd d:\MusicWrapped

# Run the Flask app
python app.py
```

The application will start on `http://localhost:5000`

## 🎮 Usage

### For End Users

1. Navigate to `http://localhost:5000`
2. Login with test credentials:
   - **Username:** `pierre_frt`
   - **Password:** `Pierre@33`
   - **User Type:** End User
3. Experience the boot sequence → hero section → interactive terminal
4. Try commands:
   - Type `help` to see all available commands
   - Type `run total_plays` to see your playback stats
   - Type `run monthly_chart` to visualize your year
   - Use arrow keys to navigate command history
5. Explore song/artist details by clicking from any list

### For Content Managers

1. Navigate to `http://localhost:5000`
2. Login with manager credentials:
   - **Username:** `content_admin` (create or use existing)
   - **Password:** Your password
   - **User Type:** Content Manager
3. Access management dashboard
4. Add/Edit/Delete artists, albums, songs

---

## 👥 User Roles

The application supports five user roles defined in the database:

- **End_User:** View Wrapped statistics, history, explore songs/artists
- **Content_Manager:** Full CRUD operations on artists, albums, songs
- **Data_Analyst:** Read-only access to all data
- **Artist:** Artist-specific statistics (future enhancement)
- **Administrator:** Full system access (future enhancement)

---

## 📊 Database Schema

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

## 🛠️ Technologies Used

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

## 🎨 Design Philosophy

**DOS/Terminal Aesthetic:**
- Inspired by classic command-line interfaces
- Box-drawing characters for borders
- Monospace typography throughout
- Command-line interaction paradigm
- Retro green-on-black color scheme

**User Experience:**
- Progressive revelation (boot → hero → terminal)
- Interactive feedback (loading animations, processing steps)
- Consistent visual language across all pages
- Responsive design within terminal constraints

---

## 📸 Screenshots & Features

### Boot Sequence
- Full-screen black background
- Left-aligned green text
- 7-stage animated boot process
- "SYSTEM READY" confirmation

### Hero Section
- "> LOADING_USER_DATA.exe" prompt
- Large title display
- Total minutes statistic
- Scroll prompt with bounce animation

### Interactive Terminal
- DOS-style header (╔═══╗)
- Command history scrolling
- Real-time query execution
- Multiple result formats:
  - Tables for rankings
  - Box displays for stats
  - Centered text for moods/genres
  - Bar charts for monthly data
  - Progress bars for percentages

---

## 🔧 Troubleshooting

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

## 📚 Documentation

- **[README.md](README.md)** - This file (overview and setup)
- **[PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)** - Complete project architecture and design decisions
- **[DATA_ADDITIONS.md](DATA_ADDITIONS.md)** - Details on artists, albums, and songs added during development
- **[QUICKSTART.md](QUICKSTART.md)** - Quick setup guide
- **[database/README.md](database/README.md)** - Database schema documentation
- **[user_credentials.md](user_credentials.md)** - Test user credentials

---

## 🎯 Project Highlights

### Database Foundation
✅ 14 interconnected MySQL tables with complete relationships
✅ 6 analytical SQL queries (user history, artist moods, genre filtering, etc.)
✅ **Enhanced dataset:** Added 6 artists, 6 albums, 12 songs during development
✅ 10 users across 5 roles and 7 countries
✅ 135+ listening sessions spanning all of 2025
✅ 10 moods, 5 genres, comprehensive metadata

### Web Application Features
✅ Interactive terminal interface with command system
✅ 8 analytical queries for Wrapped statistics
✅ Diversity index and consistency metrics
✅ Trend indicators for monthly data (↑↓)
✅ Role-based authentication system
✅ Full CRUD operations for content management
✅ Unique DOS/terminal aesthetic with VT323 font
✅ Progressive revelation (boot → hero → terminal)
✅ Comprehensive documentation

### Data Additions
See [DATA_ADDITIONS.md](DATA_ADDITIONS.md) for complete details on:
- **6 artists added:** Depeche Mode, Sade, Madonna, Radiohead, Massive Attack, Tame Impala
- **6 albums added:** Violator, Diamond Life, Like a Prayer, OK Computer, Mezzanine, Deadbeat
- **12 songs added** from new artists
- Expanded listening history for comprehensive wrapped analytics  

---

## 🚀 Future Enhancements

Possible improvements:
- Password hashing with bcrypt
- User registration system
- Chart.js for data visualization
- Playlist management interface
- Social features (friends' wrapped, sharing)
- Music recommendations engine
- PDF export for wrapped
- RESTful API endpoints
- Mobile responsive enhancements

---

## 📄 License

This project is created for educational purposes as part of a database systems course.

---

## 🤝 Project Architecture

**Database Foundation:**  
MySQL database with 14 interconnected tables tracking users, artists, albums, songs, playlists, and listening history. Enhanced during development with additional artists and albums to support comprehensive analytics.

**Web Application:**  
Flask framework with blueprint architecture, SQLAlchemy ORM, and Jinja2 templating. Features a unique DOS/terminal aesthetic with interactive command-line interface.

**Design Philosophy:**  
Retro computing aesthetic meets modern web functionality. Progressive revelation, interactive feedback, and consistent visual language throughout.

---

**Fonts:** VT323 (Google Fonts), Courier Prime  
**Created for:** Database Systems Course - Interactive Music Analytics Platform