-- Add role column to user table
-- First, check if role column exists and drop it to ensure clean state
USE musicwrappeddatabase;
SET @dbname = 'musicwrappeddatabase';
SET @tablename = 'user';
SET @columnname = 'role';
SET @preparedStatement = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE
      (table_name = @tablename)
      AND (table_schema = @dbname)
      AND (column_name = @columnname)
  ) > 0,
  'ALTER TABLE user DROP COLUMN role;',
  'SELECT 1;'
));
PREPARE alterIfExists FROM @preparedStatement;
EXECUTE alterIfExists;
DEALLOCATE PREPARE alterIfExists;

-- Now add the role column
ALTER TABLE user 
ADD COLUMN role ENUM('End_User', 'Content_Manager', 'Data_Analyst', 'Artist', 'Administrator') 
NOT NULL DEFAULT 'End_User';

-- Update specific users to have different roles
-- Set nikos_89 as Content Manager for testing
UPDATE user SET role = 'Content_Manager' WHERE username = 'nikos_89';

-- Set maria_bel as Content Manager
UPDATE user SET role = 'Content_Manager' WHERE username = 'maria_bel';

-- All others remain as End_User (default)

-- Verify the changes
SELECT username, role FROM user ORDER BY user_id;
