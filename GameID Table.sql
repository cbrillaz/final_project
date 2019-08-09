## MASTER GAMES TABLE START---------------------------------------------------------------------------------------------------

drop table if exists games;
CREATE TABLE games
select
@n := @n + 1 ID,
rd.year,
rd.week_number,
rd.weather,
rd.time_zone,
cast((date(rd.game_time))as CHAR) as game_date,
cast((time(rd.game_time))as CHAR) as game_time,
rd.stadium,
rd.roof,
rd.home_team,
max(rd.home_points) as 'home_finalscore',
rd.away_team,
max(rd.away_points) as 'away_finalscore',
max(rd.game_play_number) as 'number_of_plays',
max(rd.drive_number) as 'number_of_drives'
from final_project.rawdata rd, (SELECT @n := 0) m
where year > 2014
group by rd.year, rd.week_number, rd.home_team
order by rd.year, rd.week_number;

## BLITZ TABLES---------------------------------------------------------------------------------------------------

drop table if exists blitz_home;
create table blitz_home
select year, week_number, home_team, away_team, sum(blitz) as home_blitz
from rawdata
where defense = home_team and year > 2014
group by year, week_number, home_team;

drop table if exists blitz_away;
create table blitz_away
select year, week_number,home_team, away_team, sum(blitz) as away_blitz
from rawdata
where defense = away_team and year > 2014
group by year, week_number, away_team;

## MERGE AND CREATE JOINABLE SINGLE ID---------------------------------------------------------------------------------------------------
drop table if exists blitz;
create table blitz
select bh.year, bh.week_number, bh.home_team, bh.away_team, bh.home_blitz, ba.away_blitz, g.ID
from blitz_home bh
left join blitz_away ba on bh.year = ba.year and bh.week_number=ba.week_number and bh.home_team=ba.home_team
left join games g on ba.year = g.year and ba.week_number=g.week_number and ba.home_team=g.home_team;

## ALTER GAMES TO INCLUDE NEW COLUMNS---------------------------------------------------------------------------------------------------

ALTER TABLE games add home_blitz INT;
update games set home_blitz = (select home_blitz from blitz where games.ID = blitz.ID) 
  where exists (select home_blitz from blitz where games.ID = blitz.ID);

ALTER TABLE games add away_blitz INT;
update games set away_blitz = (select away_blitz from blitz where games.ID = blitz.ID) 
  where exists (select away_blitz from blitz where games.ID = blitz.ID);


## BRING IN AVERAGE PLAY CLOCK---------------------------------------------------------------------------------------------------

drop table if exists playclock_home;
create table playclock_home
select year, week_number, home_team, away_team, avg(play_clock) as home_playclock_avg
from rawdata
where play_clock is not null and offense = home_team and year > 2014
group by year, week_number, home_team;

drop table if exists playclock_away;
create table playclock_away
select year, week_number,home_team, away_team, avg(play_clock) as away_playclock_avg
from rawdata
where play_clock is not null and offense = away_team and year > 2014
group by year, week_number, away_team;

#select * from playclock_home;

## MERGE AND CREATE JOINABLE SINGLE ID---------------------------------------------------------------------------------------------------
drop table if exists play_clocks;
create table play_clocks
select pch.year, pch.week_number, pch.home_team, pch.away_team, pch.home_playclock_avg, pca.away_playclock_avg, g.ID
from playclock_home pch
left join playclock_away pca on pch.year = pca.year and pch.week_number=pca.week_number and pch.home_team=pca.home_team
left join games g on pca.year = g.year and pca.week_number=g.week_number and pca.home_team=g.home_team;

## ALTER GAMES TO INCLUDE NEW COLUMNS---------------------------------------------------------------------------------------------------

ALTER TABLE games add home_playclock_avg FLOAT4;
update games set home_playclock_avg = (select home_playclock_avg from play_clocks where games.ID = play_clocks.ID) 
  where exists (select home_playclock_avg from play_clocks where games.ID = play_clocks.ID);

ALTER TABLE games add away_playclock_avg FLOAT4;
update games set away_playclock_avg = (select away_playclock_avg from play_clocks where games.ID = play_clocks.ID) 
  where exists (select away_playclock_avg from play_clocks where games.ID = play_clocks.ID);

#select * from games;

## BRING IN AVERAGE QB POCKET CLOCK---------------------------------------------------------------------------------------------------

drop table if exists qb_pocket_time_home;
create table qb_pocket_time_home
select year, week_number, home_team, away_team, avg(qb_pocket_time) as home_qb_pocket_time_avg
from rawdata
where qb_pocket_time is not null and offense = home_team and year > 2014
group by year, week_number, home_team;

