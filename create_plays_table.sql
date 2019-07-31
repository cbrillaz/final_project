-- Create SQL Database ETL Project
CREATE DATABASE FINAL_PROJECT;

-- This is the SQL to create the first table
USE FINAL_PROJECT;
CREATE TABLE plays(
  year VARCHAR (4),
  week_number VARCHAR(30),
  weather VARCHAR(250) NOT NULL,
  time_zone VARCHAR(30) NOT NULL,
  game_time VARCHAR(30) NOT NULL,
  stadium VARCHAR(250) NOT NULL,
  roof VARCHAR(30) NOT NULL,
  surface VARCHAR(30) NOT NULL,
  home_team VARCHAR(30),
  away_team VARCHAR(30) NOT NULL,
  wall_clock VARCHAR(30) NOT NULL,
  offense VARCHAR(30) NOT NULL,
  defense VARCHAR(30) NOT NULL,
  home_points VARCHAR(30) NOT NULL,
  away_points VARCHAR(30),
  game_play_number VARCHAR(30) NOT NULL,
  duration VARCHAR(30) NOT NULL,
  drive_number VARCHAR(30) NOT NULL,
  start_reason VARCHAR(30) NOT NULL,
  end_reason VARCHAR(30) NOT NULL,
  plays_in_drive VARCHAR(30) NOT NULL,
  drive_play_number VARCHAR(30) NOT NULL,
  quarter VARCHAR(30),
  game_clock VARCHAR(30) NOT NULL,
  field_position VARCHAR(30) NOT NULL,
  line_of_scrimmage VARCHAR(30) NOT NULL,
  down VARCHAR(30) NOT NULL,
  distance VARCHAR(30) NOT NULL,
  play_clock VARCHAR(30) NOT NULL,
  huddle VARCHAR(30) NOT NULL,
  play_type VARCHAR(30) NOT NULL,
  men_in_box VARCHAR(30) NOT NULL,
  players_rushed VARCHAR(30),
  blitz VARCHAR(30) NOT NULL,
  qb_at_snap VARCHAR(30) NOT NULL,
  play_direction VARCHAR(30) NOT NULL,
  pocket_location VARCHAR(30) NOT NULL,
  pass_route VARCHAR(30) NOT NULL,
  screen_pass VARCHAR(30) NOT NULL,
  touchdown VARCHAR(30),
  QB_team VARCHAR(30) NOT NULL,
  QB_name VARCHAR(30) NOT NULL,
  QB_attempt VARCHAR(30) NOT NULL,
  QB_complete VARCHAR(30) NOT NULL,
  QB_incomplete_type VARCHAR(30) NOT NULL,
  QB_air_yards VARCHAR(30) NOT NULL,
  QB_yards VARCHAR(30) NOT NULL,
  QB_firstdown VARCHAR(30),
  QB_blitz VARCHAR(30) NOT NULL,
  QB_hurry VARCHAR(30) NOT NULL,
  QB_knockdown VARCHAR(30) NOT NULL,
  QB_pocket_time VARCHAR(30) NOT NULL,
  QB_inside20 VARCHAR(30) NOT NULL,
  QB_goaltogo VARCHAR(30) NOT NULL,
  flex_team VARCHAR(30),
  flex_position VARCHAR(30) NOT NULL,
  flex_name VARCHAR(30) NOT NULL,
  flex_yards VARCHAR(30) NOT NULL,
  flex_attempt VARCHAR(30) NOT NULL,
  flex_running_lane VARCHAR(30) NOT NULL,
  flex_brokentackle VARCHAR(30) NOT NULL,
  flex_yacontact VARCHAR(30) NOT NULL,
  flex_target VARCHAR(30) NOT NULL,
  flex_reception VARCHAR(30) NOT NULL,
  flex_yacatch VARCHAR(30),
  flex_firstdown VARCHAR(30) NOT NULL,
  flex_inside20 VARCHAR(30) NOT NULL,
  flex_goaltogo VARCHAR(30) NOT NULL,
  flex_scramble VARCHAR(30) NOT NULL,
  flex_kneel VARCHAR(30) NOT NULL,
  flex_dropped VARCHAR(30) NOT NULL,
  DB_name VARCHAR(30) NOT NULL,
  DB_team VARCHAR(30) NOT NULL,
  DB_target VARCHAR(30) NOT NULL,
  DB_completion VARCHAR(30) NOT NULL,
  DB_tackle VARCHAR(30) NOT NULL,
  10_Zone VARCHAR(30)
);

-- Populate table with data
SHOW VARIABLES LIKE "secure_file_priv";
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/all_data.csv' 
INTO TABLE plays
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
;

-- Create unique play_id column
ALTER TABLE plays ADD COLUMN ` play_id` int(6) UNSIGNED PRIMARY KEY AUTO_INCREMENT FIRST;

select * from plays LIMIT 5;
