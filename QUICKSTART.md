# Music Wrapped - Quick Start Guide

### 1. Update Database Password

Copy `.env.example` to `.env` and update with your MySQL password:

```powershell
Copy-Item .env.example .env
notepad .env
```

In the `.env` file, replace `your_mysql_password_here` with your actual MySQL password:

```
DB_PASSWORD=your_actual_password
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

Make sure to activate the virtual environment, if it has not been avtivated yet:

```powershell
cd d:\MusicWrapped
.\venv\Scripts\Activate
python app.py
```

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

##  Features

### For End Users:
- **Wrapped Dashboard** - Your music year in review
- **Song Details** - Lyrics, stats, moods
- **Artist Pages** - Top songs, albums
- **History** - All your listens

### For Content Managers:
- Add Artists - Create new artists
- Edit/Delete - Manage all content

```
- **Feature Enhancement** -

- **Add Albums** - Create albums with moods
- **Add Songs** - Upload songs with lyrics
```

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
