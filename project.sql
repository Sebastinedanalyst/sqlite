--------------------------------------------------------------------------------------------------------------
--Importing and creating table for dataset
--------------------------------------------------------------------------------------------------------------
DROP TABLE

IF EXISTS athlete_event;
	CREATE TABLE athlete_event (
		ID INT,
		Name CHAR,
		Sex CHAR,
		Age INT,
		Height DBL,
		Weight DBL,
		Team CHAR,
		NOC CHAR,
		Games CHAR,
		Year DATE,
		Season CHAR,
		City CHAR,
		Sport CHAR,
		Event CHAR,
		Medal CHAR
		);.

.import /Users/bash/Downloads/athlete_events2.csv athlete_event

DROP TABLE
IF EXISTS noc;
CREATE TABLE noc (NOC CHAR, region CHAR);
.import /Users/bash/Downloads/noc_regions12.csv noc
SELECT * 
FROM noc;
-------------------------------------------------------------------------------------------------------------- 
--Joining and preparing table for analysis
--------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS olympics_dataset;

 CREATE TABLE  olympics_dataset 
 AS
 SELECT ID, region, a.NOC, Name, Sex,
                                 CASE WHEN Age = 'NA' THEN NULL ELSE Age END, 
                                 CASE WHEN Height = 'NA' THEN NULL ELSE Height END AS Heights, 
                                 CASE WHEN Weight = 'NA' THEN NULL ELSE Weight END AS Weights, 
                                 Team, Games, Year, Season, City, Sport, Event,
                                 CASE WHEN Medal = 'NA' THEN NULL ELSE Medal END AS Medals,
       
     CASE
         WHEN region IN ('Algeria', 'Angola', 'Benin', 'Botswana', 'Burkina Faso', 'Burundi', 'Cabo Verde', 'Cape Verde', 
                          'Cameroon', 'Central African Republic', 'Chad', 'Comoros', 'Democratic Republic of the Congo', 
                          'Ivory Coast', 'Djibouti', 'Egypt', 'Equatorial Guinea', 'Eritrea', 'Ethiopia', 'Gabon', 'Gambia', 
                          'Ghana', 'Guinea', 'Guinea-Bissau', 'Kenya', 'Lesotho', 'Liberia', 'Libya', 'Madagascar', 'Malawi', 
                          'Mali', 'Mauritania', 'Mauritius', 'Morocco', 'Mozambique', 'Namibia', 'Niger', 'Nigeria', 'Rwanda',
                          'Republic of Congo', 
                           'Sao Tome and Principe', 'Senegal', 'Seychelles', 'Sierra Leone', 'Somalia', 'South Africa', 'South Sudan',
                          'Sudan', 'Swaziland', 'Tanzania', 'Togo', 'Tunisia', 'Uganda', 'Zambia', 'Zimbabwe') THEN 'Africa'
      
         WHEN region IN ('Afghanistan', 'Armenia', 'Azerbaijan', 'Bahrain', 'Bangladesh', 'Bhutan', 'Brunei', 'Cambodia', 'China', 
                          'Georgia', 'India', 'Indonesia', 'Iran', 'Iraq', 'Israel', 'Japan', 'Jordan', 'Kazakhstan', 
                         'Kuwait', 'Kyrgyzstan', 'Laos', 'Lebanon', 'Malaysia', 'Maldives', 'Mongolia', 'Myanmar', 'Nepal', 
                         'North Korea', 'Oman', 'Pakistan', 'Palestine', 'Philippines', 'Qatar', 'Saudi Arabia', 
                         'Singapore', 'South Korea', 'Sri Lanka', 'Syria', 'Taiwan', 'Tajikistan', 'Thailand', 'Timor-Leste', 
                         'Turkey', 'Turkmenistan', 'United Arab Emirates', 'Uzbekistan', 'Vietnam', 'Yemen') THEN 'Asia'
      
         WHEN region IN ('Albania', 'Andorra', 'Austria', 'Belarus', 'Belgium', 'Bosnia and Herzegovina', 'Bulgaria', 'Croatia', 
                         'Czech Republic','Cyprus', 'Denmark', 'Estonia', 'Finland', 'France', 'Germany', 'Greece', 'Hungary', 'Iceland', 
                         'Ireland', 'Italy', 'Kosovo', 'Latvia', 'Liechtenstein', 'Lithuania', 'Luxembourg', 'Malta', 'Moldova', 
                         'Monaco', 'Montenegro','Macedonia', 'Netherlands', 'North Macedonia', 'Norway', 'Poland', 'Portugal', 'Romania', 
                         'Russia', 'San Marino', 'Serbia', 'Slovakia', 'Slovenia', 'Spain', 'Sweden', 'Switzerland', 'Ukraine', 
                         'UK') THEN 'Europe'
     
         WHEN region IN ('Antigua and Barbuda' , 'Antigua', 'Bahamas', 'Barbados', 'Belize','Bermuda', 'Canada', 'Costa Rica', 'Cuba', 'Cayman Islands', 'Dominica', 
                         'Dominican Republic', 'El Salvador', 'Grenada', 'Guatemala', 'Haiti', 'Honduras', 'Jamaica', 'Mexico','Puerto Rico', 
                         'Nicaragua', 'Panama', 'Saint Kitts', 'Saint Lucia', 'Saint Vincent', 'Trinidad','Trinidad and Tobago', 
                         'USA','Virgin Islands, US', 'Virgin Islands, British') THEN 'North America'
     
         WHEN region IN ('Australia', 'American Samoa', 'Cook Islands','Fiji', 'Guam', 'Kiribati', 'Marshall Islands', 'Micronesia', 'Nauru', 'New Zealand', 'Palau', 
                          'Papua New Guinea', 'Samoa', 'Solomon Islands', 'Tonga', 'Vanuatu') THEN 'Oceania'
      
         WHEN region IN ('Argentina', 'Aruba', 'Bolivia', 'Boliva', 'Brazil', 'Chile', 'Colombia','Curacao', 'Ecuador', 'Guyana', 'Paraguay', 'Peru', 'Suriname', 
                         'Uruguay', 'Venezuela') THEN 'South America'
         ELSE 'Others'
     END AS continent
  
 FROM athlete_event a
 JOIN noc n
 ON a.NOC=n.NOC;
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- EDA

