use ExamSystemDB

--course

CREATE TABLE Course (
    ID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(200),
   -- Max_Mark INT CHECK (Max_Mark > 0),
    --Min_Mark INT CHECK (Min_Mark >= 0 AND Min_Mark < Max_Mark)
);

--Course_Instructor

CREATE TABLE Course_Instructor (
    Course_ID INT,
    Inst_ID INT,
    PRIMARY KEY (Course_ID, Inst_ID),
    FOREIGN KEY (Course_ID) REFERENCES Course(ID),
  FOREIGN KEY (Inst_ID) REFERENCES Instructor(ID)
);

--Exam


CREATE TABLE Exam (
    ID INT PRIMARY KEY IDENTITY,
    Allowance INT,
    Start_Time DATETIME,
    End_Time DATETIME,
    Type NVARCHAR(50),
    CONSTRAINT CHK_Time CHECK (End_Time > Start_Time)
);

--Exam_Question

CREATE TABLE Exam_Question (
    Exam_ID INT,
    Question_ID INT,
    PRIMARY KEY (Exam_ID, Question_ID),
    FOREIGN KEY (Exam_ID) REFERENCES Exam(ID),
    FOREIGN KEY (Question_ID) REFERENCES Question(ID)
);
--Student_Exam


CREATE TABLE Student_Exam (
    Exam_ID INT,
    Student_ID INT,
    PRIMARY KEY (Exam_ID, Student_ID),
    FOREIGN KEY (Exam_ID) REFERENCES Exam(ID),
   FOREIGN KEY (Student_ID) REFERENCES Student(ID)
);

create table Student
(
Id int primary key identity,
Name varchar(255) not null,
IntakeId int references Intake(Id)
);

create table Student_Course
(
StudentId int references Student(Id) on delete cascade,
CourseId int  references Course(Id) on delete cascade
Primary key(StudentId, CourseId)
);
-- add to Fk ref


create table Question
(
Id int primary key identity,
Mark decimal(10,1),
Body varchar(max),
Answer varchar(max),
Type varchar(50) check (Type in ('MCQ','TrueOrFalse','Text')),
CourseId int references Course(Id),
InstructorId int references Instructor(Id) 
);

Create Table Choice
(
Id int primary key identity,
Body varchar(max) not null,
QuestionId int references Question(Id) on delete cascade
)

create Table Answer
(
StudentId int references Student(Id),
ExamId int references Exam(Id),
QuestionId int  references Question(Id),
Student_Answer varchar(max),
Mark decimal(10,1),
Is_Correct Bit ,
Primary key (StudentId,ExamId,QuestionId)
)

create Table Put_Exam
(
ExamId int references Exam(Id),
CourseId int references Course(Id),
InstructorId int references Instructor(Id),
Year Int
)

--------------------------------------------------------------------

create table Instructor-- Done -- outside ref
(
Id int primary key,
Name varchar(50),
Stafftype varchar(50) 
);


create table Department --Done
(
Id int primary key,
Name varchar(50),
ManagerId int,

foreign key(ManagerId) references Instructor(Id) 
);
--Track
create table Track --Done
(
Id int primary key,
Name varchar(50),
Description varchar(50),
Department_ID int ,
foreign key(Department_ID) references Department(Id) 

);


create table Branch --Done
(
Id int primary key,
Name varchar(50),
Address varchar(50),
);

create table Branch_Track --Done
(
BranchId int ,
TrackId int ,
primary key(BranchId,TrackId),
foreign key(BranchId) references Branch(Id) ,
foreign key(TrackId) references Track(Id) 
);

create table Intake -- Done --outside ref
(
Id int primary key
); 


create table Enrollment-- Done
(
IntakeId int,
BranchId int,
TrackId int,
primary key (TrackId,BranchId,IntakeId),
foreign key (TrackId) references Track(Id),
foreign key (BranchId) references  Branch (Id), 
foreign key (IntakeId) references Intake(Id), 

);



