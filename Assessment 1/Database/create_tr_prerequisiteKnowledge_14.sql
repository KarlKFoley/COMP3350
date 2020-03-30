
DROP TRIGGER tr_EnforceCourseRegistrationPolicy
GO

-- Trigger is created
CREATE TRIGGER tr_EnforceCourseRegistrationPolicy
ON StudentRegistersInCourse
FOR INSERT, UPDATE
AS

BEGIN
	DECLARE @insertedCourse INT
	DECLARE @insertedPerson INT
	SELECT @insertedCourse = courseId FROM inserted
	SELECT @insertedPerson = personId FROM inserted 
	PRINT @insertedCourse
	-- check if any prerequisites exist for inserted course
	IF (EXISTS(SELECT courseId
		FROM Prerequisite
		WHERE @insertedCourse = courseId))
		-- if yes declare cursor to bring up result of prerequisites for that course
		BEGIN
			DECLARE @prereq INT, @AvaibleToRegister BIT
			DECLARE @finalGrade VARCHAR(MAX)
			SET @AvaibleToRegister = 1
			-- declare cursor
			DECLARE checkPrereqsCursor CURSOR
			FOR
			SELECT PrereqId
			FROM Prerequisite
			WHERE @insertedCourse = courseId

			OPEN checkPrereqsCursor

			FETCH NEXT FROM checkPrereqsCursor INTO @prereq
			WHILE @@FETCH_STATUS = 0
				BEGIN
				PRINT  @prereq
					SET @finalGrade = null
					
					SELECT @finalGrade = finalGrade
					FROM StudentRegistersInCourse 
					WHERE courseId = @prereq AND personId = @insertedPerson
					IF (@finalGrade = 'P' OR @finalGrade = 'C' OR @finalGrade = 'D' OR @finalGrade = 'HD')
						BEGIN
						PRINT 'They passed the course'
						
						FETCH NEXT FROM checkPrereqsCursor INTO @prereq
						END
						
					ELSE
						BEGIN
						PRINT 'No grade or fail for course'
						-- Rollback the transaction
						SET @AvaibleToRegister = 0
						FETCH NEXT FROM checkPrereqsCursor INTO @prereq
						END

				END
			
			CLOSE checkPrereqsCursor
			DEALLOCATE checkPrereqsCursor
			IF @AvaibleToRegister = 0
			BEGIN
				ROLLBACK TRANSACTION 
			END
		END
	ELSE
	BEGIN
		PRINT 'There are no prerequisites for the course'
	END
END
GO






