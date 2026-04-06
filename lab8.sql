use ITI

--1
CREATE PROCEDURE GetStudentsCountPerDept
AS
BEGIN
    SELECT D.Dept_Name, COUNT(S.St_Id) AS StudentCount
    FROM Department D    LEFT JOIN Student S
        ON D.Dept_Id = S.Dept_Id
    GROUP BY D.Dept_Name
END

--2
use Company_SD
CREATE PROCEDURE CheckEmployeesInP1
AS
BEGIN
    DECLARE @Count INT

    SELECT @Count = COUNT(*)
    FROM Works_on
    WHERE Pno = 1

    IF @Count >= 3
        PRINT 'The number of employees in the project p1 is 3 or more'
    ELSE
    BEGIN
        PRINT 'The following employees work for the project p1'

        SELECT E.Fname, E.Lname
        FROM Employee E
        JOIN Works_on W
            ON E.SSN = W.ESSn
        WHERE W.Pno = 1
    END
END
--3
CREATE PROCEDURE ReplaceEmployee
    @OldEmp INT,
    @NewEmp INT,
    @Pno INT
AS
BEGIN
    UPDATE Works_on
    SET ESSn = @NewEmp
    WHERE ESSn = @OldEmp AND Pno = @Pno
END

--4
ALTER TABLE project
ADD Budget INT

CREATE TABLE Project_Audit
(
    ProjectNo INT,
    UserName NVARCHAR(100),
    ModifiedDate DATETIME,
    Budget_Old INT,
    Budget_New INT
)

CREATE TRIGGER TR_ProjectBudgetAudit
ON Project
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Budget)
    BEGIN
        INSERT INTO Project_Audit
        SELECT 
            d.Pnumber,
            SUSER_NAME(),
            GETDATE(),
            d.Budget,
            i.Budget
        FROM deleted d
        JOIN inserted i
            ON d.Pnumber = i.Pnumber
    END
END

--5
CREATE TRIGGER TR_PreventInsertDept
ON company.Departments
INSTEAD OF INSERT
AS
BEGIN
    PRINT 'You cannot insert into Department table'
END

--6
CREATE TRIGGER TR_PreventInsertMarch
ON Employee
INSTEAD OF INSERT
AS
BEGIN
    IF MONTH(GETDATE()) = 3
    BEGIN
        PRINT 'Cannot insert employees in March'
    END
    ELSE
    BEGIN
        INSERT INTO Employee
        SELECT * FROM inserted
    END
END

--7
use ITI
CREATE TABLE Student_Audit
(
    UserName NVARCHAR(100),
    Date DATETIME,
    Note NVARCHAR(200)
)
CREATE TRIGGER TR_StudentInsertAudit
ON Student
AFTER INSERT
AS
BEGIN
    INSERT INTO Student_Audit
    SELECT 
        SUSER_NAME(),
        GETDATE(),
        SUSER_NAME() + ' Insert New Row with Key=' + CAST(St_Id AS NVARCHAR) + ' in table Student'
    FROM inserted
END

--8
CREATE TRIGGER TR_StudentDeleteAudit
ON Student
INSTEAD OF DELETE
AS
BEGIN
    INSERT INTO Student_Audit
    SELECT 
        SUSER_NAME(),
        GETDATE(),
        'Try to delete Row with Key=' + CAST(St_Id AS NVARCHAR)
    FROM deleted
END

--9
