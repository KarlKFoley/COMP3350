DROP PROCEDURE usp_RegisterForCourses
DROP TYPE courseListForStudentType

CREATE TYPE courseListForStudentType AS TABLE (courseId INT, timePeriodId INT, campusId INT);
GO

CREATE PROCEDURE usp_RegisterForCourses
	@stdNo INT,
	@list_of_Courses courseListForStudentType READONLY
AS
BEGIN
	INSERT INTO StudentRegistersInCourse(personId, courseId, timePeriodId, campusId)
	SELECT @stdNo, *
	FROM @list_of_Courses;
END
GO



