DROP TABLE UNITS;
DROP TABLE GRADES;
DROP TABLE MAIN;

CREATE TABLE MAIN
(
	ID SERIAL PRIMARY KEY,
	FirstName VARCHAR(30),
	ParentName VARCHAR(30),
	LastName VARCHAR(30),
	Birth DATE,
	StartedDate DATE,
	Position_ VARCHAR(20),
	Position_level VARCHAR(6),
	Unit_id INTEGER,
	Salary_RUB NUMERIC(10,2),
	HasRights BOOLEAN
);

INSERT INTO MAIN (FirstName, ParentName, LastName, Birth, StartedDate, Position_, Position_level, Unit_id, Salary_RUB, HasRights) VALUES
    ('Alexey', 'Alexandrovich', 'Vashekov', '1967-10-14', '2018-04-21', 'CEO', 'lead', 0, 1200000.00, TRUE),
    ('Victoria', 'Vladimirovna', 'Yakovenko', '1994-03-18', '2018-05-04', 'Assistant', 'junior', 0, 80000.00, FALSE),
    ('Denis', 'Valeryevich', 'Voronenko', '1988-06-04', '2016-01-14', 'Geologist', 'middle', 1, 170000.00, TRUE),
	('Evgeniy', 'Victorovich', 'Dema', '1983-04-25', '2014-12-01', 'Geologist', 'senior', 1, 250000.00, TRUE),
	('Elena', 'Sergeevna', 'Panferova', '1985-12-12', '2015-10-04', 'Product head', 'middle', 1, 154000.00, TRUE),
	('Natalya', 'Dmitrievna', 'Romanec', '2001-05-16', '2020-07-28', 'Assistant', 'junior', 1, 60000.00, FALSE),
	('Pavel', 'Pavlovich', 'Sorkin', '1987-10-03', '2010-11-21', 'Geology head', 'lead', 1, 573000.00, TRUE),
	('Rustem', 'Ravilevich', 'Suleymanov', '1980-06-13', '2009-03-14', 'IT head', 'lead', 2, 554000.00, FALSE),
	('Damir', 'Igorevich', 'Chirikov', '1988-01-27', '2012-11-07', 'Developer', 'senior', 2, 224000.00, TRUE),
	('Nail', 'Adikhamovich', 'Husinov', '2000-07-17', '2019-02-25', 'Developer', 'middle', 2, 224000.00, FALSE),
	('Denis', 'Anatolievich', 'Ryabov', '1980-01-11', '2009-04-01', 'Marketing head', 'lead', 3, 457000.00, FALSE),
	('Ekaterina', 'Igorevna', 'Stakova', '1989-05-24', '2017-09-18', 'Marketologist', 'middle', 3, 130000.00, FALSE),
	('Mars', 'Ravonovich', 'Husinov', '1957-09-09', '2022-04-04', 'Head analyst', 'lead', 4, 630000.00, FALSE),
	('Evgeniya', 'Valeryevna', 'Elistratova', '1995-11-17', '2022-05-17', 'Analyst', 'senior', 4, 266000.00, TRUE),
	('Konstantin', 'Mikhailovich', 'Volov', '1999-01-10', '2022-06-01', 'Analyst', 'middle', 4, 163000.00, TRUE);
   
CREATE TABLE UNITS
(
	ID INTEGER REFERENCES MAIN (ID),
	head_FirstName VARCHAR(30),
	head_ParentName VARCHAR(30),
	head_LastName VARCHAR(30),
	Unit_id INTEGER PRIMARY KEY UNIQUE,
	Unit_name VARCHAR(50),
	Unit_count INTEGER
);

INSERT INTO UNITS (ID, head_FirstName, head_ParentName, head_LastName, Unit_id)
SELECT ID, FirstName, ParentName, LastName, Unit_id FROM MAIN WHERE Position_level = 'lead';

UPDATE UNITS SET unit_name = 'Company head unit' WHERE unit_id = 0;
UPDATE UNITS SET unit_name = 'Geology unit' WHERE unit_id = 1;
UPDATE UNITS SET unit_name = 'IT unit' WHERE unit_id = 2;
UPDATE UNITS SET unit_name = 'Marketing unit' WHERE unit_id = 3;
UPDATE UNITS SET unit_name = 'Intellectual data analysis unit' WHERE unit_id = 4;

UPDATE UNITS SET unit_count = (SELECT COUNT(*) FROM MAIN WHERE Unit_id = 0 GROUP BY Unit_id) WHERE unit_id = 0;
UPDATE UNITS SET unit_count = (SELECT COUNT(*) FROM MAIN WHERE Unit_id = 1 GROUP BY Unit_id) WHERE unit_id = 1;
UPDATE UNITS SET unit_count = (SELECT COUNT(*) FROM MAIN WHERE Unit_id = 2 GROUP BY Unit_id) WHERE unit_id = 2;
UPDATE UNITS SET unit_count = (SELECT COUNT(*) FROM MAIN WHERE Unit_id = 3 GROUP BY Unit_id) WHERE unit_id = 3;
UPDATE UNITS SET unit_count = (SELECT COUNT(*) FROM MAIN WHERE Unit_id = 4 GROUP BY Unit_id) WHERE unit_id = 4;

CREATE TABLE GRADES
(
	ID SERIAL REFERENCES MAIN (ID),
	Grade_Q1 VARCHAR(1),
	Grade_Q2 VARCHAR(1),
	Grade_Q3 VARCHAR(1),
	Grade_Q4 VARCHAR(1)
);

INSERT INTO GRADES (Grade_Q1, Grade_Q2, Grade_Q3, Grade_Q4) VALUES
   ('A', 'A', 'B', 'A'),
   ('B', 'C', 'B', 'A'),
   ('C', 'B', 'C', 'B'),
   ('A', 'A', 'A', 'B'),
   ('A', 'B', 'B', 'B'),
   ('D', 'C', 'B', 'D'),
   ('A', 'A', 'A', 'A'),
   ('E', 'D', 'C', 'C'),
   ('A', 'B', 'C', 'B'),
   ('B', 'B', 'B', 'B'),
   ('B', 'C', 'B', 'A'),
   ('E', 'D', 'D', 'E'),
   ('B', 'C', 'B', 'A'),
   ('B', 'A', 'B', 'A'),
   ('B', 'C', 'C', 'C');

SELECT LastName, Salary_RUB FROM MAIN ORDER BY Salary_RUB DESC LIMIT 1;

SELECT LastName FROM MAIN ORDER BY LastName ASC;

WITH NAMES_UNITS AS(
SELECT LastName, UNITS.unit_name FROM MAIN FULL JOIN UNITS ON UNITS.Unit_id = MAIN.Unit_id
)
SELECT * FROM NAMES_UNITS;

WITH NAMES_UNITS_SALARIES AS(
SELECT LastName, Salary_RUB, UNITS.unit_name FROM MAIN FULL JOIN UNITS ON UNITS.Unit_id = MAIN.Unit_id
),
MAX_SALARY_IN_UNIT AS(
SELECT MAX(Salary_RUB) AS MAX_Salary_RUB, Unit_name FROM NAMES_UNITS_SALARIES GROUP BY Unit_name
)
SELECT LastName, MSIU.unit_name, MAX_Salary_RUB FROM MAX_SALARY_IN_UNIT AS MSIU JOIN NAMES_UNITS_SALARIES AS NUS ON MSIU.MAX_Salary_RUB = NUS.Salary_RUB;

SELECT Position_level, AVG(age(StartedDate)) AS Average_Experience_in_Company FROM MAIN GROUP BY Position_level ORDER BY Average_Experience_in_Company ASC;