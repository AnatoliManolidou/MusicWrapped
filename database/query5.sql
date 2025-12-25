SELECT Artist.name, COUNT(*) AS total_listens
FROM User
JOIN User_Listens_Song ON User.user_id = User_Listens_Song.user_id
JOIN Song ON User_Listens_Song.song_id = Song.song_id
JOIN Artist ON Song.artist_id = Artist.artist_id
WHERE User.username = 'nikos_89'
GROUP BY Artist.name
ORDER BY total_listens DESC;