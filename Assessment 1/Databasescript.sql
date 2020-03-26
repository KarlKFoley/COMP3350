DROP TABLE StudentRegistersInCourse
DROP TABLE StudentEnrolment
DROP TABLE TimeSlot
DROP TABLE CourseOffering
DROP TABLE TimePeriod
DROP TABLE CourseAcademicProgrammeAssignment
DROP TABLE Course
DROP TABLE ProgramConvenor
DROP TABLE MajorMinor
DROP TABLE AcademicProgramme
DROP TABLE DepartmentAssignment
DROP TABLE Department
DROP TABLE Person
DROP TABLE Room
DROP TABLE Facility
DROP TABLE Campus
DROP TABLE Address


CREATE TABLE Address
(
	addressId INTEGER,
	unit INTEGER, 
	streetNumber INTEGER, 
	streetName VARCHAR(MAX), 
	suburb VARCHAR(MAX), 
	states VARCHAR(MAX), 
	postcode INTEGER, 
	country VARCHAR(MAX)
	Primary Key (addressId)
)
GO

CREATE TABLE Campus
(
	campusId INTEGER, 
	name VARCHAR(MAX), 
	addressId INTEGER
	Primary Key (campusId)
	Foreign Key (addressId) references  Address(addressId) ON UPDATE NO ACTION ON DELETE NO ACTION
)
GO

CREATE TABLE Facility
(
	facilityId INTEGER, 
	name VARCHAR(MAX), 
	campusId INTEGER
	Primary Key (facilityId)
	Foreign Key (campusId) references Campus(campusId) ON UPDATE NO ACTION ON DELETE NO ACTION
)
GO

