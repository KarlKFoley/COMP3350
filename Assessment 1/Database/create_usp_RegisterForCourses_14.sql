DROP PROCEDURE usp_RegisterForCourses
DROP TYPE courseListForStudentType

CREATE TYPE courseListForStudentType AS TABLE (courseId INT, timePeriodId INT, campusId INT);
GO

CREATE PROCEDURE usp_RegisterForCourses
	@stdNo INT,
	@list_of_Courses courseListForStudentType READONLY
AS
BEGIN
	DECLARE @personId INT, @courseId INT, @timePeriodId INT, @campusId INT
	DECLARE @ErrorVariable INT
			-- declare cursor
	DECLARE test CURSOR
	FOR
	SELECT * 
	FROM @list_of_Courses
			
	OPEN test

	FETCH NEXT FROM test INTO @courseId, @timePeriodId, @campusId
	WHILE @@FETCH_STATUS = 0
		BEGIN TRY
			INSERT INTO StudentRegistersInCourse(personId, courseId, timePeriodId, campusId)
			VALUES(@stdNo, @courseId, @timePeriodId, @campusId)
			FETCH NEXT FROM test INTO @courseId, @timePeriodId, @campusId
		END TRY
		BEGIN CATCH
			SET @ErrorVariable = @@ERROR
			print @ErrorVariable
			FETCH NEXT FROM test INTO @courseId, @timePeriodId, @campusId
		END CATCH
	CLOSE test
	DEALLOCATE test
END
GO



