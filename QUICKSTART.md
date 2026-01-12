# Music Wrapped - Quick Start Guide

### 1. Update Database Password

**Option A: Using .env file (Recommended)**

Create a `.env` file in the MusicWrapped directory with:

```
DB_PASSWORD=your_mysql_password_here
```

**Option B: Hardcode in config.py**

Open `config.py` and change line 19:

```python
DB_PASSWORD = os.environ.get('DB_PASSWORD')  # Must be set in .env file
```

to:

```python
DB_PASSWORD = os.environ.get('DB_PASSWORD') or 'your_mysql_password_here'
```

### 2. Run Setup Script (Optional)

```powershell
.\setup.ps1
```

This will:
- Check Python and MySQL
- Create virtual environment
- Install dependencies

### 3. Manual Setup (if setup script doesn't work)

```powershell
# Create and activate virtual environment
python -m venv venv
.\venv\Scripts\Activate

# Install dependencies
pip install -r requirements.txt
```

### 4. Make Sure Database is Imported

If you haven't already imported the database, open Command Prompt (cmd) and run:

```cmd
cd /d D:\MusicWrapped
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p musicwrappeddatabase < database\dbdump.sql
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p musicwrappeddatabase < database\users.sql
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p musicwrappeddatabase < database\add_user_roles.sql
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p musicwrappeddatabase < database\database_additions.sql
```

**Note:** Adjust the MySQL path if you have a different version (e.g., `MySQL Server 8.4`).

### 5. Run the Application

Make sure to activate the virtual environment first:

```powershell
cd d:\MusicWrapped
.\venv\Scripts\Activate
python app.py
```

**Note:** You must activate the virtual environment every time you open a new terminal to run the app.

### 6. Open in Browser

Navigate to: **http://localhost:5000**

### 7. Login

**End User (to see Wrapped dashboard):**
- Username: `vinylcollector`
- Password: `password123`

**Content Manager (to manage content):**
- Username: `maria_bel`
- Password: `Maria_It3`

*See `user_credentials.md` for all available users*

## 📁 Project Structure

```
MusicWrapped/
├── app.py                  # Main app - RUN THIS
├── config.py              # Database config - EDIT THIS FIRST
├── models.py              # Database models
├── requirements.txt       # Dependencies
├── routes/                # Application routes
├── templates/             # HTML templates
└── static/               # CSS, JS, images
```

##  Features

### For End Users:
- **Wrapped Dashboard** - Your music year in review
- **Song Details** - Lyrics, stats, moods
- **Artist Pages** - Top songs, albums
- **History** - All your listens

### For Content Managers:
- **Add Artists** - Create new artists
- **Edit/Delete** - Manage all content

```
- **Feature Enhancement** - 
```

- **Add Albums** - Create albums with moods
- **Add Songs** - Upload songs with lyrics

##  Troubleshooting

**Can't connect to database?**
1. Check MySQL is running: `Get-Service MySQL*`
2. Verify password in `config.py`
3. Test: `mysql -u root -p`

**Module not found errors?**
```powershell
.\venv\Scripts\Activate
pip install -r requirements.txt
```