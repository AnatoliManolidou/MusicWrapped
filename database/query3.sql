SELECT DISTINCT user.user_id
FROM User
JOIN User_Listens_Song ON User.user_id = User_Listens_Song.user_id
WHERE User.user_id NOT IN (SELECT user_id FROM Playlist);