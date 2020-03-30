DECLARE @courseOfferingsToRegisterIn AS courseListForStudentType;

INSERT @courseOfferingsToRegisterIn (courseId, timePeriodId, campusId)
   SELECT courseId, timePeriodId, campusId
   From CourseOffering;

SELECT *
FROM @courseOfferingsToRegisterIn

DECLARE @StudentNumber INT
SET @StudentNumber = 5

EXEC usp_RegisterForCourses @StudentNumber, @courseOfferingsToRegisterIn;


SELECT *
FROM StudentRegistersInCourse

DELETE StudentRegistersInCourse