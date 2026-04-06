
--==========================LOGIN (server)================================
-- Admin
CREATE LOGIN AdminLogin WITH PASSWORD = 'Admin@123';

-- Manager
CREATE LOGIN ManagerLogin WITH PASSWORD = 'Manager@123';

-- Instructor
CREATE LOGIN InstructorLogin WITH PASSWORD = 'Instructor@123';

-- Student
CREATE LOGIN StudentLogin WITH PASSWORD = 'Student@123';

--==========================Users(DB)================================

CREATE USER AdminUser FOR LOGIN AdminLogin;
CREATE USER ManagerUser FOR LOGIN ManagerLogin;
CREATE USER InstructorUser FOR LOGIN InstructorLogin;
CREATE USER StudentUser FOR LOGIN StudentLogin;

--==========================ROLE ================================
CREATE ROLE AdminRole;
CREATE ROLE ManagerRole;
CREATE ROLE InstructorRole;
CREATE ROLE StudentRole;

--==========================ROLE(Users) ================================
ALTER ROLE AdminRole ADD MEMBER AdminUser;
ALTER ROLE ManagerRole ADD MEMBER ManagerUser;
ALTER ROLE InstructorRole ADD MEMBER InstructorUser;
ALTER ROLE StudentRole ADD MEMBER StudentUser;

--==========================Permissions(Admin) ================================
GRANT CONTROL ON DATABASE::ExamSystemDB TO AdminRole;

--==========================Permissions(Manager) ================================
GRANT SELECT, INSERT, UPDATE, DELETE ON Student TO ManagerRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Course TO ManagerRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Track TO ManagerRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Branch TO ManagerRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Intake TO ManagerRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Enrollment TO ManagerRole;


--==========================Permissions(Instructor) ================================
GRANT SELECT ON Course TO InstructorRole;
GRANT SELECT, INSERT, UPDATE ON Question TO InstructorRole;
GRANT SELECT, INSERT, UPDATE ON Exam TO InstructorRole;
GRANT SELECT, INSERT, UPDATE ON Exam_Question TO InstructorRole;
GRANT SELECT ON Student TO InstructorRole;
GRANT SELECT ON Answer TO InstructorRole;
GRANT INSERT ON Student_Exam TO InstructorRole;
GRANT INSERT ON Student_Exam TO InstructorUser;

--==========================Permissions(Student)================================
GRANT SELECT ON Exam TO StudentRole;
GRANT SELECT ON Question TO StudentRole;
GRANT SELECT ON Choice TO StudentRole;
GRANT INSERT, UPDATE ON Answer TO StudentRole;
GRANT SELECT ON Answer TO StudentRole;


--prevent student from edit mark
DENY UPDATE ON Answer(Mark) TO StudentRole;