drop table if exists qb_pocket_time_away;
create table qb_pocket_time_away
select year, week_number,home_team, away_team, avg(qb_pocket_time) as away_qb_pocket_time_avg
from rawdata
where qb_pocket_time is not null and offense = away_team and year > 2014
group by year, week_number, away_team;


## MERGE AND CREATE JOINABLE SINGLE ID---------------------------------------------------------------------------------------------------
drop table if exists qb_pocket_times;
create table qb_pocket_times
select qbpth.year, qbpth.week_number, qbpth.home_team, qbpth.away_team, qbpth.home_qb_pocket_time_avg, qbpta.away_qb_pocket_time_avg, g.ID
from qb_pocket_time_home qbpth
left join qb_pocket_time_away qbpta on qbpth.year = qbpta.year and qbpth.week_number=qbpta.week_number and qbpth.home_team=qbpta.home_team
left join games g on qbpta.year = g.year and qbpta.week_number=g.week_number and qbpta.home_team=g.home_team;

## ALTER GAMES TO INCLUDE NEW COLUMNS---------------------------------------------------------------------------------------------------

ALTER TABLE games add home_qb_pocket_time_avg FLOAT4;
update games set home_qb_pocket_time_avg = (select home_qb_pocket_time_avg from qb_pocket_times where games.ID = qb_pocket_times.ID) 
  where exists (select home_qb_pocket_time_avg from qb_pocket_times where games.ID = qb_pocket_times.ID);

ALTER TABLE games add away_qb_pocket_time_avg FLOAT4;
update games set away_qb_pocket_time_avg = (select away_qb_pocket_time_avg from qb_pocket_times where games.ID = qb_pocket_times.ID) 
  where exists (select away_qb_pocket_time_avg from qb_pocket_times where games.ID = qb_pocket_times.ID);
  
  
  
## QB_ATTEMPT TABLES---------------------------------------------------------------------------------------------------

drop table if exists qb_attempt_home;
create table qb_attempt_home
select year, week_number, home_team, away_team, sum(qb_attempt) as home_qb_attempt
from rawdata
where offense = home_team and year > 2014
group by year, week_number, home_team;

drop table if exists qb_attempt_away;
create table qb_attempt_away
select year, week_number,home_team, away_team, sum(qb_attempt) as away_qb_attempt
from rawdata
where offense = away_team and year > 2014
group by year, week_number, away_team;

## MERGE AND CREATE JOINABLE SINGLE ID---------------------------------------------------------------------------------------------------
drop table if exists qb_attempt;
create table qb_attempt
select qahh.year, qahh.week_number, qahh.home_team, qahh.away_team, qahh.home_qb_attempt, qaha.away_qb_attempt, g.ID
from qb_attempt_home qahh
left join qb_attempt_away qaha on qahh.year = qaha.year and qahh.week_number=qaha.week_number and qahh.home_team=qaha.home_team
left join games g on qaha.year = g.year and qaha.week_number=g.week_number and qaha.home_team=g.home_team;

## ALTER GAMES TO INCLUDE NEW COLUMNS---------------------------------------------------------------------------------------------------

ALTER TABLE games add home_qb_attempt FLOAT4;
update games set home_qb_attempt = (select home_qb_attempt from qb_attempt where games.ID = qb_attempt.ID) 
  where exists (select home_qb_attempt from qb_attempt where games.ID = qb_attempt.ID);

ALTER TABLE games add away_qb_attempt FLOAT4;
update games set away_qb_attempt = (select away_qb_attempt from qb_attempt where games.ID = qb_attempt.ID) 
  where exists (select away_qb_attempt from qb_attempt where games.ID = qb_attempt.ID);

#select * from games;


## QB_complete TABLES---------------------------------------------------------------------------------------------------

drop table if exists qb_complete_home;
create table qb_complete_home
select year, week_number, home_team, away_team, sum(qb_complete) as home_qb_complete
from rawdata
where offense = home_team and year > 2014
group by year, week_number, home_team;

drop table if exists qb_complete_away;
create table qb_complete_away
select year, week_number,home_team, away_team, sum(qb_complete) as away_qb_complete
from rawdata
where offense = away_team and year > 2014
group by year, week_number, away_team;

