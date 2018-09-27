-- 1

--PART I
--1. Create a tablespace with name 'quiz_noche' and two datafiles. Each datafile of 10Mb.
CREATE TABLESPACE  quiz_noche
DATAFILE 'quiz_noche1.dbf' SIZE 10M,
        'quiz_noche2.dbf' SIZE 10M;

--2. Create a profile with idle time of 5 minutes, the name of the profile should be 'estudiante'
CREATE PROFILE estudiante LIMIT
IDLE_TIME 5;

--3. Create an user named "user1" with password "user1". 
	-- The user should be able to connect
	-- The user should has the profile "estudiante"
	-- The user should be associated to the tablespace "quiz_noche"
	-- The user should be able to create tables WITHOUT USING THE DBA ROLE.
    
CREATE USER user1
IDENTIFIED BY "user1"
DEFAULT TABLESPACE quiz_noche
QUOTA UNLIMITED ON quiz_noche;

ALTER USER user1 PROFILE estudiante;
GRANT CONNECT TO user1;
GRANT CREATE TABLE TO user1;

--4. Create an user named "user2" with password "user2"
	-- The user should be able to connect
	-- The user should has the profile "estudiante"
	-- The user should be associated to the tablespace "quiz_noche"
	-- The user shouldn't be able to create tables.

CREATE USER user2
IDENTIFIED BY "user2"
DEFAULT TABLESPACE quiz_noche
QUOTA UNLIMITED ON quiz_noche;

ALTER USER user2 PROFILE estudiante;
GRANT CONNECT TO user2;



--PART II

--1. With the user1 create the next table (DON'T CHANGE THE NAME OF THE TABLE NOR COLUMNS: 
create table attacks (
	id INT,
	url VARCHAR(2048),
	ip_address VARCHAR(20),
	number_of_attacks INT,
	time_of_last_attack TIMESTAMP
);
--2. Import this data (The format of the date is "YYYY-MM-DD HH24:MI:SS"): https://gist.github.com/amartinezg/6c2c27ae630102dbfb499ed22b338dd8
--3. Give permission to view table "attacks" of the user2 (Do selects)
GRANT SELECT ON user1.attacks to user2; 

--PART III

--Queries: 

--1. Count the urls which have been attacked and have the protocol 'http'
SELECT COUNT(url) FROM ATTACKS 
WHERE url like 'http:%';
--2. List the records where the URL attacked matches with google (it does not matter if it is google.co.jp, google.es, google.pt, etc) order by number of attacks descendant
SELECT * FROM ATTACKS 
WHERE url like '%google%'
order by number_of_attacks desc ;
--3. List the ip addresses and the time of the last attack if the attack has been produced this year (2018) (Hint: https://stackoverflow.com/a/30071091)
SELECT ip_address,time_of_last_attack FROM ATTACKS 
WHERE time_of_last_attack >= TO_DATE('2018-01-01T00:00:00', 'YYYY-MM-DD"T"HH24:MI:SS')
AND time_of_last_attack <= TO_DATE('2018-12-31T23:59:59', 'YYYY-MM-DD"T"HH24:MI:SS');
--4. Show the first IP Adress which has been registered with the maximum number of attacks 
SELECT * FROM(
SELECT  ip_address,number_of_attacks FROM ATTACKS 
ORDER BY  number_of_attacks DESC) WHERE ROWNUM = 1;


--5. Show the ip address and the number of attacks if instagram has been attack using http protocol

select ip_address,number_of_attacks from attacks
where url like 'http://instagram%';
