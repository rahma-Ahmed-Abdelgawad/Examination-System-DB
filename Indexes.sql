--Student Name
CREATE INDEX IX_Student_Name
ON Student(Name);

--Course Name
CREATE INDEX IX_Course_Name
ON Course(Name);

--Question
CREATE INDEX IX_Question_Course
ON Question(CourseId);

CREATE INDEX IX_Question_Type
ON Question(Type);

--Answer
CREATE NONCLUSTERED INDEX IX_Answer_Student_Exam
ON Answer(StudentId, ExamId);

SELECT * FROM Answer
WHERE StudentId = 1 AND ExamId = 1;

--Student Exam
CREATE NONCLUSTERED INDEX IX_StudentExam
ON Student_Exam(Student_ID, Exam_ID);

--Exam Question
CREATE NONCLUSTERED INDEX IX_ExamQuestion
ON Exam_Question(Exam_ID);

--Course Instructor
CREATE NONCLUSTERED INDEX IX_CourseInstructor
ON Course_Instructor(Course_ID, Inst_ID);

--Enrollment
CREATE NONCLUSTERED INDEX IX_Enrollment
ON Enrollment(TrackId, BranchId, IntakeId);

--Choice
CREATE NONCLUSTERED INDEX IX_Choice_Question
ON Choice(QuestionId);

--Answer
CREATE NONCLUSTERED INDEX IX_Answer_Report
ON Answer(StudentId, ExamId)
INCLUDE (Mark, Is_Correct);