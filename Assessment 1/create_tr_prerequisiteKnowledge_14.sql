CREATE TABLE Emp (
eno INT PRIMARY KEY,
ename VARCHAR(100),
salary FLOAT,
manager INT REFERENCES Emp)
go


CREATE TRIGGER myFirstTrigger
ON Emp
FOR INSERT, DELETE
AS
BEGIN
	PRINT 'Inserted table'
	SELECT * FROM inserted
	PRINT 'Deleted table'
	SELECT * FROM deleted
END
