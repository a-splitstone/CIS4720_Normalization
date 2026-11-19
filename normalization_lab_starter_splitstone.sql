/* ================================================================
   CIS 4720  Normalization Lab
   Starter file: normalization_lab_starter.sql

   Name: Alyssa Splitstone
   Date: 11/19/26

   Work in this file and keep its name. It lives in your OneDrive
   folder CIS4720_Normalization, and it is the one file you publish
   to GitHub at the end.

   Write a comment in your own words above every statement.
   Total: 10 points.

   For EVERY problem below, complete all five steps:

     Step 1  DIAGNOSE  Which normal form (1NF, 2NF, or 3NF) does the
                       table break? Why? Name the columns involved.
     Step 2  DESIGN    List your new tables. Mark the primary key (PK)
                       and every foreign key (FK).
     Step 3  CREATE    Write a CREATE TABLE statement for each table,
                       with PRIMARY KEY and FOREIGN KEY constraints.
                       Create parent tables before child tables.
     Step 4  INSERT    Insert at least TWO rows into EVERY table.
                       Insert parent rows before child rows.
     Step 5  JOIN      Write one SELECT with JOINs that shows the data
                       from all of the problem's tables together.

   Use ONLY the table names given in each problem.
   The whole file must run from top to bottom without errors.
   ================================================================ */
-- DROP DATABASE IF EXISTS misc_db;
CREATE DATABASE IF NOT EXISTS misc_db;
USE misc_db;

SHOW DATABASES;
SELECT DATABASE();
SHOW TABLES;
/* ================================================================
   PROBLEM 1  Pet owners and their pets                 (2 points)
   ================================================================

   A pet grooming shop keeps one table named owner_pets:

     owner_id, owner_name, owner_city, pet1_name, pet2_name, pet3_name

   Sample rows:

   owner_id | owner_name   | owner_city | pet1_name | pet2_name | pet3_name
   =========+==============+============+===========+===========+==========
   1        | Maria Lopez  | Turlock    | Bella     | Max       | NULL
   2        | James Chen   | Modesto    | Luna      | NULL      | NULL
   3        | Priya Singh  | Ceres      | Rocky     | Daisy     | Coco

   The shop just signed up a customer with four pets.

   Use these table names:  owner, pet

   Step 1  DIAGNOSE:
-- doesn't hold to 1NF because it has repeating columns for pet names
-- fun fact...when I said the incorrect way similiar to this problem in class
-- I knew I was wrong and that something else solved it but was honestly so 
-- stressed that I just said it even though I knew.

   Step 2  DESIGN:
   TABLE owner COLUMNS owner_id, owner_name, owner_city KEYS PK owner_id
   TABLE pet COLUMNS pet_id, pet_name, owner_id KEYS PK pet_id FK owner_id

   
   
   */


/* Step 3  CREATE */

-- create owner and pet tables
CREATE TABLE owner(
   owner_id INT NOT NULL PRIMARY KEY,
   owner_name VARCHAR(30),
   owner_city VARCHAR(30)
);
CREATE TABLE pet(
   pet_id   INT NOT NULL PRIMARY KEY,
   pet_name VARCHAR(30),
   owner_id INT,
   FOREIGN KEY (owner_id) REFERENCES owner(owner_id)
);

/* Step 4  INSERT */

-- insert values into owner table and show
INSERT INTO owner (owner_id, owner_name, owner_city) VALUES
(1, 'Maria Lopez', 'Turlock'),
(2, 'James Chen', 'Modesto'),
(3, 'Priya Singh', 'Ceres'),
(4, 'Alyssa Splitstone', 'Modesto');

SELECT * FROM owner;

-- insert values into pet table and show

INSERT INTO pet (pet_id, pet_name, owner_id) VALUES
(1, 'Bella', 1),
(2, 'Max', 1),
(3, 'Luna', 2),
(4, 'Rocky', 3),
(5, 'Daisy', 3),
(6, 'Coco', 3),
(7, 'Rogue', 4),
(8, 'Maui', 4),
(9, 'Kittle', 4),
(10, 'Finnigan', 4);

SELECT * FROM pet;

/* Step 5  JOIN */
-- join the two tables to show all the columns with the owner_id
SELECT o.owner_id, o.owner_name, o.owner_city, p.pet_name
FROM owner o
   JOIN pet p ON o.owner_id = p.owner_id;
