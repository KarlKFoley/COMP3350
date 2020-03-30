/*
Inserts all current course oferrings for a given student number.
Change student number at the set statment if you want to insert a different student use IDs from 1-5 teacher ids will not pass correctly
*/
-- 1. Remove current values in StudentRegistersInCourse for testing

DELETE FROM StudentRegistersInCourse


/*
2. Inserts a couse that has a precequist that was not been forfilled this will fail and give error messages
*/

DECLARE @courseOfferingsToRegisterIn AS courseListForStudentType;

INSERT INTO @courseOfferingsToRegisterIn (courseId, timePeriodId, campusId)
VALUES(3,1,1);

SELECT *
FROM @courseOfferingsToRegisterIn

DECLARE @StudentNumber INT
SET @StudentNumber = 2

EXEC usp_RegisterForCourses @StudentNumber, @courseOfferingsToRegisterIn;


SELECT *
FROM StudentRegistersInCourse

--Only run to clear table - before moving onto next use case
DELETE StudentRegistersInCourse

/*
3. Inserts 2 couse that have no precequist so added correctly
*/

DECLARE @courseOfferingsToRegisterIn AS courseListForStudentType;

INSERT INTO @courseOfferingsToRegisterIn (courseId, timePeriodId, campusId)
VALUES
(1,1,1),
(2,1,1);

DECLARE @StudentNumber INT
SET @StudentNumber = 2

EXEC usp_RegisterForCourses @StudentNumber, @courseOfferingsToRegisterIn;


SELECT *
FROM StudentRegistersInCourse


/*
4. Inserts a couse that has a precequist that was not been forfilled this will fail and give error messages
Also insert a course that has no precequists after this will be inserted
*/

DECLARE @courseOfferingsToRegisterIn AS courseListForStudentType;

INSERT INTO @courseOfferingsToRegisterIn (courseId, timePeriodId, campusId)
VALUES
(3,1,1),
(2,1,1);

DECLARE @StudentNumber INT
SET @StudentNumber = 3

EXEC usp_RegisterForCourses @StudentNumber, @courseOfferingsToRegisterIn;


SELECT *
FROM StudentRegistersInCourse

/*
5. Inserts a couse that has a already been registered for this will not work it will give an error
*/

DECLARE @courseOfferingsToRegisterIn AS courseListForStudentType;

INSERT INTO @courseOfferingsToRegisterIn (courseId, timePeriodId, campusId)
VALUES
(2,1,1);

DECLARE @StudentNumber INT
SET @StudentNumber = 3

EXEC usp_RegisterForCourses @StudentNumber, @courseOfferingsToRegisterIn;


SELECT *
FROM StudentRegistersInCourse