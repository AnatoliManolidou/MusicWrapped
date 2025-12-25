-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: musicwrappeddatabase
-- ------------------------------------------------------
-- Server version	8.0.44
DROP SCHEMA IF EXISTS `musicwrappeddatabase`;
CREATE SCHEMA `musicwrappeddatabase`;
USE `musicwrappeddatabase`;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `album`
--

DROP TABLE IF EXISTS `album`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `album` (
  `album_id` int NOT NULL,
  `title` varchar(25) NOT NULL,
  `album_type` enum('Studio','Single','Live','EP','Soundtrack') NOT NULL,
  `genre` enum('Pop','Rock','Indie','Rap','Metal') NOT NULL,
  `release_date` date NOT NULL,
  `artist_id` int NOT NULL,
  PRIMARY KEY (`album_id`),
  KEY `artist_id_1_idx` (`artist_id`),
  CONSTRAINT `artist_id_1` FOREIGN KEY (`artist_id`) REFERENCES `artist` (`artist_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `album`
--

LOCK TABLES `album` WRITE;
/*!40000 ALTER TABLE `album` DISABLE KEYS */;
INSERT INTO `album` VALUES (1,'The Fame','Studio','Pop','2008-08-19',1),(2,'A Nigth at the Opera','Studio','Rock','1975-11-21',2),(3,'Happier Than Ever','Studio','Pop','2021-08-30',3),(4,'Skinty Fia','Studio','Indie','2022-04-22',4),(5,'The Eminem Show','Studio','Rap','2002-05-26',5),(6,'Master of Puppets','Studio','Metal','1986-03-03',6),(7,'AM','Studio','Rock','2013-09-09',7),(8,'After Hours','Studio','Pop','2020-03-20',8);
/*!40000 ALTER TABLE `album` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `album_BEFORE_INSERT` BEFORE INSERT ON `album` FOR EACH ROW BEGIN
    IF NEW.release_date <= '1900-01-01' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Album release date must be after 1900-01-01';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `album_BEFORE_UPDATE` BEFORE UPDATE ON `album` FOR EACH ROW BEGIN
    IF NEW.release_date <= '1900-01-01' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Album release date must be after 1900-01-01';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `album_moods`
--

DROP TABLE IF EXISTS `album_moods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `album_moods` (
  `album_id` int NOT NULL,
  `mood` enum('Happy','Melancholic','Energetic','Dark','Calm','Focused','Relaxing','Dramatic','Aggressive','Cool') NOT NULL,
  PRIMARY KEY (`album_id`,`mood`),
  CONSTRAINT `album_id_1` FOREIGN KEY (`album_id`) REFERENCES `album` (`album_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `album_moods`
--

LOCK TABLES `album_moods` WRITE;
/*!40000 ALTER TABLE `album_moods` DISABLE KEYS */;
INSERT INTO `album_moods` VALUES (1,'Happy'),(1,'Energetic'),(2,'Melancholic'),(2,'Dramatic'),(3,'Melancholic'),(3,'Dark'),(4,'Melancholic'),(5,'Energetic'),(6,'Aggressive'),(7,'Cool');
/*!40000 ALTER TABLE `album_moods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `artist`
--

DROP TABLE IF EXISTS `artist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artist` (
  `artist_id` int NOT NULL,
  `name` varchar(25) NOT NULL,
  `artist_type` enum('Solo','Band') NOT NULL,
  `country` enum('USA','UK','Germany','Ireland','France','Canada','Greece') NOT NULL,
  `formation_date` date NOT NULL,
  `active_status` tinyint(1) NOT NULL,
  PRIMARY KEY (`artist_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artist`
--

LOCK TABLES `artist` WRITE;
/*!40000 ALTER TABLE `artist` DISABLE KEYS */;
INSERT INTO `artist` VALUES (1,'Lady Gaga','Solo','USA','2005-01-01',1),(2,'Queen','Band','UK','1970-01-01',0),(3,'Billie Eilish','Solo','USA','2015-01-01',1),(4,'Fontaines D.C.','Band','Ireland','2017-01-01',1),(5,'Eminem','Solo','USA','1988-01-01',1),(6,'Metallica','Band','USA','1981-01-01',1),(7,'Arctic Monkeys','Band','UK','2002-01-01',1),(8,'The Weeknd','Solo','Canada','2010-01-01',1);
/*!40000 ALTER TABLE `artist` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `artist_BEFORE_INSERT` BEFORE INSERT ON `artist` FOR EACH ROW BEGIN
    IF NEW.formation_date <= '1900-01-01' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Formation date must be after 1900-01-01';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `artist_BEFORE_UPDATE` BEFORE UPDATE ON `artist` FOR EACH ROW BEGIN
    IF NEW.formation_date <= '1900-01-01' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Formation date must be after 1900-01-01';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `partisthits`
--

DROP TABLE IF EXISTS `partisthits`;
/*!50001 DROP VIEW IF EXISTS `partisthits`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `partisthits` AS SELECT 
 1 AS `name`,
 1 AS `title`,
 1 AS `play_count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `pgrtop`
--

DROP TABLE IF EXISTS `pgrtop`;
/*!50001 DROP VIEW IF EXISTS `pgrtop`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `pgrtop` AS SELECT 
 1 AS `genre`,
 1 AS `title`,
 1 AS `total_time_minutes`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `playlist`
--

DROP TABLE IF EXISTS `playlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playlist` (
  `playlist_id` int NOT NULL,
  `name` varchar(25) NOT NULL,
  `creation_date` date NOT NULL,
  `is_public` tinyint(1) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`playlist_id`),
  KEY `user_id_1_idx` (`user_id`),
  CONSTRAINT `user_id_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlist`
--

LOCK TABLES `playlist` WRITE;
/*!40000 ALTER TABLE `playlist` DISABLE KEYS */;
INSERT INTO `playlist` VALUES (1,'Morning Vibes','2025-01-10',1,1),(2,'Study Focus','2025-02-15',0,2),(3,'Workout Mix','2025-03-01',1,3),(4,'Chill Evening','2025-04-10',0,4),(5,'Road Trip','2025-05-20',1,5),(6,'Greek Summer','2025-06-01',1,6),(7,'Metal Only','2025-06-15',0,7),(8,'Nikos Rock Favs','2025-07-01',1,1);
/*!40000 ALTER TABLE `playlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playlist_contains_song`
--

DROP TABLE IF EXISTS `playlist_contains_song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playlist_contains_song` (
  `playlist_id` int NOT NULL,
  `song_id` int NOT NULL,
  `playlist_track_number` int NOT NULL,
  PRIMARY KEY (`playlist_id`,`song_id`),
  UNIQUE KEY `UQ_Playlist_Track_Number` (`playlist_id`,`playlist_track_number`),
  KEY `song_id_4_idx` (`song_id`),
  CONSTRAINT `playlist_id_2` FOREIGN KEY (`playlist_id`) REFERENCES `playlist` (`playlist_id`),
  CONSTRAINT `song_id_4` FOREIGN KEY (`song_id`) REFERENCES `song` (`song_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlist_contains_song`
--

LOCK TABLES `playlist_contains_song` WRITE;
/*!40000 ALTER TABLE `playlist_contains_song` DISABLE KEYS */;
INSERT INTO `playlist_contains_song` VALUES (1,1,1),(1,8,2),(2,4,1),(3,5,1),(3,1,2),(5,8,1),(6,7,4),(7,6,4),(8,2,1),(8,7,2),(8,9,3);
/*!40000 ALTER TABLE `playlist_contains_song` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playlist_moods`
--

DROP TABLE IF EXISTS `playlist_moods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playlist_moods` (
  `playlist_id` int NOT NULL,
  `mood` enum('Happy','Melancholic','Energetic','Dark','Calm','Focused','Relaxing','Dramatic','Aggressive','Cool') NOT NULL,
  PRIMARY KEY (`playlist_id`,`mood`),
  CONSTRAINT `playlist_id_1` FOREIGN KEY (`playlist_id`) REFERENCES `playlist` (`playlist_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlist_moods`
--

LOCK TABLES `playlist_moods` WRITE;
/*!40000 ALTER TABLE `playlist_moods` DISABLE KEYS */;
INSERT INTO `playlist_moods` VALUES (1,'Happy'),(1,'Calm'),(2,'Focused'),(3,'Energetic'),(4,'Relaxing'),(5,'Happy'),(6,'Happy'),(7,'Aggressive'),(8,'Energetic');
/*!40000 ALTER TABLE `playlist_moods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `plisteningtime`
--

DROP TABLE IF EXISTS `plisteningtime`;
/*!50001 DROP VIEW IF EXISTS `plisteningtime`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `plisteningtime` AS SELECT 
 1 AS `username`,
 1 AS `total_time_minutes`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `pvibes`
--

DROP TABLE IF EXISTS `pvibes`;
/*!50001 DROP VIEW IF EXISTS `pvibes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `pvibes` AS SELECT 
 1 AS `title`,
 1 AS `name`,
 1 AS `mood`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `song`
--

DROP TABLE IF EXISTS `song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `song` (
  `song_id` int NOT NULL,
  `title` varchar(25) NOT NULL,
  `duration` time NOT NULL,
  `genre` enum('Pop','Rock','Indie','Rap','Metal') NOT NULL,
  `release_date` date NOT NULL,
  `lyrics` text NOT NULL,
  `language` varchar(25) NOT NULL,
  `artist_id` int NOT NULL,
  `album_id` int NOT NULL,
  `album_track_number` int NOT NULL,
  PRIMARY KEY (`song_id`),
  UNIQUE KEY `UQ_Album_Track_Number` (`album_id`,`album_track_number`),
  KEY `artist_id_2_idx` (`artist_id`),
  KEY `album_id_2_idx` (`album_id`),
  CONSTRAINT `album_id_2` FOREIGN KEY (`album_id`) REFERENCES `album` (`album_id`),
  CONSTRAINT `artist_id_2` FOREIGN KEY (`artist_id`) REFERENCES `artist` (`artist_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `song`
--

LOCK TABLES `song` WRITE;
/*!40000 ALTER TABLE `song` DISABLE KEYS */;
INSERT INTO `song` VALUES (1,'Poker Face','00:03:57','Pop','2008-09-26','I wanna...','English',1,1,4),(2,'Bohemian Rhapsody','00:05:55','Rock','1975-10-31','Is this the...','English',2,2,11),(3,'my future','00:03:30','Pop','2021-03-30','I can’t...','English',3,3,4),(4,'Jackie Down the Line','00:04:01','Indie','2022-01-12','What good...','English',4,4,4),(5,'Without Me','00:04:50','Rap','2002-05-14','Two trailer...','English',5,5,2),(6,'Master of Puppets','00:08:35','Metal','1986-03-03','End of...','English',6,6,2),(7,'Do I WannaKnow?','00:04:32','Rock','2013-06-19','Have you...','English',7,7,1),(8,'Blinding Lights','00:03:20','Pop','2019-11-29','I’ve been...','English',8,8,9),(9,'Love of My Life','00:03:39','Rock','1975-11-21','Love of...','English',2,2,9),(10,'Bad Romance','00:04:54','Pop','2009-10-26','Ra ra...','English',1,1,1);
/*!40000 ALTER TABLE `song` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `song_BEFORE_INSERT` BEFORE INSERT ON `song` FOR EACH ROW BEGIN
    IF NEW.duration <= '00:00:00' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Song duration must be greater than 00:00:00';
    END IF;
    IF NEW.release_date <= '1900-01-01' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Song release date must be after 1900-01-01';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `song_BEFORE_UPDATE` BEFORE UPDATE ON `song` FOR EACH ROW BEGIN
    IF NEW.duration <= '00:00:00' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Song duration must be greater than 00:00:00';
    END IF;
    IF NEW.release_date <= '1900-01-01' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Song release date must be after 1900-01-01';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `song_moods`
--

DROP TABLE IF EXISTS `song_moods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `song_moods` (
  `song_id` int NOT NULL,
  `mood` enum('Happy','Melancholic','Energetic','Dark','Calm','Focused','Relaxing','Dramatic','Aggressive','Cool') NOT NULL,
  PRIMARY KEY (`song_id`,`mood`),
  CONSTRAINT `song_id_1` FOREIGN KEY (`song_id`) REFERENCES `song` (`song_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `song_moods`
--

LOCK TABLES `song_moods` WRITE;
/*!40000 ALTER TABLE `song_moods` DISABLE KEYS */;
INSERT INTO `song_moods` VALUES (1,'Happy'),(1,'Energetic'),(2,'Melancholic'),(2,'Dramatic'),(3,'Dark'),(4,'Melancholic'),(5,'Energetic'),(6,'Aggressive'),(7,'Cool'),(8,'Energetic'),(9,'Melancholic'),(10,'Energetic');
/*!40000 ALTER TABLE `song_moods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int NOT NULL,
  `username` varchar(25) NOT NULL,
  `password` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `country` enum('Greece','Germany','Italy','France','UK','Spain') NOT NULL,
  `age` int NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'nikos_89','Nikos!2025','nikos89@yahoo.gr','Greece',19),(2,'anna_mnd','Anna//Pass2','annamnd@gmail.com','Germany',23),(3,'pierre_frt','Pierre@33','pierrfrt@hotmail.com','France',27),(4,'maria_bel','Maria_It3','mariabel@yahoo.gr','Italy',34),(5,'john_stal','JohnUk!5','johnstal@gmail.com','UK',41),(6,'elena_gr','Elenarara!','elenagr@outlook.com','Greece',22),(7,'kostas_rock','MetalHead88','krock@gmail.com','Greece',29),(8,'sofia_new','Sofia1234','sofia@yahoo.com','Spain',20),(9,'hans_ber','HansPass99','hansb@de.mail','Germany',30);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `user_BEFORE_INSERT` BEFORE INSERT ON `user` FOR EACH ROW BEGIN
    IF NEW.age < 12 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'User must be at least 12 years old';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `user_BEFORE_UPDATE` BEFORE UPDATE ON `user` FOR EACH ROW BEGIN
    IF NEW.age < 12 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'User must be at least 12 years old';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `user_follows_artist`
--

DROP TABLE IF EXISTS `user_follows_artist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_follows_artist` (
  `user_id` int NOT NULL,
  `artist_id` int NOT NULL,
  `date_followed` date NOT NULL,
  PRIMARY KEY (`user_id`,`artist_id`),
  KEY `artist_id_2_idx` (`artist_id`),
  CONSTRAINT `artist_id_4` FOREIGN KEY (`artist_id`) REFERENCES `artist` (`artist_id`),
  CONSTRAINT `user_id_4` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_follows_artist`
--

LOCK TABLES `user_follows_artist` WRITE;
/*!40000 ALTER TABLE `user_follows_artist` DISABLE KEYS */;
INSERT INTO `user_follows_artist` VALUES (1,1,'2025-01-01'),(1,2,'2025-01-05'),(1,6,'2025-06-10'),(1,7,'2025-06-10'),(2,2,'2025-02-01'),(3,3,'2025-03-10'),(4,4,'2025-04-01'),(5,5,'2025-05-05'),(7,6,'2025-06-20'),(8,8,'2025-09-01');
/*!40000 ALTER TABLE `user_follows_artist` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `user_follows_artist_BEFORE_INSERT` BEFORE INSERT ON `user_follows_artist` FOR EACH ROW BEGIN
    IF YEAR(NEW.date_followed) <> 2025 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Follow date must be in 2025';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `user_follows_artist_BEFORE_UPDATE` BEFORE UPDATE ON `user_follows_artist` FOR EACH ROW BEGIN
    IF YEAR(NEW.date_followed) <> 2025 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Follow date must be in 2025';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `user_follows_user`
--

DROP TABLE IF EXISTS `user_follows_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_follows_user` (
  `follower_id` int NOT NULL,
  `followed_id` int NOT NULL,
  `date_followed` date NOT NULL,
  PRIMARY KEY (`follower_id`,`followed_id`),
  KEY `user_id_8_idx` (`followed_id`),
  CONSTRAINT `user_id_7` FOREIGN KEY (`follower_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `user_id_8` FOREIGN KEY (`followed_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_follows_user`
--

LOCK TABLES `user_follows_user` WRITE;
/*!40000 ALTER TABLE `user_follows_user` DISABLE KEYS */;
INSERT INTO `user_follows_user` VALUES (1,2,'2025-01-10'),(1,3,'2025-01-11'),(2,1,'2025-01-12'),(3,1,'2025-02-15'),(4,5,'2025-03-20'),(5,4,'2025-03-21'),(6,1,'2025-06-05'),(7,6,'2025-06-10'),(8,1,'2025-09-05');
/*!40000 ALTER TABLE `user_follows_user` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `user_follows_user_BEFORE_INSERT` BEFORE INSERT ON `user_follows_user` FOR EACH ROW BEGIN
    IF NEW.follower_id = NEW.followed_id THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'User cannot follow themselves';
    END IF;
    IF YEAR(NEW.date_followed) <> 2025 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Follow date must be in 2025';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `user_follows_user_BEFORE_UPDATE` BEFORE UPDATE ON `user_follows_user` FOR EACH ROW BEGIN
    IF NEW.follower_id = NEW.followed_id THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'User cannot follow themselves';
    END IF;
    IF YEAR(NEW.date_followed) <> 2025 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Follow date must be in 2025';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `user_jams_user`
--

DROP TABLE IF EXISTS `user_jams_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_jams_user` (
  `user_id_1` int NOT NULL,
  `user_id_2` int NOT NULL,
  `timestamp_start` datetime NOT NULL,
  `timestamp_end` datetime NOT NULL,
  PRIMARY KEY (`user_id_1`,`user_id_2`,`timestamp_start`),
  KEY `user_id_6_idx` (`user_id_2`),
  CONSTRAINT `user_id_5` FOREIGN KEY (`user_id_1`) REFERENCES `user` (`user_id`),
  CONSTRAINT `user_id_6` FOREIGN KEY (`user_id_2`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_jams_user`
--

LOCK TABLES `user_jams_user` WRITE;
/*!40000 ALTER TABLE `user_jams_user` DISABLE KEYS */;
INSERT INTO `user_jams_user` VALUES (1,2,'2025-06-01 20:00:00','2025-06-01 22:00:00'),(1,5,'2025-07-10 21:00:00','2025-07-10 23:00:00'),(1,6,'2025-09-20 10:00:00','2025-09-20 11:30:00'),(2,3,'2025-08-15 22:30:00','2025-08-16 01:00:00'),(3,4,'2025-06-05 18:00:00','2025-06-05 19:30:00'),(6,7,'2025-09-01 15:00:00','2025-09-01 17:45:00');
/*!40000 ALTER TABLE `user_jams_user` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `user_jams_user_BEFORE_INSERT` BEFORE INSERT ON `user_jams_user` FOR EACH ROW BEGIN
    IF YEAR(NEW.timestamp_start) <> 2025 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'timestamp_start must be in the year 2025';
    END IF;

    IF NEW.timestamp_end <= NEW.timestamp_start THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'timestamp_end must be after timestamp_start';
    END IF;

    IF NEW.user_id_1 = NEW.user_id_2 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'user_id_1 and user_id_2 must be different';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `user_jams_user_BEFORE_UPDATE` BEFORE UPDATE ON `user_jams_user` FOR EACH ROW BEGIN
    IF YEAR(NEW.timestamp_start) <> 2025 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'timestamp_start must be in the year 2025';
    END IF;

    IF NEW.timestamp_end <= NEW.timestamp_start THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'timestamp_end must be after timestamp_start';
    END IF;

    IF NEW.user_id_1 = NEW.user_id_2 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'user_id_1 and user_id_2 must be different';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `user_likes_song`
--

DROP TABLE IF EXISTS `user_likes_song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_likes_song` (
  `user_id` int NOT NULL,
  `song_id` int NOT NULL,
  `date_liked` date NOT NULL,
  PRIMARY KEY (`user_id`,`song_id`),
  KEY `song_id_2_idx` (`song_id`),
  CONSTRAINT `song_id_3` FOREIGN KEY (`song_id`) REFERENCES `song` (`song_id`),
  CONSTRAINT `user_id_3` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_likes_song`
--

LOCK TABLES `user_likes_song` WRITE;
/*!40000 ALTER TABLE `user_likes_song` DISABLE KEYS */;
INSERT INTO `user_likes_song` VALUES (1,1,'2025-01-16'),(1,2,'2025-01-16'),(1,6,'2025-06-11'),(2,2,'2025-02-11'),(3,3,'2025-03-06'),(4,4,'2025-04-21'),(5,5,'2025-05-02'),(6,7,'2025-07-21'),(7,6,'2025-08-06'),(8,8,'2025-09-02');
/*!40000 ALTER TABLE `user_likes_song` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `user_likes_song_BEFORE_INSERT` BEFORE INSERT ON `user_likes_song` FOR EACH ROW BEGIN
    IF YEAR(NEW.date_liked) <> 2025 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'date_liked must be in the year 2025';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `user_likes_song_BEFORE_UPDATE` BEFORE UPDATE ON `user_likes_song` FOR EACH ROW BEGIN
    IF YEAR(NEW.date_liked) <> 2025 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'date_liked must be in the year 2025';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `user_listens_song`
--

DROP TABLE IF EXISTS `user_listens_song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_listens_song` (
  `user_id` int NOT NULL,
  `song_id` int NOT NULL,
  `timestamp_start` datetime NOT NULL,
  `timestamp_end` datetime NOT NULL,
  `device_type` enum('Mobile','Desktop','Tablet','Smart TV','Web Player') NOT NULL,
  PRIMARY KEY (`user_id`,`song_id`,`timestamp_start`),
  KEY `song_id_2_idx` (`song_id`),
  CONSTRAINT `song_id_2` FOREIGN KEY (`song_id`) REFERENCES `song` (`song_id`),
  CONSTRAINT `user_id_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_listens_song`
--

LOCK TABLES `user_listens_song` WRITE;
/*!40000 ALTER TABLE `user_listens_song` DISABLE KEYS */;
INSERT INTO `user_listens_song` VALUES (1,1,'2025-01-15 08:30:43','2025-01-15 08:33:02','Mobile'),(1,2,'2025-01-15 08:35:40','2025-01-15 08:36:08','Mobile'),(1,6,'2025-06-10 10:50:34','2025-06-10 10:56:35','Desktop'),(1,7,'2025-06-10 10:10:47','2025-06-10 10:14:32','Desktop'),(1,9,'2025-06-12 11:42:00','2025-06-12 11:45:39','Mobile'),(2,2,'2025-02-10 21:15:53','2025-02-10 21:20:02','Desktop'),(3,3,'2025-03-05 18:00:54','2025-03-05 18:04:08','Mobile'),(4,4,'2025-04-20 23:45:23','2025-04-20 23:49:05','Tablet'),(5,5,'2025-05-01 14:10:00','2025-05-01 14:13:25','Web Player'),(6,7,'2025-07-20 19:31:00','2025-07-20 19:34:32','Mobile'),(7,2,'2025-08-05 22:10:30','2025-08-05 22:15:42','Mobile'),(7,6,'2025-08-05 22:08:00','2025-08-05 22:08:35','Mobile'),(8,8,'2025-09-01 09:46:20','2025-09-01 09:47:20','Mobile');
/*!40000 ALTER TABLE `user_listens_song` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `user_listens_song_BEFORE_INSERT` BEFORE INSERT ON `user_listens_song` FOR EACH ROW BEGIN
    IF YEAR(NEW.timestamp_start) <> 2025 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'timestamp_start must be in the year 2025';
    END IF;

    IF NEW.timestamp_end <= NEW.timestamp_start THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'timestamp_end must be after timestamp_start';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `user_listens_song_BEFORE_UPDATE` BEFORE UPDATE ON `user_listens_song` FOR EACH ROW BEGIN
    IF YEAR(NEW.timestamp_start) <> 2025 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'timestamp_start must be in the year 2025';
    END IF;

    IF NEW.timestamp_end <= NEW.timestamp_start THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'timestamp_end must be after timestamp_start';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `partisthits`
--

/*!50001 DROP VIEW IF EXISTS `partisthits`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `partisthits` AS select `artist`.`name` AS `name`,`song`.`title` AS `title`,count(`user_listens_song`.`user_id`) AS `play_count` from ((`artist` join `song` on((`song`.`artist_id` = `artist`.`artist_id`))) join `user_listens_song` on((`user_listens_song`.`song_id` = `song`.`song_id`))) group by `artist`.`name`,`song`.`title` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `pgrtop`
--

/*!50001 DROP VIEW IF EXISTS `pgrtop`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `pgrtop` AS select `album`.`genre` AS `genre`,`album`.`title` AS `title`,sum(timestampdiff(MINUTE,`user_listens_song`.`timestamp_start`,`user_listens_song`.`timestamp_end`)) AS `total_time_minutes` from (((`user` join `user_listens_song` on((`user_listens_song`.`user_id` = `user`.`user_id`))) join `song` on((`song`.`song_id` = `user_listens_song`.`song_id`))) join `album` on((`album`.`album_id` = `song`.`album_id`))) where (`user`.`country` = 'Greece') group by `album`.`genre`,`album`.`title` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `plisteningtime`
--

/*!50001 DROP VIEW IF EXISTS `plisteningtime`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `plisteningtime` AS select `user`.`username` AS `username`,sum(timestampdiff(MINUTE,`user_listens_song`.`timestamp_start`,`user_listens_song`.`timestamp_end`)) AS `total_time_minutes` from (`user` join `user_listens_song` on((`user`.`user_id` = `user_listens_song`.`user_id`))) where ((`user_listens_song`.`timestamp_start` >= '2025-01-01') and (`user_listens_song`.`timestamp_start` <= '2025-12-31')) group by `user`.`username` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `pvibes`
--

/*!50001 DROP VIEW IF EXISTS `pvibes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `pvibes` AS select `song`.`title` AS `title`,`artist`.`name` AS `name`,`song_moods`.`mood` AS `mood` from ((`artist` join `song` on((`song`.`artist_id` = `artist`.`artist_id`))) join `song_moods` on((`song_moods`.`song_id` = `song`.`song_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-19 17:53:09