## MERGE AND CREATE JOINABLE SINGLE ID---------------------------------------------------------------------------------------------------
drop table if exists qb_complete;
create table qb_complete
select qch.year, qch.week_number, qch.home_team, qch.away_team, qch.home_qb_complete, qca.away_qb_complete, g.ID
from qb_complete_home qch
left join qb_complete_away qca on qch.year = qca.year and qch.week_number=qca.week_number and qch.home_team=qca.home_team
left join games g on qca.year = g.year and qca.week_number=g.week_number and qca.home_team=g.home_team;

## ALTER GAMES TO INCLUDE NEW COLUMNS---------------------------------------------------------------------------------------------------

ALTER TABLE games add home_qb_complete FLOAT4;
update games set home_qb_complete = (select home_qb_complete from qb_complete where games.ID = qb_complete.ID) 
  where exists (select home_qb_complete from qb_complete where games.ID = qb_complete.ID);

ALTER TABLE games add away_qb_complete FLOAT4;
update games set away_qb_complete = (select away_qb_complete from qb_complete where games.ID = qb_complete.ID) 
  where exists (select away_qb_complete from qb_complete where games.ID = qb_complete.ID);
  


## qb_air_yards TABLES---------------------------------------------------------------------------------------------------

drop table if exists qb_air_yards_home;
create table qb_air_yards_home
select year, week_number, home_team, away_team, sum(qb_air_yards) as home_qb_air_yards
from rawdata
where offense = home_team and year > 2014
group by year, week_number, home_team;

drop table if exists qb_air_yards_away;
create table qb_air_yards_away
select year, week_number,home_team, away_team, sum(qb_air_yards) as away_qb_air_yards
from rawdata
where offense = away_team and year > 2014
group by year, week_number, away_team;

## MERGE AND CREATE JOINABLE SINGLE ID---------------------------------------------------------------------------------------------------
drop table if exists qb_air_yards;
create table qb_air_yards
select qayh.year, qayh.week_number, qayh.home_team, qayh.away_team, qayh.home_qb_air_yards, qaya.away_qb_air_yards, g.ID
from qb_air_yards_home qayh
left join qb_air_yards_away qaya on qayh.year = qaya.year and qayh.week_number=qaya.week_number and qayh.home_team=qaya.home_team
left join games g on qaya.year = g.year and qaya.week_number=g.week_number and qaya.home_team=g.home_team;

## ALTER GAMES TO INCLUDE NEW COLUMNS---------------------------------------------------------------------------------------------------

ALTER TABLE games add home_qb_air_yards FLOAT4;
update games set home_qb_air_yards = (select home_qb_air_yards from qb_air_yards where games.ID = qb_air_yards.ID) 
  where exists (select home_qb_air_yards from qb_air_yards where games.ID = qb_air_yards.ID);

ALTER TABLE games add away_qb_air_yards FLOAT4;
update games set away_qb_air_yards = (select away_qb_air_yards from qb_air_yards where games.ID = qb_air_yards.ID) 
  where exists (select away_qb_air_yards from qb_air_yards where games.ID = qb_air_yards.ID);




## qb_yards TABLES---------------------------------------------------------------------------------------------------

drop table if exists qb_yards_home;
create table qb_yards_home
select year, week_number, home_team, away_team, sum(qb_yards) as home_qb_yards
from rawdata
where offense = home_team and year > 2014
group by year, week_number, home_team;

drop table if exists qb_yards_away;
create table qb_yards_away
select year, week_number,home_team, away_team, sum(qb_yards) as away_qb_yards
from rawdata
where offense = away_team and year > 2014
group by year, week_number, away_team;

## MERGE AND CREATE JOINABLE SINGLE ID---------------------------------------------------------------------------------------------------
drop table if exists qb_yards;
create table qb_yards
select qyh.year, qyh.week_number, qyh.home_team, qyh.away_team, qyh.home_qb_yards, qya.away_qb_yards, g.ID
from qb_yards_home qyh
left join qb_yards_away qya on qyh.year = qya.year and qyh.week_number=qya.week_number and qyh.home_team=qya.home_team
left join games g on qya.year = g.year and qya.week_number=g.week_number and qya.home_team=g.home_team;

## ALTER GAMES TO INCLUDE NEW COLUMNS---------------------------------------------------------------------------------------------------

ALTER TABLE games add home_qb_yards FLOAT4;
update games set home_qb_yards = (select home_qb_yards from qb_yards where games.ID = qb_yards.ID) 
  where exists (select home_qb_yards from qb_yards where games.ID = qb_yards.ID);

ALTER TABLE games add away_qb_yards FLOAT4;
update games set away_qb_yards = (select away_qb_yards from qb_yards where games.ID = qb_yards.ID) 
  where exists (select away_qb_yards from qb_yards where games.ID = qb_yards.ID);
  
  