------------------------------------------------------------------------------------------------------------------------------------------------------------
--Exploring the earliest and latest year of our olympics_dataset
------------------------------------------------------------------------------------------------------------------------------------------------------------ 
SELECT MIN(Year), MAX(Year)
FROM olympics_dataset;

--dataset contains olympic dataset from 1896 to 2016

SELECT MAX(Year)- MIN(Year)
FROM olympics_dataset;

dataset contain 120 years of records
------------------------------------------------------------------------------------------------------------------------------------------------------------
--Exploring regions wihhout continent and "NA" region
------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT *
FROM olympics_dataset
WHERE region = 'NA';
updating country "Tuvalu" to the region column and its appropiate continent

UPDATE olympics_dataset
SET region = 'Tuvalu',
     continent = 'Oceania'
WHERE NOC = 'TUV';

SELECT * 
FROM olympics_dataset
WHERE NOC ='TUV';
    

------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT COUNT(DISTINCT ID)
FROM olympics_dataset;

SELECT count(DISTINCT region) AS number_of_country
FROM olympics_dataset;

SELECT count(DISTINCT continent) AS number_of_continent
FROM olympics_dataset;
------------------------------------------------------------------------------------------------------------
--statistical summary of numerical varibles
--------------------------------------------------------------------------------------------------------------
SELECT MAX(Ages) AS max_age,
        MIN(Ages) AS min_age,
        AVG(Ages) AS average_age,
        MAX(Heights) AS max_height,
        MIN(Heights) AS min_height,
        AVG(Heights) AS average_height,
        MAX(Weights) AS max_weight,
        MIN(Weights) AS min_weight,
        AVG(Weights) AS average_weight