CREATE TABLE Room
(
	roomNumber INTEGER, 
	facilityId INTEGER, 
	capacity INTEGER,
	roomType VARCHAR(MAX)
	Primary Key (roomNumber, facilityId)
	Foreign Key (facilityId) references Facility(facilityId) ON UPDATE NO ACTION ON DELETE NO ACTION
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

CREATE TABLE Department(
	departmentId INTEGER, 
	name VARCHAR(MAX), 
	description VARCHAR(MAX), 
	contactNumber INTEGER
	Primary Key (departmentId)
)
GO

CREATE TABLE DepartmentAssignment
(
	personId INTEGER, 
	departmentId INTEGER, 
	startDate DATETIME, 
	endDate DATETIME, 
	role VARCHAR(MAX)
	Primary Key (personId, departmentId, startDate)
	Foreign Key (departmentId) references Department(departmentId) ON UPDATE NO ACTION ON DELETE NO ACTION,
	Foreign Key (personId) references Person(personId)ON UPDATE CASCADE ON DELETE CASCADE
)
GO

CREATE TABLE AcademicProgramme
(
	academicProgrammeId INTEGER, 
	name VARCHAR(MAX),
	programTotalCredits INTEGER, 
	level VARCHAR(MAX), 
	certificationAcheived VARCHAR(MAX)
	Primary Key (academicProgrammeId)
)
GO

CREATE TABLE MajorMinor
(
	code INTEGER, 
	name VARCHAR(MAX), 
	description VARCHAR(MAX), 
	totalCredits INTEGER, 
	conditions VARCHAR(MAX)
	Primary Key (code)
)
Go

--CREATE TABLE MinorConditions
--(
--	code INTEGER, 
--	condition VARCHAR(MAX)
--	Primary Key (code, condition)
--)
--GO

CREATE TABLE ProgramConvenor
(
	personId INTEGER, 
	academicProgrammeId INTEGER, 
	startDate DATETIME, 
	endDate DATETIME
	Primary Key (personId, academicProgrammeId, startDate)
	Foreign Key (personId) references Person(personId) ON UPDATE NO ACTION ON DELETE NO ACTION,
	Foreign Key (academicProgrammeId) references AcademicProgramme(academicProgrammeId) ON UPDATE NO ACTION ON DELETE NO ACTION
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

CREATE TABLE CourseAcademicProgrammeAssignment
(
	courseId INTEGER, 
	academicProgrammeId INTEGER, 
	startDate DATETIME, 
	endDate DATETIME, 
	type VARCHAR(MAX)
	Primary Key (courseId, academicProgrammeId, startDate)
	Foreign Key (courseId) references Course(courseId) ON UPDATE NO ACTION ON DELETE CASCADE,
	Foreign Key (academicProgrammeId) references AcademicProgramme(academicProgrammeId) ON UPDATE NO ACTION ON DELETE CASCADE
)
GO



CREATE TABLE TimePeriod
(	
	timePeriodId INTEGER, 
	year INTEGER, 
	type VARCHAR(MAX), 
	semester BIT
	Primary Key (timePeriodId)
)
GO

CREATE TABLE CourseOffering
(
	courseId INTEGER,
	timePeriodId INTEGER, 
	campusId INTEGER, 
	courseCoordinator INTEGER
	Primary Key (courseId, timePeriodId, campusId)
	Foreign Key (courseId) references Course(courseId)ON UPDATE NO ACTION ON DELETE CASCADE,
	Foreign Key (campusId) references Campus(campusId)ON UPDATE NO ACTION ON DELETE CASCADE,
	Foreign Key (timePeriodId) references TimePeriod(timePeriodId)ON UPDATE NO ACTION ON DELETE CASCADE,
	Foreign Key (courseCoordinator) references Person(personId)ON UPDATE NO ACTION ON DELETE CASCADE
)
GO



CREATE TABLE TimeSlot
(
	timeSlotId INTEGER, 
	day VARCHAR(MAX), 
	startTime INTEGER, 
	endTime INTEGER, 
	roomNumber INTEGER,
	facilityId INTEGER,
	personId INTEGER, 
	courseId INTEGER,
	timePeriodId INTEGER, 
	campusId INTEGER
	Primary Key (timeSlotId)
	--Foreign Key (roomNumber, facilityId) references Room(roomNumber, facilityId) ON UPDATE NO ACTION ON DELETE NO ACTION,
	Foreign Key (personId) references Person(personId)ON UPDATE NO ACTION ON DELETE NO ACTION,
	--Foreign Key (courseId, timePeriodId,campusId) references CourseOffering(courseId, timePeriodId,campusId)ON UPDATE NO ACTION ON DELETE NO ACTION
)
GO

CREATE TABLE StudentEnrolment
(
	academicProgrammeId INTEGER, 
	personId INTEGER, 
	timePeriodId INTEGER, 
	enrolmentDate DATETIME, 
	completionDate DATETIME
	Primary Key (academicProgrammeId, personId, timePeriodId)
	Foreign Key (timePeriodId) references TimePeriod(timePeriodId) ON UPDATE NO ACTION ON DELETE CASCADE,
	Foreign Key (personId) references Person(personId)ON UPDATE NO ACTION ON DELETE CASCADE,
	Foreign Key (academicProgrammeId) references AcademicProgramme(academicProgrammeId)ON UPDATE NO ACTION ON DELETE CASCADE
)
GO


CREATE TABLE StudentRegistersInCourse
(
	personId INTEGER,
	courseId INTEGER, 
	timePeriodId INTEGER, 
	finalMark INTEGER, 
	finalGrade VARCHAR(MAX)
	Primary Key (personId, courseId, timePeriodId)
	Foreign Key (personId) references Person(personId) ON UPDATE NO ACTION ON DELETE CASCADE,
	Foreign Key (courseId) references Course(courseId)ON UPDATE NO ACTION ON DELETE CASCADE,
	Foreign Key (timePeriodId) references TimePeriod(timePeriodId)ON UPDATE NO ACTION ON DELETE CASCADE
)







SELECT *
FROM StudentRegistersInCourse
SELECT *
FROM  StudentEnrolment
SELECT *
FROM  TimeSlot
SELECT *
FROM  CourseOffering
SELECT *
FROM  TimePeriod
SELECT *
FROM  CourseAcademicProgrammeAssignment
SELECT *
FROM  Course
SELECT *
FROM  ProgramConvenor
SELECT *
FROM  MajorMinor
SELECT *
FROM  AcademicProgramme
SELECT *
FROM  DepartmentAssignment
SELECT *
FROM  Department
SELECT *
FROM  Person
SELECT *
FROM  Room
SELECT *
FROM  Facility
SELECT *
FROM  Campus
SELECT *
FROM  Address

