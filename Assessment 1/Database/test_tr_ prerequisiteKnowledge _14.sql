-- 1. Remove current values in StudentRegistersInCourse for testing

DELETE FROM StudentRegistersInCourse

-- 2. Insert 2 records of a student completing courses with no prerequisites


INSERT INTO StudentRegistersInCourse(personId, courseId, timePeriodId, campusId, finalMark)VALUES(1,1,1,1,30);
GO
INSERT INTO StudentRegistersInCourse(personId, courseId, timePeriodId, campusId, finalMark)VALUES(1,2,1,1,57);
GO
SELECT * FROM StudentRegistersInCourse
GO


/* 3. Try to insert Course with id 3, which has courseId 1 and 2 as prerequisites, it should fail as
Student 1 hasn't passed both courses */
INSERT INTO StudentRegistersInCourse(personId, courseId, timePeriodId, campusId, finalMark)VALUES(1,3,1,1,null);
go

SELECT * FROM StudentRegistersInCourse
GO

-- 4. Student 1 resits course1 and gets a HD
UPDATE StudentRegistersInCourse
SET finalMark = 91
WHERE courseId = 1
go

SELECT * FROM StudentRegistersInCourse

/* 5. Try to insert Course with id 3, which has courseId 1 and 2 as prerequisites, it should work now as student 1 has
met the prerequisites */
INSERT INTO StudentRegistersInCourse(personId, courseId, timePeriodId, campusId, finalMark)VALUES(1,3,1,1,null);
SELECT * FROM StudentRegistersInCourse
GO

-- 6. Delete all values in StudentRegisterInCourse and insert one value with no prerequisites
DELETE FROM StudentRegistersInCourse
GO

INSERT INTO StudentRegistersInCourse(personId, courseId, timePeriodId, campusId, finalMark)VALUES(1,1,1,1,30);
GO

SELECT * FROM StudentRegistersInCourse
GO

-- 7. Try to update that course to one that has prerequisites should fail
UPDATE StudentRegistersInCourse
SET courseId = 3

SELECT * FROM StudentRegistersInCourse