/* ================================================================
   PROBLEM 2  Apartment buildings and units             (2 points)
   ================================================================

   A property manager keeps one table named building_unit.
   Unit numbers repeat across buildings (every building has a 101),
   so the primary key is (building_id, unit_number).

     building_id, unit_number, building_name, building_address,
     bedrooms, monthly_rent

   Sample rows:

   building_id | unit_number | building_name | building_address  | bedrooms | monthly_rent
   ============+=============+===============+===================+==========+=============
   B1          | 101         | Oak Terrace   | 100 Oak St        | 1        | 1250.00
   B1          | 102         | Oak Terrace   | 100 Oak St        | 2        | 1600.00
   B2          | 101         | Canal Court   | 45 Canal Dr       | 2        | 1550.00
   B2          | 201         | Canal Court   | 45 Canal Dr       | 3        | 1900.00

   Hint: look at which columns need BOTH key columns and which
   need only one of them.

   Use these table names:  building, apartment_unit

   Step 1  DIAGNOSE:
building_unit goes against 2NF because building_name and building_address depend only
on building_id which is a partial dependency 

   Step 2  DESIGN:
TABLE building COLUMNS building_id, building_name, building_address, KEYS PK building_id 

TABLE apartment_unit COLUMNS building_id, unit_number, bedrooms, monthly_rent KEYS PK, FK building_id, PK unit_number

*/

/* Step 3  CREATE */
-- create a building and apartment_unit table
CREATE TABLE building(
   building_id VARCHAR(5) NOT NULL PRIMARY KEY,
   building_name VARCHAR(40),
   building_address  VARCHAR(40)
);

CREATE TABLE apartment_unit(
   building_id VARCHAR(5),
   unit_number INT,
   bedrooms INT,
   monthly_rent   DECIMAL(8,2),
   PRIMARY KEY(building_id, unit_number),
   FOREIGN KEY(building_id) REFERENCES building(building_id)
);
/* Step 4  INSERT */
-- INSERT ALL THE VALUES INTO THE TABLES and show

INSERT INTO building (building_id, building_name, building_address) VALUES
('B1', 'Oak Terrace', '100 Oak St'),
('B2', 'Canal Court', '45 Canal Dr');

SELECT * FROM building;

INSERT INTO apartment_unit (building_id, unit_number, bedrooms, monthly_rent) VALUES
('B1', 101, 1, 1250.00),
('B1', 102, 2, 1600.00),
('B2', 101, 2, 1550.00),
('B2', 201, 3, 1900.00);

SELECT * FROM apartment_unit;

/* Step 5  JOIN */
-- joins the two tables using building_id
SELECT b.building_id, b.building_name, b.building_address, a.unit_number, a.bedrooms, a.monthly_rent
FROM building b
   JOIN apartment_unit a ON b.building_id = a.building_id;


/* ================================================================
   PROBLEM 3  Employees and departments                 (2 points)
   ================================================================

   A company keeps one table named employee_info.
   The primary key is emp_id.

     emp_id, emp_name, hire_year, dept_id, dept_name, dept_phone

   Sample rows:

   emp_id | emp_name      | hire_year | dept_id | dept_name  | dept_phone
   =======+===============+===========+=========+============+=============
   E01    | Linda Park    | 2019      | D10     | Accounting | 209.555.0300
   E02    | Raj Mehta     | 2021      | D20     | Marketing  | 209.555.0400
   E03    | Carlos Vega   | 2022      | D10     | Accounting | 209.555.0300
   E04    | Emma Wilson   | 2024      | D20     | Marketing  | 209.555.0400

   Accounting gets a new phone number. How many rows must change?
   What happens to the Marketing department if Raj and Emma both quit?

   Use these table names:  department, employee

   Step 1  DIAGNOSE:
2 rows would change with an update and all information would disappear if they quit.
This ges against 3NF because there is a transitive dependency

   Step 2  DESIGN:
TABLE department COLUMNS dept_id, dept_name, dept_phone KEYS PK dept_id
TABLE employee COLUMNS emp_id, emp_name, hire_year, dept_id KEYS PK emp_id FK dept_id

*/

/* Step 3  CREATE */
-- create department and employee tables
CREATE TABLE department(
   dept_id  VARCHAR(10) NOT NULL PRIMARY KEY,
   dept_name   VARCHAR(30),
   dept_phone  VARCHAR(15)
);

CREATE TABLE employee(
   emp_id   VARCHAR(10) NOT NULL PRIMARY KEY,
   emp_name VARCHAR(40),
   hire_year   INT,
   dept_id  VARCHAR (10),
   FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);
/* Step 4  INSERT */
-- insert the values into the tables and show it

INSERT INTO department (dept_id, dept_name, dept_phone) VALUES
('D10', 'Accounting', '209.555.0300'),
('D20', 'Marketing', '209.555.0400');
SELECT * FROM department;

