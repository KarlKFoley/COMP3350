/*
Inserts all current course oferrings for a given student number.
*/

DECLARE @courseOfferingsToRegisterIn AS courseListForStudentType;

INSERT @courseOfferingsToRegisterIn (courseId, timePeriodId, campusId)
   SELECT courseId, timePeriodId, campusId
   From CourseOffering;

--SELECT *
--FROM @courseOfferingsToRegisterIn

DECLARE @StudentNumber INT
SET @StudentNumber = 4

EXEC usp_RegisterForCourses @StudentNumber, @courseOfferingsToRegisterIn;

SELECT *
FROM StudentRegistersInCourse


--Only run to clear table - allows for no clashes

DELETE StudentRegistersInCourse

/*
Inserts a couse that has a precequist that was not been forfilled this will fail and give error messages

*/

DECLARE @courseOfferingsToRegisterIn AS courseListForStudentType;

INSERT INTO @courseOfferingsToRegisterIn (courseId, timePeriodId, campusId)
VALUES(3,1,1);

SELECT *
FROM @courseOfferingsToRegisterIn

DECLARE @StudentNumber INT
SET @StudentNumber = 7

EXEC usp_RegisterForCourses @StudentNumber, @courseOfferingsToRegisterIn;


SELECT *
FROM StudentRegistersInCourse

DELETE StudentRegistersInCourse