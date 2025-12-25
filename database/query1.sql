SELECT User.username, Song.title, User_Listens_Song.timestamp_start, User_Listens_Song.timestamp_end
FROM User
JOIN User_Listens_Song ON User.user_id = User_Listens_Song.user_id
JOIN Song ON User_Listens_Song.song_id = Song.song_id
WHERE User.username = 'nikos_89';