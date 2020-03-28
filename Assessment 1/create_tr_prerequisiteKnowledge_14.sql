DROP TABLE StudentRegistersInCourse
DROP TABLE CourseOffering
DROP TABLE Person
DROP TABLE Address
DROP TABLE Campus
DROP TABLE TimePeriod
DROP TABLE Prerequisite
DROP TABLE Course
DROP TABLE Postcode









CREATE TABLE Postcode
(
	suburb CHAR(50), 
	state CHAR(50), 
	country CHAR(50),
	postcode INTEGER NOT NULL
	Primary key (country, state, suburb)
)
GO

CREATE TABLE Address
(
	addressId INTEGER,
	unit INTEGER, 
	streetNumber INTEGER NOT NULL, 
	streetName VARCHAR(MAX) NOT NULL, 
	suburb CHAR(50), 
	state CHAR(50), 
	country CHAR(50)
	Primary Key (addressId)
	Foreign Key (country, state, suburb) references Postcode ON UPDATE NO ACTION ON DELETE NO ACTION
)
GO

CREATE TABLE Course
(
	courseId INTEGER, 
	name VARCHAR(MAX), 
	numberOfcredits INTEGER, 
	description VARCHAR(MAX)
	Primary Key (courseId)
)
GO

CREATE TABLE Prerequisite
(
	prerequisite INTEGER,
	courseId INTEGER,
	Primary Key (prerequisite, courseId),
	Foreign Key (prerequisite) references Course(courseId) ON UPDATE NO ACTION ON DELETE NO ACTION,
	Foreign Key (courseId) references Course(courseId) ON UPDATE NO ACTION ON DELETE NO ACTION
)
GO

CREATE TABLE Campus
(
	campusId INTEGER, 
	name VARCHAR(MAX), 
	addressId INTEGER
	Primary Key (campusId)
	Foreign Key (addressId) references Address(addressId) ON UPDATE NO ACTION ON DELETE NO ACTION
)
GO

CREATE TABLE TimePeriod
(	
	timePeriodId INTEGER, 
	year INTEGER, 
	semesterTrimesterNumber INTEGER,
	isSemester BIT
	Primary Key (timePeriodId)
)
GO

CREATE TABLE Person
(
	personId INTEGER, 
	firstName VARCHAR(MAX), 
	lastName VARCHAR(MAX), 
	contactNumber INTEGER, 
	qualification  VARCHAR(MAX), 
	highestCurrentEducation  VARCHAR(MAX), 
	isStudent BIT, 
	isStaff BIT, 
	addressId INTEGER
	Primary Key (personId)
	Foreign Key (addressId) references Address(addressId) ON UPDATE NO ACTION ON DELETE SET NULL
)
GO

CREATE TABLE StudentRegistersInCourse
(
	personId INTEGER,
	courseId INTEGER, 
	timePeriodId INTEGER, 
	finalMark INTEGER, 
	finalGrade VARCHAR(MAX),
	Primary Key (personId, courseId, timePeriodId),
	Foreign Key (personId) references Person(personId) ON UPDATE NO ACTION ON DELETE CASCADE,
	Foreign Key (courseId) references Course(courseId) ON UPDATE NO ACTION ON DELETE CASCADE,
	Foreign Key (timePeriodId) references timePeriod(timePeriodId)ON UPDATE NO ACTION ON DELETE CASCADE
)

CREATE TABLE CourseOffering
(
	courseId INTEGER,
	timePeriodId INTEGER, 
	campusId INTEGER, 
	courseCoordinator INTEGER,
	Primary Key (courseId, timePeriodId, campusId, courseCoordinator),
	Foreign Key (courseId) references Course(courseId)ON UPDATE NO ACTION ON DELETE CASCADE,
	Foreign Key (campusId) references Campus(campusId)ON UPDATE NO ACTION ON DELETE CASCADE,
	Foreign Key (timePeriodId) references TimePeriod(timePeriodId)ON UPDATE NO ACTION ON DELETE CASCADE,
	Foreign Key (courseCoordinator) references Person(personId)ON UPDATE NO ACTION ON DELETE CASCADE
)
GO

INSERT INTO Postcode VALUES ('Callaghan', 'NSW', 'Australia', 2308);
INSERT INTO Postcode VALUES ('Ourimbah', 'NSW', 'Australia', 2258);

INSERT INTO Address VALUES (1, NULL, 100, 'Callaghan Street', 'Callaghan', 'NSW', 'Australia');
INSERT INTO Address VALUES (2, NULL, 200, 'Ourimbah Street', 'Ourimbah', 'NSW', 'Australia');

INSERT INTO Course VALUES (1, 'Database 101', 10, 'a description');
INSERT INTO Course VALUES (2, 'Basic IT', 10, 'a description');
INSERT INTO Course VALUES (3, 'Advanced Database', 10, 'a description');

INSERT INTO Prerequisite VALUES (1, 3);
INSERT INTO Prerequisite VALUES (2, 3);

INSERT INTO Campus VALUES (1,'Callaghan', 1);
INSERT INTO Campus VALUES (2, 'Ourimbah', 2);

INSERT INTO TimePeriod VALUES (1, 2020, 1, 1);

INSERT INTO Person VALUES (1, 'Collin', 'Smith', 0411223344, NULL, 'highschool', 1, 0, 1);
INSERT INTO Person VALUES (2, 'Amy', 'Creek', 0411223341, NULL, 'highschool', 1, 0, 1);
INSERT INTO Person VALUES (3, 'Tim', 'Ham', 0411223342, NULL, 'highschool', 1, 0, 1);
INSERT INTO Person VALUES (4, 'Holly', 'McDonald', 0411223343, NULL, 'highschool', 1, 0, 2);
INSERT INTO Person VALUES (5, 'Teacher', 'One', 0411223341, 'phd', NULL, 0, 1, 1);
INSERT INTO Person VALUES (6, 'Teacher', 'Two', 0411223342, 'masters', NULL, 0, 1, 1);
INSERT INTO Person VALUES (7, 'Teacher', 'Three', 0411223343, 'phd', NULL, 0, 1, 2);

INSERT INTO CourseOffering VALUES (1, 1, 1, 5);
INSERT INTO CourseOffering VALUES (2, 1, 1, 6);
INSERT INTO CourseOffering VALUES (3, 1, 1, 7);
go

SELECT * FROM Postcode
SELECT * FROM Address
SELECT * FROM Course
SELECT * FROM Prerequisite
SELECT * FROM Campus
SELECT * FROM TimePeriod
SELECT * FROM Person
SELECT * FROM StudentRegistersInCourse
SELECT * FROM CourseOffering
go

DROP TRIGGER tr_EnforceCourseRegistrationPolicy
go

CREATE TRIGGER tr_EnforceCourseRegistrationPolicy
ON StudentRegistersInCourse
FOR INSERT, UPDATE
AS
BEGIN
	IF	
		
END
go
