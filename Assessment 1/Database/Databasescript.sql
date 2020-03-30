--BEFORE RUNNING PLEASE READ
-- Run script from line 24 onwards down for first push to local db
-- All subsequent builds of this script just run the drop tables will remove all tables and add them 
-- Add the end of running this script there will be a select statement for each table showing data which is in them on a successful build
-- This must be run befor running the trigger or stored Procedure
DROP TABLE StudentRegistersInCourse
DROP TABLE StudentEnrolment
DROP TABLE TimeSlot
DROP TABLE CourseOffering
DROP TABLE TimePeriod
DROP TABLE CourseAcademicProgrammeAssignment
DROP Table Prerequisite
DROP TABLE Course
DROP TABLE ProgramConvenor
DROP TABLE MajorMinorCondition
DROP TABLE MajorMinor
DROP TABLE AcademicProgramme
DROP TABLE DepartmentAssignment
DROP TABLE Department
DROP TABLE Person
DROP TABLE Room
DROP TABLE Facility
DROP TABLE Campus
DROP TABLE Address
DROP TABLE Postcode

CREATE TABLE Postcode
(
	suburb CHAR(50) NOT NULL, 
	state CHAR(50) NOT NULL, 
	country CHAR(50) NOT NULL,
	postcode INTEGER NOT NULL
	Primary key (country, state, suburb)
)
GO

