# Music Wrapped - Database Interface Application

A Flask web application for the Music Wrapped Database project. This application provides an interface for end users to view their music listening statistics ("Wrapped") and for content managers to manage artists, albums, and songs.

## Project Structure

```
MusicWrapped/
├── app.py                      # Main application file
├── config.py                   # Configuration settings
├── models.py                   # Database models (SQLAlchemy)
├── requirements.txt            # Python dependencies
├── routes/                     # Route handlers (controllers)
│   ├── auth.py                # Authentication routes
│   ├── dashboard.py           # User dashboard routes
│   ├── songs.py               # Song detail routes
│   ├── artists.py             # Artist detail routes
│   └── content_manager.py     # Content management routes
├── templates/                  # HTML templates (Jinja2)
│   ├── base.html              # Base template
│   ├── auth/                  # Authentication templates
│   ├── dashboard/             # User dashboard templates
│   ├── songs/                 # Song detail templates
│   ├── artists/               # Artist detail templates
│   └── content_manager/       # Content manager templates
└── static/                     # Static files
    ├── css/
    │   └── style.css          # Main stylesheet
    └── js/
        └── main.js            # JavaScript functions
```

## Features

### End User Features
- **Wrapped Dashboard**: View your music year in review
  - Total listening time
  - Top 5 songs and artists
  - Favorite genre
  - Unique songs count
  
- **Listening History**: Browse your complete listening history with pagination

- **Song Details**: Click on any song to see:
  - Lyrics
  - Your play count
  - Total plays across all users
  - Your rank for this song
  - Moods/vibes
  - First and last listen dates
  - Like/unlike functionality

- **Artist Details**: View artist information:
  - Top songs by the artist
  - Albums
  - Your listen count for this artist
  - Total listeners
  - Follow/unfollow functionality

### Content Manager Features
- **Dashboard**: Overview of total artists, albums, and songs
- **Artist Management**: Create, edit, and delete artists
- **Album Management**: Create, edit, and delete albums (with mood tags)
- **Song Management**: Create, edit, and delete songs (with lyrics, moods, etc.)

## Installation & Setup

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

## Usage

### For End Users

1. Navigate to `http://localhost:5000`
2. Login with existing credentials:
   - Username: `nikos_89` (or any user from the database)
   - Password: Check your database (default passwords may vary)
   - User Type: Select "End User"
3. Explore your Wrapped dashboard, listening history, and song/artist details

### For Content Managers

1. Navigate to `http://localhost:5000`
2. Login with admin credentials:
   - Username: Create a user or use existing
   - Password: Your password
   - User Type: Select "Content Manager"
3. Access the content management dashboard to add/edit/delete:
   - Artists
   - Albums
   - Songs

## User Roles

The application supports the following user roles defined in your database:

- **End_User**: Can view their listening statistics and explore music
- **Content_Manager**: Can create, edit, and delete artists, albums, and songs
- **Data_Analyst**: Can view all data (read-only access)
- **Artist**: Can view artist-specific statistics
- **Administrator**: Full database access

## Database Schema

The application uses the following main entities:

- **User**: App users with listening history
- **Artist**: Music artists (solo or band)
- **Album**: Albums by artists
- **Song**: Individual songs
- **Playlist**: User-created playlists
- **UserListensSong**: Listening history
- **UserLikesSong**: Liked songs
- **UserFollowsArtist**: Followed artists

## Technologies Used

- **Backend**: Flask (Python web framework)
- **Database**: MySQL 8.0
- **ORM**: SQLAlchemy (Flask-SQLAlchemy)
- **Frontend**: HTML5, CSS3, JavaScript
- **Styling**: Custom CSS with Spotify-inspired dark theme
- **Icons**: Font Awesome 6

## Screenshots & Features Walkthrough

### End User Flow:
1. Login → Dashboard (Wrapped) → View stats
2. Click on a song → See song details, lyrics, your stats
3. Like/unlike songs
4. Click on artist → See artist details, top songs
5. Follow/unfollow artists
6. Browse listening history

### Content Manager Flow:
1. Login as Content Manager
2. Dashboard → Overview stats
3. Manage Artists → Add/Edit/Delete
4. Manage Albums → Add/Edit/Delete (with moods)
5. Manage Songs → Add/Edit/Delete (with lyrics and moods)

## Troubleshooting

### "Database password not found!" Error

**Problem:** The `.env` file doesn't exist or `DB_PASSWORD` is missing

**Solution:**
1. Create a `.env` file in the MusicWrapped directory
2. Add your database password (see Step 6 above)
3. See [SETUP_PASSWORD.md](SETUP_PASSWORD.md) for detailed help

### Database Connection Issues

If you see "Can't connect to MySQL server" or "Access denied":

1. Verify MySQL is running:
   ```powershell
   Get-Service MySQL*
   ```

2. Check your `.env` file contains the correct password

3. Test connection manually:
   ```powershell
   mysql -u root -p
   # Enter the same password from your .env file
   USE musicwrappeddatabase;
   SHOW TABLES;
   ```

### Import Errors

If you get module import errors:

```powershell
# Make sure virtual environment is activated
.\venv\Scripts\Activate

# Reinstall dependencies (including python-dotenv)
pip install -r requirements.txt
```

### Missing Templates

If you see "TemplateNotFound" errors, ensure all template files are created in the correct directory structure.

## Additional Templates Needed

For a complete application, you'll also need to create these template files:

- ✅ `templates/auth/login.html` - Login page (CREATED)
- ✅ `templates/dashboard/home.html` - Wrapped dashboard (CREATED)
- ✅ `templates/dashboard/history.html` - Listening history page (CREATED)
- ✅ `templates/songs/detail.html` - Song detail page (CREATED)
- ✅ `templates/artists/detail.html` - Artist detail page (CREATED)
- ✅ `templates/content_manager/index.html` - CM dashboard (CREATED)
- ✅ `templates/content_manager/artists.html` - List of artists (CREATED)
- ✅ `templates/content_manager/artist_form.html` - Add/Edit artist form (CREATED)
- ⬜ `templates/auth/register.html` - User registration page
- ⬜ `templates/dashboard/stats.html` - Detailed statistics page
- ⬜ `templates/artists/browse.html` - Browse all artists
- ⬜ `templates/songs/search.html` - Song search page
- ⬜ `templates/content_manager/albums.html` - List of albums
- ⬜ `templates/content_manager/songs.html` - List of songs
- ⬜ `templates/content_manager/album_form.html` - Add/Edit album form
- ⬜ `templates/content_manager/song_form.html` - Add/Edit song form

**Note:** The core features are fully functional with the templates already created!

## Future Enhancements

Possible improvements for extra credit:

- User registration and authentication with password hashing
- Data visualization with charts (using Chart.js or Plotly)
- Playlist management features
- Social features (following users, viewing friends' wrapped)
- Music recommendations based on listening history
- Export wrapped as PDF/image
- Admin panel for user management
- API endpoints for mobile app

## License

This project is created for educational purposes as part of a university course assignment.