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
	name VARCHAR(MAX) NOT NULL, 
	description VARCHAR(MAX), 
	totalCredits INTEGER NOT NULL, 
	Primary Key (code)
)
Go

CREATE TABLE MajorMinorCondition
(
	code INTEGER NOT NULL IDENTITY(1,1),
	conditionId INTEGER,
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
	type VARCHAR(MAX)
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
	startTime INTEGER, 
	endTime INTEGER, 
	roomNumber INTEGER,
	facilityId INTEGER,
	personId INTEGER, 
	courseId INTEGER,
	timePeriodId INTEGER  NOT NULL, 
	campusId INTEGER  NOT NULL 
	Primary Key (timeSlotId)
	Foreign Key (roomNumber, facilityId) references Room ON UPDATE NO ACTION ON DELETE NO ACTION,
	Foreign Key (personId) references Person(personId)ON UPDATE NO ACTION ON DELETE NO ACTION,
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
	finalMark INTEGER, 
	finalGrade VARCHAR(MAX) 
	Primary Key (personId, courseId, timePeriodId)
	Foreign Key (personId) references Person(personId) ON UPDATE NO ACTION ON DELETE CASCADE,
	Foreign Key (courseId) references Course(courseId)ON UPDATE NO ACTION ON DELETE CASCADE,
	Foreign Key (timePeriodId) references TimePeriod(timePeriodId)ON UPDATE NO ACTION ON DELETE CASCADE
)


/*    --- DUMMY DATA ---    */
/* Dummy Postcode */
INSERT INTO Postcode(suburb, state, country,postcode)
VALUES
('Cooks Hill', 'New South Wales', 'Australia', 2300);



INSERT INTO Address ( unit, streetNumber, streetName, suburb, state, country)
VALUES
(1, 257, 'Darby St','Cooks Hill', 'New South Wales', 'Australia');


CREATE TABLE Address(streetNumber, streetName, suburb, state, country)
VALUES
( streetNumber, streetName, suburb, state, country);

CREATE TABLE Campus
(
	campusId INTEGER NOT NULL, 
	name VARCHAR(MAX) NOT NULL, 
	addressId INTEGER
	Primary Key (campusId)
	Foreign Key (addressId) references Address(addressId) ON UPDATE NO ACTION ON DELETE NO ACTION
)
GO

CREATE TABLE Facility
(
	facilityId INTEGER NOT NULL, 
	name VARCHAR(MAX) NOT NULL, 
	campusId INTEGER NOT NULL
	Primary Key (facilityId)
	Foreign Key (campusId) references Campus(campusId) ON UPDATE NO ACTION ON DELETE NO ACTION
)
GO

CREATE TABLE Room
(
	roomNumber INTEGER NOT NULL, 
	facilityId INTEGER NOT NULL, 
	capacity INTEGER,
	roomType VARCHAR(MAX)
	Primary Key (roomNumber, facilityId)
	Foreign Key (facilityId) references Facility(facilityId) ON UPDATE NO ACTION ON DELETE NO ACTION
)
GO

CREATE TABLE Person
(
	personId INTEGER NOT NULL, 
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
	departmentId INTEGER NOT NULL, 
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
	academicProgrammeId INTEGER NOT NULL, 
	name VARCHAR(MAX) NOT NULL,
	programTotalCredits INTEGER, 
	level VARCHAR(MAX), 
	certificationAcheived VARCHAR(MAX)
	Primary Key (academicProgrammeId)
)
GO

CREATE TABLE MajorMinor
(
	code INTEGER NOT NULL, 
	name VARCHAR(MAX) NOT NULL, 
	description VARCHAR(MAX), 
	totalCredits INTEGER NOT NULL, 
	Primary Key (code)
)
Go

CREATE TABLE MajorMinorCondition
(
	code INTEGER NOT NULL,
	conditionId INTEGER,
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
	courseId INTEGER, 
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
	type VARCHAR(MAX)
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
	timeSlotId INTEGER NOT NULL, 
	day VARCHAR(MAX), 
	startTime INTEGER, 
	endTime INTEGER, 
	roomNumber INTEGER,
	facilityId INTEGER,
	personId INTEGER, 
	courseId INTEGER,
	timePeriodId INTEGER  NOT NULL, 
	campusId INTEGER  NOT NULL 
	Primary Key (timeSlotId)
	Foreign Key (roomNumber, facilityId) references Room ON UPDATE NO ACTION ON DELETE NO ACTION,
	Foreign Key (personId) references Person(personId)ON UPDATE NO ACTION ON DELETE NO ACTION,
	Foreign Key (courseId, timePeriodId,campusId) references CourseOffering ON UPDATE NO ACTION ON DELETE NO ACTION
)
GO

CREATE TABLE StudentEnrolment
(
	academicProgrammeId INTEGER NOT NULL, 
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
	finalMark INTEGER, 
	finalGrade VARCHAR(MAX) 
	Primary Key (personId, courseId, timePeriodId)
	Foreign Key (personId) references Person(personId) ON UPDATE NO ACTION ON DELETE CASCADE,
	Foreign Key (courseId) references Course(courseId)ON UPDATE NO ACTION ON DELETE CASCADE,
	Foreign Key (timePeriodId) references TimePeriod(timePeriodId)ON UPDATE NO ACTION ON DELETE CASCADE
)



SELECT * FROM StudentRegistersInCourse
SELECT * FROM StudentEnrolment
SELECT * FROM TimeSlot
SELECT * FROM CourseOffering
SELECT * FROM TimePeriod
SELECT * FROM CourseAcademicProgrammeAssignment
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

