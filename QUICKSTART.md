# Music Wrapped - Quick Start Guide

### 1. Update Database Password

Open `config.py` and change line 13:

```python
DB_PASSWORD = os.environ.get('DB_PASSWORD') or 'YOUR_MYSQL_PASSWORD_HERE'
```

Replace `YOUR_MYSQL_PASSWORD_HERE` with your actual MySQL root password.

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

If you haven't already imported the database:

```powershell
# From the MusicWrapped directory
mysql -u root -p < database\dbdump.sql
mysql -u root -p < database\users.sql
```

### 5. Run the Application

```powershell
cd d:\MusicWrapped
python app.py
```

### 6. Open in Browser

Navigate to: **http://localhost:5000**

### 7. Login

**End User (to see Wrapped dashboard):**
- Username: `pierre_frt`
- Password: `Pierre@33`

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

## ✨ Features

### For End Users:
- **Wrapped Dashboard** - Your music year in review
- **Song Details** - Lyrics, stats, moods
- **Artist Pages** - Top songs, albums
- **History** - All your listens
- **Like/Follow** - Save favorites

### For Content Managers:
- **Add Artists** - Create new artists
- **Add Albums** - Create albums with moods
- **Add Songs** - Upload songs with lyrics
- **Edit/Delete** - Manage all content

## 🐛 Troubleshooting

**Can't connect to database?**
1. Check MySQL is running: `Get-Service MySQL*`
2. Verify password in `config.py`
3. Test: `mysql -u root -p`

**Module not found errors?**
```powershell
.\venv\Scripts\Activate
pip install -r requirements.txt
```