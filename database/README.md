# Database Files

This folder contains all the SQL files needed to set up and test the Music Wrapped database.

## Setup Files

### **dbdump.sql**
Complete database dump including:
- Database schema creation
- All table definitions with constraints
- Original data (8 artists, 8 albums, 10 songs, 9 users, base listening history)

**Usage:**
```cmd
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p musicwrappeddatabase < database\dbdump.sql
```

### **users.sql**
Password hashes for all users:
- Contains password values for all 10 users
- Must be imported after dbdump.sql

**Usage:**
```cmd
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p musicwrappeddatabase < database\users.sql
```

### **add_user_roles.sql**
Adds role column to user table:
- Creates role ENUM column with 5 roles
- Assigns Content_Manager role to nikos_89 and maria_bel
- Idempotent (safe to run multiple times)

**Usage:**
```cmd
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p musicwrappeddatabase < database\add_user_roles.sql
```

### **database_additions.sql**
Post-deliverable additions:
- 6 new artists (Depeche Mode, Sade, Interpol, Radiohead, Massive Attack, Tame Impala)
- 6 new albums with mood tags
- 11 new songs (songs 11-21) with mood tags
- User 10 (vinylcollector)
- 120+ listening sessions spanning all of 2025

**Usage:**
```cmd
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p musicwrappeddatabase < database\database_additions.sql
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

```cmd
# Import in this exact order:
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p musicwrappeddatabase < database\dbdump.sql
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p musicwrappeddatabase < database\users.sql
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p musicwrappeddatabase < database\add_user_roles.sql
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p musicwrappeddatabase < database\database_additions.sql

# Test individual queries (optional)
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p musicwrappeddatabase < database\query1.sql
```

---

## Notes

- All queries are designed to work with the `musicwrappeddatabase` schema
- Make sure to import `dbdump.sql` before running any queries
- The Flask application implements similar queries programmatically using SQLAlchemy
