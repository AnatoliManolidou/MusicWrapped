# Database Files

This folder contains all the SQL files needed to set up and test the Music Wrapped database.

## Setup Files

### **dbdump.sql**
Complete database dump including:
- Database schema creation
- All table definitions with constraints
- Sample data (artists, songs, albums, users, listening history)
- Triggers and stored procedures
- Views

**Usage:**
```sql
mysql -u root -p < database/dbdump.sql
```

### **users.sql**
Database user creation and privilege management:
- Creates 5 user roles: Administrator, Content_Manager, Data_Analyst, End_User, Artist
- Assigns appropriate privileges for each role
- Used by the Flask app for role-based access control

**Usage:**
```sql
mysql -u root -p < database/users.sql
```

---

## Analytical Query Examples

These SQL files demonstrate core database operations for music analytics:

### **query1.sql**
**Purpose:** Get listening history for a specific user

Shows: User's listened songs with timestamps
```sql
-- Example: Get all songs listened by user 'nikos_89'
```

### **query2.sql**
**Purpose:** Get songs and moods by a specific artist

Shows: Songs by an artist (e.g., Queen) with their associated moods

### **query3.sql**
**Purpose:** Find users who listen to music but don't create playlists

Shows: Users with listening history but no playlists

### **query4.sql**
**Purpose:** Find songs by genre

Shows: All Rock or Metal songs

### **query5.sql**
**Purpose:** Get top artists for a specific user

Shows: Most listened artists by a user, ordered by play count

### **query6.sql**
**Purpose:** Show jam sessions between users

Shows: Collaborative listening sessions with duration

---

## Quick Setup Commands

```powershell
# Import database structure and data
mysql -u root -p < database/dbdump.sql

# Create users and set permissions
mysql -u root -p < database/users.sql

# Test individual queries (optional)
mysql -u root -p musicwrappeddatabase < database/query1.sql
```

---

## Notes

- All queries are designed to work with the `musicwrappeddatabase` schema
- Make sure to import `dbdump.sql` before running any queries
- The Flask application implements similar queries programmatically using SQLAlchemy