CREATE TABLE Address
(
	addressId INTEGER NOT NULL IDENTITY(1,1),
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


CREATE TABLE Campus
(
	campusId INTEGER NOT NULL IDENTITY(1,1), 
	name VARCHAR(MAX) NOT NULL, 
	addressId INTEGER
	Primary Key (campusId)
	Foreign Key (addressId) references Address(addressId) ON UPDATE NO ACTION ON DELETE NO ACTION
)
GO

CREATE TABLE Facility
(
	facilityId INTEGER NOT NULL IDENTITY(1,1), 
	name VARCHAR(MAX) NOT NULL, 
	campusId INTEGER NOT NULL
	Primary Key (facilityId)
	Foreign Key (campusId) references Campus(campusId) ON UPDATE NO ACTION ON DELETE NO ACTION
)
GO

CREATE TABLE Room
(
	roomNumber INTEGER NOT NULL IDENTITY(1,1), 
	facilityId INTEGER NOT NULL, 
	capacity INTEGER,
	roomType VARCHAR(MAX)
	Primary Key (roomNumber, facilityId)
	Foreign Key (facilityId) references Facility(facilityId) ON UPDATE NO ACTION ON DELETE NO ACTION
)
GO

CREATE TABLE Person
(
	personId INTEGER NOT NULL IDENTITY(1,1), 
	firstName VARCHAR(MAX) NOT NULL, 
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

CREATE TABLE Department(
	departmentId INTEGER NOT NULL IDENTITY(1,1), 
	name VARCHAR(MAX) NOT NULL, 
	description VARCHAR(MAX), 
	contactNumber INTEGER,
	subDepartmentOf INTEGER
	Primary Key (departmentId)
)
GO

CREATE TABLE DepartmentAssignment
(
	personId INTEGER NOT NULL, 
	departmentId INTEGER NOT NULL, 
	startDate DATETIME NOT NULL, 
	endDate DATETIME, 
	role VARCHAR(MAX)
	Primary Key (personId, departmentId, startDate)
	Foreign Key (departmentId) references Department(departmentId) ON UPDATE NO ACTION ON DELETE NO ACTION,
	Foreign Key (personId) references Person(personId)ON UPDATE CASCADE ON DELETE CASCADE
)
GO

CREATE TABLE AcademicProgramme
(
	academicProgrammeId INTEGER NOT NULL IDENTITY(1,1), 
	name VARCHAR(MAX) NOT NULL,
	programTotalCredits INTEGER, 
	level VARCHAR(MAX), 
	certificationAcheived VARCHAR(MAX)
	Primary Key (academicProgrammeId)
)
GO

CREATE TABLE MajorMinor
(
	code INTEGER NOT NULL IDENTITY(1,1),
	academicProgrammeId INTEGER NOT NULL,
	name VARCHAR(MAX) NOT NULL, 
	description VARCHAR(MAX), 
	totalCredits INTEGER NOT NULL 
	Primary Key (code)
	Foreign Key (academicProgrammeId) references AcademicProgramme(academicProgrammeId) ON UPDATE NO ACTION ON DELETE CASCADE
)
Go

CREATE TABLE MajorMinorCondition
(
	code INTEGER,
	conditionId INTEGER NOT NULL IDENTITY(1,1),
	condition VARCHAR(MAX)
	Primary Key (code,conditionId)
	Foreign Key (code) references MajorMinor(code) ON UPDATE NO ACTION ON DELETE CASCADE
)
GO

CREATE TABLE ProgramConvenor
(
	personId INTEGER NOT NULL, 
	academicProgrammeId INTEGER NOT NULL, 
	startDate DATETIME , 
	endDate DATETIME
	Primary Key (personId, academicProgrammeId, startDate)
	Foreign Key (personId) references Person(personId) ON UPDATE NO ACTION ON DELETE NO ACTION,
	Foreign Key (academicProgrammeId) references AcademicProgramme(academicProgrammeId) ON UPDATE NO ACTION ON DELETE NO ACTION
)
GO

CREATE TABLE Course
(
	courseId INTEGER IDENTITY(1,1), 
	name VARCHAR(MAX), 
	numberOfcredits INTEGER, 
	description VARCHAR(MAX)
	Primary Key (courseId)
)
GO

CREATE TABLE Prerequisite(
	courseId INTEGER NOT NULL,
	PrereqId INTEGER NOT NULL
	Primary Key (courseId, PrereqId)
	Foreign Key (courseId) references Course ON UPDATE  NO ACTION ON DELETE CASCADE,
	Foreign Key (PrereqId) references Course ON UPDATE  NO ACTION ON DELETE NO ACTION
)
GO

CREATE TABLE CourseAcademicProgrammeAssignment
(
	courseId INTEGER NOT NULL, 
	academicProgrammeId INTEGER NOT NULL , 
	startDate DATETIME, 
	endDate DATETIME, 
	type VARCHAR(MAX) NOT NULL
	Primary Key (courseId, academicProgrammeId, startDate)
	Foreign Key (courseId) references Course(courseId) ON UPDATE NO ACTION ON DELETE CASCADE,
	Foreign Key (academicProgrammeId) references AcademicProgramme(academicProgrammeId) ON UPDATE NO ACTION ON DELETE CASCADE
)
GO



CREATE TABLE TimePeriod
(	
	timePeriodId INTEGER NOT NULL, 
	year INTEGER NOT NULL, 
	semesterTrimesterNumber INTEGER NOT NULL,
	isSemester BIT NOT NULL
	Primary Key (timePeriodId)
)
GO

CREATE TABLE CourseOffering
(
	courseId INTEGER NOT NULL, 
	timePeriodId INTEGER NOT NULL, 
	campusId INTEGER NOT NULL, 
	courseCoordinator INTEGER  NOT NULL
	Primary Key (courseId, timePeriodId, campusId)
	Foreign Key (courseId) references Course(courseId)ON UPDATE NO ACTION ON DELETE CASCADE,
	Foreign Key (campusId) references Campus(campusId)ON UPDATE NO ACTION ON DELETE CASCADE,
	Foreign Key (timePeriodId) references TimePeriod(timePeriodId)ON UPDATE NO ACTION ON DELETE CASCADE,
	Foreign Key (courseCoordinator) references Person(personId)ON UPDATE NO ACTION ON DELETE CASCADE
)
GO



CREATE TABLE TimeSlot
(
	timeSlotId INTEGER NOT NULL IDENTITY(1,1), 
	day VARCHAR(MAX), 
	startTime TIME, 
	endTime TIME, 
	roomNumber INTEGER,
	facilityId INTEGER,
	teacher INTEGER, 
	courseId INTEGER,
	timePeriodId INTEGER  NOT NULL, 
	campusId INTEGER  NOT NULL 
	Primary Key (timeSlotId)
	Foreign Key (roomNumber, facilityId) references Room ON UPDATE NO ACTION ON DELETE NO ACTION,
	Foreign Key (teacher) references Person(personId)ON UPDATE NO ACTION ON DELETE NO ACTION,
	Foreign Key (courseId, timePeriodId,campusId) references CourseOffering ON UPDATE NO ACTION ON DELETE NO ACTION
)
GO

CREATE TABLE StudentEnrolment
(
	academicProgrammeId INTEGER NOT NULL , 
	personId INTEGER  NOT NULL, 
	timePeriodId INTEGER  NOT NULL, 
	enrolmentDate DATETIME  NOT NULL, 
	completionDate DATETIME
	Primary Key (academicProgrammeId, personId, timePeriodId)
	Foreign Key (timePeriodId) references TimePeriod(timePeriodId) ON UPDATE NO ACTION ON DELETE CASCADE,
	Foreign Key (personId) references Person(personId)ON UPDATE NO ACTION ON DELETE CASCADE,
	Foreign Key (academicProgrammeId) references AcademicProgramme(academicProgrammeId)ON UPDATE NO ACTION ON DELETE CASCADE
)
GO


CREATE TABLE StudentRegistersInCourse
(
	personId INTEGER NOT NULL,
	courseId INTEGER NOT NULL,
	timePeriodId INTEGER NOT NULL,
	campusId INTEGER NOT NULL,
	finalMark INTEGER, 
	finalGrade VARCHAR(MAX) 
	Primary Key (personId, courseId, timePeriodId, campusId)
	Foreign Key (personId) references Person(personId) ON UPDATE NO ACTION ON DELETE CASCADE,
	Foreign Key (courseId, timePeriodId, campusId) references CourseOffering ON UPDATE NO ACTION ON DELETE NO ACTION
)
GO

CREATE TRIGGER tr_GiveCourseAGrade
ON StudentRegistersInCourse
AFTER INSERT, UPDATE
AS
BEGIN
	DECLARE @pass INT, @credit INT, @distinction INT,@highDistinction INT, @grade INT, @personId INT, @courseId INT, @timePeriodId INT, @campusId INT
	SET @pass = 50
	SET @credit = 65
	SET @distinction = 75
	SET @highDistinction = 85

	IF @@ROWCOUNT =0 
    RETURN

	SELECT @grade = finalMark FROM inserted
	SELECT @personId = personId FROM inserted
	SELECT @courseId = courseId FROM inserted
	SELECT @timePeriodId = timePeriodId FROM inserted
	SELECT @campusId = campusId FROM inserted
	PRINT 'inserted table'
	IF @grade = NULL
		BEGIN
			UPDATE StudentRegistersInCourse SET finalGrade = NULL
			WHERE StudentRegistersInCourse.personId = @personId AND
			StudentRegistersInCourse.courseId = @courseId AND
			StudentRegistersInCourse.timePeriodId = @timePeriodId AND
			StudentRegistersInCourse.campusId = @campusId;
		END
	-- Check to see if Failed
	ELSE IF @grade < @pass
		BEGIN
			UPDATE StudentRegistersInCourse SET finalGrade = 'F'
			WHERE StudentRegistersInCourse.personId = @personId AND
			StudentRegistersInCourse.courseId = @courseId AND
			StudentRegistersInCourse.timePeriodId = @timePeriodId AND
			StudentRegistersInCourse.campusId = @campusId;
		END
	-- Check to see if Passed
	ELSE IF @grade < @credit
		BEGIN
			UPDATE StudentRegistersInCourse SET finalGrade = 'P'
			WHERE StudentRegistersInCourse.personId = @personId AND
			StudentRegistersInCourse.courseId = @courseId AND
			StudentRegistersInCourse.timePeriodId = @timePeriodId AND
			StudentRegistersInCourse.campusId = @campusId;
		END
	-- Check to see if Credit
	ELSE IF @grade < @distinction
		BEGIN
			UPDATE StudentRegistersInCourse SET finalGrade = 'C'
			WHERE StudentRegistersInCourse.personId = @personId AND
			StudentRegistersInCourse.courseId = @courseId AND
			StudentRegistersInCourse.timePeriodId = @timePeriodId AND
			StudentRegistersInCourse.campusId = @campusId;
		END
	-- Check to see if Credit
	ELSE IF @grade < @highDistinction
		BEGIN
			UPDATE StudentRegistersInCourse SET finalGrade = 'D'
			WHERE StudentRegistersInCourse.personId = @personId AND
			StudentRegistersInCourse.courseId = @courseId AND
			StudentRegistersInCourse.timePeriodId = @timePeriodId AND
			StudentRegistersInCourse.campusId = @campusId;
		END
	ELSE 
		BEGIN
			UPDATE StudentRegistersInCourse SET finalGrade = 'HD'
			WHERE StudentRegistersInCourse.personId = @personId AND
			StudentRegistersInCourse.courseId = @courseId AND
			StudentRegistersInCourse.timePeriodId = @timePeriodId AND
			StudentRegistersInCourse.campusId = @campusId;
		END

END
 
GO 


/*    --- DUMMY DATA ---    */
/* Dummy Postcode */
INSERT INTO Postcode(suburb, state, country,postcode)
VALUES
	('Cooks Hill', 'New South Wales', 'Australia', 2300),
	('Newcastle', 'New South Wales', 'Australia', 2300),
	('Callaghan', 'New South Wales', 'Australia', 2308),
	('Ourimbah', 'New South Wales', 'Australia', 2258);

/* Dummy Address */
INSERT INTO Address ( unit, streetNumber, streetName, suburb, state, country)
VALUES
	(1, 257, 'Darby Street','Cooks Hill', 'New South Wales', 'Australia'),
	(NULL, 2, 'Darby Street','Cooks Hill', 'New South Wales', 'Australia'),
	(NULL, 130, 'King Street','Newcastle', 'New South Wales', 'Australia'),
	(27, 257, 'Oak Road','Newcastle', 'New South Wales', 'Australia'),
	(31, 257, 'Elm  Avenue','Newcastle', 'New South Wales', 'Australia'),
	(2, 257, 'Hill  Street','Ourimbah', 'New South Wales', 'Australia'),
	(NULL, 67, 'Lake  Street','Cooks Hill', 'New South Wales', 'Australia'),
	(NULL, 100, 'Callaghan Street', 'Callaghan', 'New South Wales', 'Australia'),
	(NULL, 200, 'Ourimbah Street', 'Ourimbah', 'New South Wales', 'Australia');

/* Dummy Campus */
INSERT INTO Campus( name, addressId)
VALUES
	('Callaghan', 1),
	('Ourimbah', 2);
INSERT INTO Campus(name)
VALUES
	('Online');

/* Dummy Facilities */
INSERT INTO Facility(name, campusId)
VALUES
	('Life Sciences', 1),
	('Computer Sciences', 1),
	('library', 1),
	('library', 2),
	('Computer Sciences', 2);

/* Dummy Rooms */
INSERT INTO Room ( facilityId , capacity, roomType)
VALUES
	(1 , 150, 'Lecture Hall'),
	(2 , 150, 'Lecture Hall'),
	(5 , 150, 'Lecture Hall'),
	(3 , 10, 'Group Room'),
	(3 , 10, 'Group Room'),
	(3 , 10, 'Group Room'),
	(4 , 10, 'Group Room');

/* Dummy People */
INSERT INTO Person
(firstName, lastName, contactNumber, qualification, highestCurrentEducation, isStudent, isStaff, addressId)
VALUES 
	('Collin', 'Smith', 0411223344, NULL, 'highschool', 1, 0, 1),
	('Amy', 'Creek', 0411223341, NULL, 'highschool', 1, 0, 2),
	('Tim', 'Ham', 0411223342, NULL, 'highschool', 1, 0, 3),
	('Holly', 'McDonald', 0411223343, NULL, 'highschool', 1, 0, 4),
	('James', 'McDonald', 0434321409, NULL, 'highschool', 1, 0, 4),
	('Teacher', 'One', 0411223341, 'phd', NULL, 0, 1, 5),
	('Teacher', 'Two', 0411223342, 'masters', NULL, 0, 1, 6),
	('Teacher', 'Three', 0411223343, 'phd', NULL, 0, 1, 7);

/* Dummy Department */
INSERT INTO Department( name, description, contactNumber, subDepartmentOf)
VALUES
	('Computer Science','a description', 0434321409, NULL),
	('Information Technology','a description', 0434321401, 1),
	('Computer Engineering','a description', 0434321403, 1),
	('Business','a description', 0434321509, NULL),
	('Satistics','a description', 0434321709, 4),
	('Finance','a description', 0434321809, 4);

/* Dummy DepartmentAssignment */
INSERT INTO DepartmentAssignment(personId, departmentId, startDate, endDate, role)
VALUES
	(5,1,2020-01-31, NULL, 'Department Head'),
	(5,2,2020-01-31, NULL, 'Department Head'),
	(6,3,2020-01-31, NULL, 'Department Head'),
	(7,4,2020-01-31, NULL, 'Department Head');

/* Dummy AcademicProgramme */
INSERT INTO AcademicProgramme( name, programTotalCredits, level, certificationAcheived)
VALUES
	('Computer Sceince', 50, 'Bachelor of Science','Bachelor'),
	('Information Technology', 50, 'Bachelor of Science','Bachelor'),
	('Computer Sceince', 25, 'Masters of Computer Sceince','MSc'),
	('Computer Sceince', 15, 'PhD','PhD');

/* Dummy MajorMinor */
	INSERT INTO MajorMinor(academicProgrammeId, name, description, totalCredits)
	VALUES
	(1,'CYBER SECURITY','a',50),
	(1,'COMPUTER SYSTEMS & ROBOTICS','a',50),
	(1,'DATA SCIENCE','a',50),
	(1,'SOFTWARE DEVELOPMENT','a',50),
	(2,'SYSTEMS DEVELOPMENT','a',50),
	(2,'INTERACTIVE MEDIA','a',50),
	(2,'BUSINESS TECHNOLOGY ','a',50);

/* Dummy MajorMinorCondition */
INSERT INTO MajorMinorCondition(code, condition)
VALUES
	(1,'Some Condition1'),
	(1,'Some Condition2'),
	(2,'Some Condition3'),
	(2,'Some Condition4'),
	(3,'Some Condition5');

/* Dummy ProgramConvenor */
INSERT INTO ProgramConvenor(personId, academicProgrammeId, startDate, endDate)
VALUES
	(1,1,2020-01-31,NULL),
	(2,3,2020-01-31,NULL),
	(3,1,2020-01-31,NULL),
	(4,2,2020-01-31,NULL);

/* Dummy Course */
INSERT INTO Course(name, numberOfcredits, description)
VALUES
	('Database 101', 10, 'a description'),
	('Basic IT', 10, 'a description'),
	('Advanced Database', 10, 'a description'),
	('Web Technologies', 10, 'a description'),
	('Project Managment', 10, 'a description');

/* Dummy Prerequisite */
INSERT INTO Prerequisite(courseId, PrereqId)
VALUES 
	(3, 1),
	(3, 2);

/* Dummy CourseAcademicProgrammeAssignment */
INSERT INTO CourseAcademicProgrammeAssignment(courseId, academicProgrammeId, startDate, endDate, type)
VALUES
	(1,1,2020-01-31,NULL,'Directed'),
	(1,2,2020-01-31,NULL,'Directed'),
	(1,3,2020-01-31,NULL,'Directed'),
	(2,1,2020-01-31,NULL,'Directed'),
	(2,2,2020-01-31,NULL,'Directed'),
	(2,3,2020-01-31,NULL,'Directed');

/* Dummy TimePeriod */
INSERT INTO TimePeriod(timePeriodId, year, semesterTrimesterNumber,isSemester)
VALUES 
	(1, 2020, 1, 1),
	(2, 2020, 2, 1),
	(3, 2020, 1, 0),
	(4, 2020, 2, 0);

/* Dummy CourseOffering */
INSERT INTO CourseOffering(courseId, timePeriodId, campusId, courseCoordinator)
VALUES 
	(1, 1, 1, 5),
	(2, 1, 1, 6),
	(3, 1, 1, 7);

/* Dummy TimeSlot */
INSERT INTO TimeSlot( day, startTime, endTime, roomNumber, facilityId, teacher, courseId,timePeriodId,campusId)
VALUES
('Monday', '13:00:00', '15:00:00', 1, 1, 6, 1, 1, 1),
('Tuesday', '13:00:00', '15:00:00', 4, 3, 6, 1, 1, 1),
('Tuesday', '17:00:00', '19:00:00', 5, 3, 7, 1, 1, 1),
('Wednesday', '09:00:00', '11:00:00', 2, 2, 8, 1, 1, 1),
('Wednesday', '13:00:00', '15:00:00', 1, 1, 7, 1, 1, 1),
('Monday', '13:00:00', '15:00:00', 7, 4, 8, 2, 1, 1),
('Monday', '13:00:00', '15:00:00', 2, 2, 7, 2, 1, 1),
('Thursday', '13:00:00', '15:00:00', 4, 3, 8, 2, 1, 1),
('Thursday', '13:00:00', '15:00:00', 1, 1, 6, 2, 1, 1),
('Monday', '13:00:00', '15:00:00', 5, 3, 6, 3, 1, 1),
('Monday', '13:00:00', '15:00:00', 7, 4, 6, 3, 1, 1),
('Tuesday', '13:00:00', '15:00:00', 6, 3, 7, 3, 1, 1),
('Tuesday', '13:00:00', '15:00:00', 7, 4, 8, 3, 1, 1);

/* Dummy StudentEnrolment */
INSERT INTO StudentEnrolment(academicProgrammeId, personId, timePeriodId, enrolmentDate, completionDate)
VALUES
(1,1,1,2020-01-31,NULL),
(3,2,1,2020-01-31,NULL),
(4,3,1,2020-01-31,NULL),
(2,4,1,2020-01-31,NULL),
(1,5,1,2020-01-31,NULL),
(2,6,1,2020-01-31,NULL);

/* Dummy StudentRegistersInCourse */
INSERT INTO StudentRegistersInCourse(personId, courseId, timePeriodId, campusId, finalMark)VALUES(1,1,1,1,30); 
INSERT INTO StudentRegistersInCourse(personId, courseId, timePeriodId, campusId, finalMark)VALUES(2,1,1,1,78); 
INSERT INTO StudentRegistersInCourse(personId, courseId, timePeriodId, campusId, finalMark)VALUES(3,1,1,1,57); 
INSERT INTO StudentRegistersInCourse(personId, courseId, timePeriodId, campusId, finalMark)VALUES(4,1,1,1,49); 
INSERT INTO StudentRegistersInCourse(personId, courseId, timePeriodId, campusId, finalMark)VALUES(1,2,1,1,57); 
INSERT INTO StudentRegistersInCourse(personId, courseId, timePeriodId, campusId, finalMark)VALUES(2,2,1,1,67); 
INSERT INTO StudentRegistersInCourse(personId, courseId, timePeriodId, campusId, finalMark)VALUES(3,2,1,1,83); 
INSERT INTO StudentRegistersInCourse(personId, courseId, timePeriodId, campusId, finalMark)VALUES(4,2,1,1,66); 
INSERT INTO StudentRegistersInCourse(personId, courseId, timePeriodId, campusId, finalMark)VALUES(4,3,1,1,71); 
INSERT INTO StudentRegistersInCourse(personId, courseId, timePeriodId, campusId, finalMark)VALUES(3,3,1,1,57); 
INSERT INTO StudentRegistersInCourse(personId, courseId, timePeriodId, campusId, finalMark)VALUES(2,3,1,1,79); 
INSERT INTO StudentRegistersInCourse(personId, courseId, timePeriodId, campusId, finalMark)VALUES(1,3,1,1,96); 

--Check to make sure all tables were added correctly
SELECT * FROM StudentRegistersInCourse
SELECT * FROM StudentEnrolment
SELECT * FROM TimeSlot
SELECT * FROM CourseOffering
SELECT * FROM TimePeriod
SELECT * FROM CourseAcademicProgrammeAssignment
SELECT * FROM Prerequisite
SELECT * FROM Course
SELECT * FROM ProgramConvenor
SELECT * FROM MajorMinorCondition
SELECT * FROM MajorMinor
SELECT * FROM AcademicProgramme
SELECT * FROM DepartmentAssignment
SELECT * FROM Department
SELECT * FROM Person
SELECT * FROM Room
SELECT * FROM Facility
SELECT * FROM Campus
SELECT * FROM Address
SELECT * FROM Postcode

