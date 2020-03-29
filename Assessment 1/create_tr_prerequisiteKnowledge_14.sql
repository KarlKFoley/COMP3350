/* Dummy Prerequisite */
INSERT INTO Prerequisite(courseId, PrereqId)
VALUES 
	(1, 3),
	(1, 2),
	(2, 3);

/* Dummy StudentRegistersInCourse */
INSERT INTO StudentRegistersInCourse(personId, courseId, timePeriodId, campusId, finalMark, finalGrade)
VALUES
(1,1,1,1,NULL,NULL),
(2,1,1,1,NULL,NULL),
(3,1,1,1,NULL,NULL),
(4,1,1,1,NULL,NULL),
(1,2,1,1,NULL,NULL),
(2,2,1,1,NULL,NULL),
(3,2,1,1,NULL,NULL),
(4,2,1,1,NULL,NULL),
(4,3,1,1,NULL,NULL),
(3,3,1,1,NULL,NULL),
(2,3,1,1,NULL,NULL),
(1,3,1,1,NULL,NULL);