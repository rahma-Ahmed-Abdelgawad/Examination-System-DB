--Instructor
INSERT INTO Instructor (Id, Name, Stafftype) VALUES
(1, 'Ahmed Ali', 'FullTime'),
(2, 'Sara Mohamed', 'PartTime'),
(3, 'Omar Hassan', 'FullTime'),
(4, 'Mona Khaled', 'PartTime'),
(5, 'Youssef Adel', 'FullTime');

--Department
INSERT INTO Department (Id, Name, ManagerId) VALUES
(1, 'Software', 1),
(2, 'Networks', 2),
(3, 'AI', 3);

--Track
INSERT INTO Track (Id, Name, Description, Department_ID) VALUES
(1, 'Full Stack', 'Web Development', 1),
(2, 'Cyber Security', 'Security Track', 2),
(3, 'Machine Learning', 'AI Track', 3);

--Branch
INSERT INTO Branch (Id, Name, Address) VALUES
(1, 'Cairo Branch', 'Nasr City'),
(2, 'Alex Branch', 'Smouha'),
(3, 'Fayoum Branch', 'Fayoum City');

--Branch_Track
INSERT INTO Branch_Track VALUES
(1,1),(1,2),
(2,2),(2,3),
(3,1),(3,3);

--Intake
INSERT INTO Intake 
VALUES
(1),(2),(3);

--Enrollment
INSERT INTO Enrollment VALUES
(1,1,1),
(2,2,2),
(3,3,3),
(1,2,1),
(2,3,2);

--Student
INSERT INTO Student (Name, IntakeId) VALUES
('Ali Hassan',1),
('Mona Ahmed',1),
('Sara Ali',2),
('Omar Samy',2),
('Nour Khaled',3),
('Hassan Adel',3),
('Yara Mostafa',1),
('Khaled Mahmoud',2),
('Salma Tarek',3),
('Ahmed Nabil',1),
('Mai Hossam',2),
('Ziad Fathy',3),
('Heba Salah',1),
('Karim Youssef',2),
('Nada Ali',3);

--Course
INSERT INTO Course (Name, Description) VALUES
('C#', 'Programming'),
('SQL', 'Database'),
('HTML', 'Frontend'),
('CSS', 'Design'),
('JavaScript', 'Frontend Logic');

--Student_Course
INSERT INTO Student_Course VALUES
(1,1),(1,2),
(2,2),(2,3),
(3,1),(3,3),
(4,4),(5,5),
(6,1),(7,2),
(8,3),(9,4),
(10,5),(11,1),
(12,2),(13,3),
(14,4),(15,5);

--Course_Instructor
INSERT INTO Course_Instructor VALUES
(1,1),(2,2),(3,3),
(4,4),(5,5);

--Question 
INSERT INTO Question (Mark, Body, Answer, Type, CourseId, InstructorId) VALUES
(10, 'What is C#?', 'Programming Language', 'Text', 1,1),
(5, 'SQL stands for?', 'Structured Query Language', 'MCQ', 2,2),
(5, 'HTML is markup?', 'True', 'TrueOrFalse', 3,3),
(10, 'CSS used for?', 'Styling', 'Text', 4,4),
(5, 'JS is scripting?', 'True', 'TrueOrFalse', 5,5);

--Choice
INSERT INTO Choice (Body, QuestionId) VALUES
('Option1',2),
('Option2',2),
('True',3),
('False',3),
('Yes',5),
('No',5);

--Exam
INSERT INTO Exam (Allowance, Start_Time, End_Time, Type) VALUES
(60, '2026-04-01 10:00', '2026-04-01 11:00', 'Final'),
(30, '2026-04-02 12:00', '2026-04-02 12:30', 'Quiz');

--Exam_Question
INSERT INTO Exam_Question VALUES
(1,1),(1,2),(1,3),
(2,4),(2,5);

--Student_Exam 
INSERT INTO Student_Exam VALUES
(1,1),(1,2),(1,3),
(2,4),(2,5);

--Answer
INSERT INTO Answer VALUES
(1,1,1,'Programming Language',10,1),
(2,1,2,'Structured Query Language',5,1),
(3,1,3,'True',5,1),
(4,2,4,'Styling',10,1),
(5,2,5,'True',5,1);

--Put_Exam
INSERT INTO Put_Exam VALUES
(1,1,1,2026),
(2,2,2,2026);