FROM olympics_dataset;   
--------------------------------------------------------------------------------------------------------------
--statistical summary of numerical varibles by sport
--------------------------------------------------------------------------------------------------------------
SELECT DISTINCT Sport,
           MAX(Ages) AS max_age,
        MIN(Ages) AS min_age,
        ROUND (AVG(Ages),2) AS average_age,
        MAX(Heights) AS max_height,
        MIN(Heights) AS min_height,
        ROUND(AVG(Heights),2) AS average_height,
        MAX(Weights) AS max_weight,
        MIN(Weights) AS min_weight,
        ROUND(AVG(Weights),2) AS average_weight
FROM olympics_dataset
GROUP BY Sport; 


--------------------------------------------------------------------------------------------------------------
--Exploring athlete with unusual age for an athlete
--------------------------------------------------------------------------------------------------------------
SELECT *
FROM olympics_dataset
WHERE Ages BETWEEN 70 AND 97;

SELECT *
FROM olympics_dataset
WHERE Ages BETWEEN 10 AND 13;
--------------------------------------------------------------------------------------------------------------
--Creating age groups for athletes and exploring relationships between age, medals, and other factors.
--------------------------------------------------------------------------------------------------------------
DROP VIEW IF EXISTS view_age_group;

CREATE VIEW view_age_group
 AS 
    SELECT *, CASE 
               WHEN Ages BETWEEN 10 AND 20 THEN 'junior_athlete'
               WHEN Ages BETWEEN 21 AND 40 THEN 'prime_athlete'
               WHEN Ages BETWEEN 41 AND 60 THEN 'seasoned_athlete'
               WHEN Ages BETWEEN 61 AND 97 THEN 'senior_athlete'
               ELSE 'Others' END AS age_group
FROM olympics_dataset;

SELECT *
FROM view_age_group
LIMIT 10;

--Medals won by different age group in comperison with their total games played

WITH a1 AS
        (SELECT age_group, COUNT(ID) AS medals_won
        FROM view_age_group
        WHERE Medals IS NOT NULL
        GROUP By age_group),
     a2 AS           
     (SELECT age_group, COUNT(ID) AS medals_not_won
     FROM view_age_group
     WHERE Medals IS NULL
     GROUP BY age_group)

SELECT *,
      medals_won+medals_not_won AS total_games,
      ROUND(CAST(medals_won AS FLOAT)*100/(medals_won+medals_not_won), 2) || '%' AS percentage_won
FROM a1 
JOIN a2 
USING(age_group) ; 

----players who have paticipated in more than one olympic game
SELECT Name, Ages, Sport,Games,Medals,Year,COUNT(Year) AS num_of_app_per_year
FROM view_age_group
WHERE Name IN (SELECT Name
                FROM (SELECT Name, COUNT(DISTINCT Year) AS count 
                      FROM olympics_dataset
                      --WHERE count >2
                      GROUP BY Name
                      HAVING count > 2)AS a
                      )
GROUP BY Name, Ages, Sport,Games,Medals,Year
ORDER BY Name ASC;

----players who have paticipated in more than one olympic game and their number of medals
SELECT Name, Sport ,
      COUNT(YEAR), 
      SUM (CASE WHEN Medals IS NULL THEN 0 ELSE 1 END) AS num_of_medals
FROM (
       SELECT Name, Ages, Sport,Games,Medals,Year,COUNT(Year) AS num_of_app_per_year
      FROM view_age_group
       WHERE Name IN (SELECT Name
                FROM (SELECT Name, COUNT(DISTINCT Year) AS count 
                      FROM olympics_dataset
                      --WHERE count >2
                      GROUP BY Name
                      HAVING count > 2)AS a
                      )
        GROUP BY Name, Ages, Sport,Games,Medals,Year
        ORDER BY Name ASC
       )
GROUP BY Name, Sport;   

SELECT DISTINCT Sport, COUNT(Medals) AS junior_athlete_medals, age_group
FROM view_age_group 
WHERE age_group = 'junior_athlete' AND Medals IS NOT NULL
GROUP BY Sport, age_group
ORDER BY junior_athlete_medals DESC;

SELECT DISTINCT Sport, COUNT(Medals) AS prime_athlete_medals, age_group
FROM view_age_group 
WHERE age_group = 'prime_athlete' AND Medals IS NOT NULL
GROUP BY Sport, age_group
ORDER BY prime_athlete_medals DESC;

