SELECT song.title, song_moods.mood
FROM artist
JOIN song ON artist.artist_id = song.artist_id
JOIN song_moods ON song_moods.song_id = song.song_id
WHERE artist.name = 'Queen'