## qb_yards TABLES---------------------------------------------------------------------------------------------------

drop table if exists rush_bit;
create table rush_bit
select year, week_number, home_team, away_team,
case when offense = home_team
	and play_type = 'rush'
    then 1
    else 0
    end as 'home_rush_bit',
case when offense = away_team
	and play_type = 'rush'
    then 1
    else 0
    end as 'away_rush_bit'
from rawdata
where year > 2014;

drop table if exists rush;
create table rush
select rush.year, rush.week_number, rush.home_team, rush.away_team, sum(home_rush_bit) as home_rush_bit, sum(away_rush_bit) as away_rush_bit, g.ID
from rush_bit rush
left join games g on rush.year = g.year and rush.week_number=g.week_number and rush.home_team=g.home_team
group by year, week_number, home_team;


## rushing_yards TABLES---------------------------------------------------------------------------------------------------

drop table if exists rushing_yards_home;
create table rushing_yards_home
select year, week_number, home_team, away_team, sum(flex_yards) as home_rushing_yards
from rawdata
where offense = home_team and play_type = 'rush' and year > 2014
group by year, week_number, home_team;

drop table if exists rushing_yards_away;
create table rushing_yards_away
select year, week_number,home_team, away_team, sum(flex_yards) as away_rushing_yards
from rawdata
where offense = away_team and play_type = 'rush' and year > 2014
group by year, week_number, away_team;

## MERGE AND CREATE JOINABLE SINGLE ID---------------------------------------------------------------------------------------------------
drop table if exists rushing_yards;
create table rushing_yards
select ryh.year, ryh.week_number, ryh.home_team, ryh.away_team, ryh.home_rushing_yards, rya.away_rushing_yards, g.ID
from rushing_yards_home ryh
left join rushing_yards_away rya on ryh.year = rya.year and ryh.week_number=rya.week_number and ryh.home_team=rya.home_team
left join games g on rya.year = g.year and rya.week_number=g.week_number and rya.home_team=g.home_team;

## ALTER GAMES TO INCLUDE NEW COLUMNS---------------------------------------------------------------------------------------------------

ALTER TABLE games add home_rushing_yards FLOAT4;
update games set home_rushing_yards = (select home_rushing_yards from rushing_yards where games.ID = rushing_yards.ID) 
  where exists (select home_rushing_yards from rushing_yards where games.ID = rushing_yards.ID);

ALTER TABLE games add away_rushing_yards FLOAT4;
update games set away_rushing_yards = (select away_rushing_yards from rushing_yards where games.ID = rushing_yards.ID) 
  where exists (select away_rushing_yards from rushing_yards where games.ID = rushing_yards.ID);
  
  

 ## pass_protection TABLES---------------------------------------------------------------------------------------------------

#drop table if exists pass_protection_home;
#create table pass_protection_home
#select year, week_number, home_team, away_team, a(QB_pocket_time) as home_pass_protection
#from rawdata
#where offense = home_team and play_type = 'pass' and year > 2014
#group by year, week_number, home_team;

#drop table if exists pass_protection_away;
#create table pass_protection_away
#select year, week_number,home_team, away_team, avg(QB_pocket_time) as away_pass_protection
#from rawdata
#where offense = away_team and play_type = 'pass' and year > 2014
#group by year, week_number, away_team;

## MERGE AND CREATE JOINABLE SINGLE ID---------------------------------------------------------------------------------------------------
#drop table if exists pass_protection;
#create table pass_protection
#select pph.year, pph.week_number, pph.home_team, pph.away_team, pph.home_pass_protection, ppa.away_pass_protection, g.ID
#from pass_protection_home pph
#left join pass_protection_away ppa on pph.year = ppa.year and pph.week_number=ppa.week_number and pph.home_team=ppa.home_team
#left join games g on ppa.year = g.year and ppa.week_number=g.week_number and ppa.home_team=g.home_team;

## ALTER GAMES TO INCLUDE NEW COLUMNS---------------------------------------------------------------------------------------------------

#ALTER TABLE games add home_pass_protection FLOAT4;
#update games set home_pass_protection = (select home_pass_protection from pass_protection where games.ID = pass_protection.ID) 
#  where exists (select home_pass_protection from pass_protection where games.ID = pass_protection.ID);

#ALTER TABLE games add away_pass_protection FLOAT4;
#update games set away_pass_protection = (select away_pass_protection from pass_protection where games.ID = pass_protection.ID) 
#  where exists (select away_pass_protection from pass_protection where games.ID = pass_protection.ID);
   
  
select * from games;



