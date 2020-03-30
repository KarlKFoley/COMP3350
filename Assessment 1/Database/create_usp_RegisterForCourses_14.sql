CREATE TYPE courseListForStudentType AS TABLE (courseId INT, timePeriodId INT, campusId INT);CREATE PROCEDURE usp_RegisterForCourses	@list_of_Courses courseListForStudentType READONLY,
	@stdNo INT, @noCourses VARCHAR(MAX) OUTPUT
AS
BEGIN
	INSERT INTO StudentRegistersInCourse(personId, courseId, timePeriodId, campusId)  
	VALUES(@stdNo, @list_of_Courses)
END
GODROP PROCEDURE usp_RegisterForCourses