INSERT INTO employee (emp_id, emp_name, hire_year, dept_id) VALUES
('E01', 'Linda Park', 2019, 'D10'),
('E02', 'Raj Mehta', 2021, 'D20'),
('E03', 'Carlos Vega', 2022, 'D10'),
('E04', 'Emma Wilson', 2024, 'D20');
SELECT * FROM employee;
/* Step 5  JOIN */
-- joins the two tables using the dept_id
SELECT d.dept_id, d.dept_name, d.dept_phone, e.emp_id, e.emp_name, e.hire_year
FROM department d
   JOIN employee e ON d.dept_id = e.dept_id;

/* ================================================================
   PROBLEM 4  Students and courses                     (2.5 points)
              This problem REQUIRES a bridge table with a
              composite primary key.
   ================================================================

   A college keeps one table named student_course.
   One student takes many courses, and one course has many students.

     student_id, student_name, student_major, course_id,
     course_name, course_description, units, grade

   Sample rows:

   student_id | student_name | student_major | course_id | course_name        | course_description                 | units | grade
   ===========+==============+===============+===========+====================+====================================+=======+======
   S100       | Ana Torres   | CIS           | CIS4720   | Database Mgmt      | Relational design and SQL          | 3     | A
   S100       | Ana Torres   | CIS           | CIS2000   | Intro to Python    | Programming fundamentals in Python | 3     | B
   S200       | Ben Shah     | Business      | CIS4720   | Database Mgmt      | Relational design and SQL          | 3     | B
   S300       | Chloe Nguyen | CIS           | CIS2000   | Intro to Python    | Programming fundamentals in Python | 3     | A

   Questions to think about:
     Which columns describe only the STUDENT?
     Which columns describe only the COURSE?
     Which column describes "this student in this course"?

   Use these table names:  student, course, enrollment
   enrollment is the bridge table. Its primary key must be the
   composite key (student_id, course_id), and each of those columns
   must also be a foreign key.

   Step 1  DIAGNOSE:
The student_id is a partial dependency but the grade depends on the student_id and course_id

   Step 2  DESIGN:
TABLE student COLUMNS student_id, student_name, student_major KEY PK student_id
TABLE course COLUMNS course_id, course_name, course_description, units KEY PK course_id 
TABLE enrollment COLUMNS student_id, course_id, grade KEY PK (student_id, course_id) FK student_id FK course_id
*/

/* Step 3  CREATE */
-- create the student, course and enrollment tables
CREATE TABLE student(
   student_id  VARCHAR(10) NOT NULL PRIMARY KEY,
   student_name VARCHAR(40),
   student_major  VARCHAR(30)
);

CREATE TABLE course(
   course_id VARCHAR(10) NOT NULL PRIMARY KEY,
   course_name VARCHAR(50),
   course_description VARCHAR(100),
   units INT
);

CREATE TABLE enrollment(
   student_id  VARCHAR(10) NOT NULL,
   course_id   VARCHAR(10),
   grade VARCHAR(2),
   PRIMARY KEY (student_id, course_id),
   FOREIGN KEY (student_id) REFERENCES student(student_id),
   FOREIGN KEY (course_id) REFERENCES course(course_id)
);
/* Step 4  INSERT
   Enroll at least one student in two courses, and put at least two
   students in the same course, so the many to many relationship shows. */
-- insert all of the original data into the right tables and show

INSERT INTO student (student_id, student_name, student_major) VALUES
('S100', 'Ana Torres', 'CIS'),
('S200', 'Ben Shah', 'Business'),
('S300', 'Chloe Nguyen', 'CIS');
SELECT * FROM student;

INSERT INTO course (course_id, course_name, course_description, units) VALUES
('CIS4720', 'Database Mgmt', 'Relational design and SQL', 3),
('CIS2000', 'Intro to Python', 'Programming fundamentals in Python', 3);
SELECT * FROM course;

INSERT INTO enrollment (student_id, course_id, grade) VALUES
('S100', 'CIS4720', 'A'),
('S100', 'CIS2000', 'B'),
('S200', 'CIS4720', 'B'),
('S300', 'CIS2000', 'A');
SELECT * FROM enrollment;

/* Step 5  JOIN  (three tables: student, enrollment, course) */
-- join all the tables together using the enrollment table as a bridge

SELECT s.student_id, s.student_name, s.student_major, c.course_id, c.course_name, c.course_description, c.units, e.grade
FROM student s
JOIN enrollment e ON e.student_id = s.student_id
JOIN course c ON e.course_id = c.course_id;