SELECT DISTINCT Sport, COUNT(Medals) AS seasoned_athlete_medals, age_group
FROM view_age_group 
WHERE age_group = 'seasoned_athlete' AND Medals IS NOT NULL
GROUP BY Sport, age_group
ORDER BY seasoned_athlete_medals DESC; 

SELECT DISTINCT Sport, COUNT(Medals) AS senior_athlete_medals, age_group
FROM view_age_group 
WHERE age_group = 'senior_athlete' AND Medals IS NOT NULL
GROUP BY Sport, age_group
ORDER BY senior_athlete_medals DESC; 

SELECT DISTINCT Sport, COUNT(Medals) AS medals, age_group
FROM view_age_group 
WHERE age_group != 'Others'
GROUP BY Sport, age_group; 
--------------------------------------------------------------------------------------------------------------
--Age group distribution across continents
--------------------------------------------------------------------------------------------------------------
SELECT  continent, age_group, COUNT(ID) AS total_num_of_participant
FROM view_age_group
WHERE age_group != 'Others'
GROUP BY age_group, continent
ORDER BY continent ;
--------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------
-- Regions with most medals
--------------------------------------------------------------------------------------------------------------
SELECT region, Medals, COUNT(*) AS num_of_medals
FROM olympics_dataset
WHERE Medals IS NOT NULL
GROUP BY region, Medals
ORDER BY num_of_medals DESC;

SELECT region, Medals, COUNT(*) AS num_of_gold_medals
FROM olympics_dataset
WHERE Medals IS NOT NULL AND Medals = 'Gold'
GROUP BY region, Medals
ORDER BY num_of_medals DESC;

SELECT region, Medals, COUNT(*) AS num_of_silver_medals
FROM olympics_dataset
WHERE Medals IS NOT NULL AND Medals = 'Silver'
GROUP BY region, Medals
ORDER BY num_of_medals DESC;

SELECT region, Medals, COUNT(*) AS num_of_bronze_medals
FROM olympics_dataset
WHERE Medals IS NOT NULL AND Medals = 'Bronze'
GROUP BY region, Medals
ORDER BY num_of_medals DESC;
--------------------------------------------------------------------------------------------------------------
--Regions without Medals
--------------------------------------------------------------------------------------------------------------
SELECT DISTINCT region, continent
FROM olympics_dataset
WHERE region NOT IN(
                     SELECT DISTINCT region
                     FROM olympics_dataset
                     WHERE Medals IS NOT NULL
                     );

SELECT continent, COUNT(region)
FROM (
      SELECT DISTINCT region, continent
      FROM olympics_dataset
      WHERE region NOT IN(
                     SELECT DISTINCT region
                     FROM olympics_dataset
                     WHERE Medals IS NOT NULL
                     )
       )
GROUP BY continent;                     
--------------------------------------------------------------------------------------------------------------
--Number of events per year 
--------------------------------------------------------------------------------------------------------------
SELECT Year, COUNT( DISTINCT Event) number_of_event
FROM olympics_dataset
GROUP BY Year;

--------------------------------------------------------------------------------------------------------------
--Number of events per region and continent
--------------------------------------------------------------------------------------------------------------
SELECT region,
NOC,
       number_of_event,
        number_of_games_played,
      total_num_of_medals                         
FROM 
    (
    SELECT DISTINCT region, COUNT( DISTINCT Event) number_of_event, 
                            COUNT(Games) AS number_of_games_played,
                    COUNT(Medals) AS total_num_of_medals,
                    NOC
    FROM view_age_group
    GROUP BY region
    ORDER BY number_of_event DESC
    );

SELECT ID,region,NOC,Name,Sex,Ages,Heights,Weights,Team,Games,Year,
       Season,City,Sport,Event,Medals, 
       CASE WHEN Medals IS NOT NULL THEN 1 ELSE 0 END AS Medal,continent

FROM olympics_dataset;

SELECT DISTINCT continent, COUNT( DISTINCT Event) number_of_event
FROM olympics_dataset
GROUP BY continent;
select *
from view_age_group
limit 5;



























