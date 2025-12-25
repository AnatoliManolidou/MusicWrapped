SELECT 
    U1.username AS User_1, 
    U2.username AS User_2, 
    J.timestamp_start,
    TIMESTAMPDIFF(MINUTE, J.timestamp_start, J.timestamp_end) AS duration_minutes
FROM User_Jams_User AS J
JOIN User AS U1 ON J.user_id_1 = U1.user_id
JOIN User AS U2 ON J.user_id_2 = U2.user_id
ORDER BY duration_minutes DESC;