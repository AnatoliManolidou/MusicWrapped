FLUSH PRIVILEGES;

DROP USER IF EXISTS 'Administrator'@'localhost';
DROP USER IF EXISTS 'Content_Manager'@'localhost';
DROP USER IF EXISTS 'Data_Analyst'@'localhost';
DROP USER IF EXISTS 'End_User'@'localhost';
DROP USER IF EXISTS 'Artist'@'localhost';

-- Create users
CREATE USER 'Administrator'@'localhost' IDENTIFIED BY 'MWB_Admin';
CREATE USER 'Content_Manager'@'localhost' IDENTIFIED BY 'MWB_Content_Manager';
CREATE USER 'Data_Analyst'@'localhost' IDENTIFIED BY 'MWB_Data_Analyst';
CREATE USER 'End_User'@'localhost' IDENTIFIED BY 'MWB_End_User';
CREATE USER 'Artist'@'localhost' IDENTIFIED BY 'MWB_Artist';

-- Grant privileges

-- ---------------------------------------------------
-- Administrator
-- ---------------------------------------------------
GRANT ALL PRIVILEGES ON MusicWrappedDatabase.* TO 'Administrator'@'localhost';

-- ---------------------------------------------------
-- Content Manager
-- ---------------------------------------------------
GRANT SELECT ON MusicWrappedDatabase.* TO 'Content_Manager'@'localhost';
GRANT INSERT, UPDATE, DELETE ON MusicWrappedDatabase.artist TO 'Content_Manager'@'localhost';
GRANT INSERT, UPDATE, DELETE ON MusicWrappedDatabase.album TO 'Content_Manager'@'localhost';
GRANT INSERT, UPDATE, DELETE ON MusicWrappedDatabase.song TO 'Content_Manager'@'localhost';
GRANT INSERT, UPDATE, DELETE ON MusicWrappedDatabase.album_moods TO 'Content_Manager'@'localhost';
GRANT INSERT, UPDATE, DELETE ON MusicWrappedDatabase.song_moods TO 'Content_Manager'@'localhost';

-- ---------------------------------------------------
-- Data Analyst
-- ---------------------------------------------------
GRANT SELECT, SHOW VIEW ON MusicWrappedDatabase.* TO 'Data_Analyst'@'localhost';

-- ---------------------------------------------------
-- End User
-- ---------------------------------------------------
GRANT SELECT ON MusicWrappedDatabase.user TO 'End_User'@'localhost'; 
GRANT SELECT ON MusicWrappedDatabase.song TO 'End_User'@'localhost';
GRANT SELECT ON MusicWrappedDatabase.artist TO 'End_User'@'localhost';
GRANT SELECT ON MusicWrappedDatabase.album TO 'End_User'@'localhost';
GRANT SELECT ON MusicWrappedDatabase.album_moods TO 'End_User'@'localhost';
GRANT SELECT ON MusicWrappedDatabase.song_moods TO 'End_User'@'localhost';
GRANT SELECT ON MusicWrappedDatabase.playlist TO 'End_User'@'localhost';
GRANT SELECT ON MusicWrappedDatabase.playlist_moods TO 'End_User'@'localhost';
GRANT SELECT ON MusicWrappedDatabase.playlist_contains_song TO 'End_User'@'localhost';
GRANT SELECT ON MusicWrappedDatabase.user_listens_song TO 'End_User'@'localhost';
GRANT SELECT ON MusicWrappedDatabase.user_jams_user TO 'End_User'@'localhost';
GRANT SELECT ON MusicWrappedDatabase.user_follows_user TO 'End_User'@'localhost';
GRANT SELECT ON MusicWrappedDatabase.user_follows_artist TO 'End_User'@'localhost';
GRANT SELECT ON MusicWrappedDatabase.user_likes_song TO 'End_User'@'localhost';
GRANT SELECT ON MusicWrappedDatabase.pvibes TO 'End_User'@'localhost';
GRANT SELECT ON MusicWrappedDatabase.plisteningtime TO 'End_User'@'localhost';
GRANT SELECT ON MusicWrappedDatabase.partisthits TO 'End_User'@'localhost';

-- ---------------------------------------------------
-- Artist
-- ---------------------------------------------------
GRANT SELECT ON MusicWrappedDatabase.user TO 'Artist'@'localhost';
GRANT SELECT ON MusicWrappedDatabase.artist TO 'Artist'@'localhost';
GRANT SELECT ON MusicWrappedDatabase.song TO 'Artist'@'localhost';
GRANT SELECT ON MusicWrappedDatabase.song_moods TO 'Artist'@'localhost';
GRANT SELECT ON MusicWrappedDatabase.album TO 'Artist'@'localhost';
GRANT SELECT ON MusicWrappedDatabase.album_moods TO 'Artist'@'localhost';
GRANT SELECT ON MusicWrappedDatabase.playlist_moods TO 'End_User'@'localhost';
GRANT SELECT ON MusicWrappedDatabase.playlist_contains_song TO 'End_User'@'localhost';
GRANT SELECT ON MusicWrappedDatabase.user_likes_song TO 'End_User'@'localhost';
GRANT SELECT ON MusicWrappedDatabase.partisthits TO 'Artist'@'localhost';

-- Apply changes
FLUSH PRIVILEGES;
