-- Add role column to user table
ALTER TABLE user 
ADD COLUMN role ENUM('End_User', 'Content_Manager', 'Data_Analyst', 'Artist', 'Administrator') 
NOT NULL DEFAULT 'End_User';

-- Update specific users to have different roles
-- Set nikos_89 as Content Manager for testing
UPDATE user SET role = 'Content_Manager' WHERE username = 'nikos_89';

-- Set anna_mnd as Data Analyst
UPDATE user SET role = 'Data_Analyst' WHERE username = 'anna_mnd';

-- Set maria_bel as Content Manager
UPDATE user SET role = 'Content_Manager' WHERE username = 'maria_bel';

-- All others remain as End_User (default)

-- Verify the changes
SELECT username, role FROM user ORDER BY user_id;
