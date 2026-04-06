--====Permission===

ALTER DATABASE ExamSystemDB SET TRUSTWORTHY ON;

EXECUTE AS USER = 'InstructorUser';
INSERT INTO Student_Exam (Exam_ID, Student_ID)
VALUES (2, 6),
       (2, 7),
       (2, 8);
REVERT;
================================================
EXECUTE AS USER = 'StudentUser';

INSERT INTO Answer (StudentId, ExamId, QuestionId, Student_Answer, Mark, Is_Correct)
VALUES (6,2,5,'True',5,1);

REVERT;
===============================================