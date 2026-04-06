
--Instructor can select students for exam
CREATE TRIGGER TR_Student_Not_Allowed
ON Answer
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        LEFT JOIN Student_Exam se
        ON i.StudentId = se.Student_ID
        AND i.ExamId = se.Exam_ID
        WHERE se.Student_ID IS NULL
    )
    BEGIN
        RAISERROR('Student not allowed to take this exam',16,1);
        RETURN;
    END

    INSERT INTO Answer
    SELECT * FROM inserted;
END;

--Correct_Answer
CREATE TRIGGER TR_Correct_Answer
ON Answer
AFTER INSERT
AS
BEGIN
    UPDATE A
    SET 
        Is_Correct =
            CASE 
                WHEN A.Student_Answer = Q.Answer THEN 1
                ELSE 0
            END,
        Mark =
            CASE 
                WHEN A.Student_Answer = Q.Answer THEN Q.Mark
                ELSE 0
            END
    FROM Answer A
    JOIN inserted i
        ON A.StudentId = i.StudentId
       AND A.ExamId = i.ExamId
       AND A.QuestionId = i.QuestionId
    JOIN Question Q
        ON A.QuestionId = Q.Id;
END;

--start time and end time
CREATE TRIGGER TR_Validate_Exam_Time
ON Exam
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted
        WHERE End_Time <= Start_Time
    )
    BEGIN
        RAISERROR('End time must be greater than start time',16,1)
        ROLLBACK;
    END
END;

--Prevent Delete Question question used in exam
CREATE TRIGGER TR_Prevent_Delete_Question
ON Question
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM deleted d
        JOIN Exam_Question EQ
        ON d.Id = EQ.Question_ID
    )
    BEGIN
        RAISERROR('Cannot delete question used in exam',16,1)
        RETURN;
    END

    DELETE FROM Question
    WHERE Id IN (SELECT Id FROM deleted);
END;