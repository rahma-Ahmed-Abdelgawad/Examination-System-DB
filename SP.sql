use ExamSystemDB

create procedure TMAddIntake @Year int, @startdate datetime2, @enddate datetime2 
as 
begin
insert Intake values(@Year,@startdate,@enddate)
end
go

create procedure TmUpdateTrack @TrackId int , @NewName varchar(max),@des varchar(max), @deptId int
as begin
update Track
set Name = @NewName, Description = @des, Department_ID = @deptId
where Id = @TrackId
end

go


create proc sp_AddTrack
    @Name VARCHAR(50),
    @Description VARCHAR(50),
    @DepartmentName varchar(max)
AS
begin
begin try
        begin transaction;
        declare @Department_ID int

        select @Department_ID = Id 
        from Department
        where Name like  '%'+ @DepartmentName +'%'

        INSERT INTO Track (Name, Description, Department_ID)
        VALUES (@Name, @Description, @Department_ID);

        commit transaction;

        print 'Track added successfully.';
    end try
    begin catch
        if @@TRANCOUNT > 0
            rollback transaction;
        throw;
    end catch;
end;

go

create procedure sp_removetrack @id int
as
begin
    set xact_abort on;
    set nocount on;

    begin try
        begin transaction;

        delete from track

        where id = @id;

        if @@rowcount = 0
        begin
            raiserror('track not found.', 16, 1);
        end

        commit transaction;
    end try
    begin catch
        if @@trancount > 0
            rollback transaction;

        throw;
    end catch
end;

go


create procedure sp_StudentStartExam 
    @ExamId int, 
    @StudentId int
as
begin
    set nocount on;

    -- if student is enrolled
    if exists (
        select 1 
        from Student_Exam ste
        inner join Exam ex on ste.Exam_ID = ex.Id
        where ste.Student_ID = @StudentId and ex.Id = @ExamId and GETDATE() between ex.Start_Time and ex.End_Time
    )
    begin
        -- success: return exam details
        select 
            ex.Id as ExamId,
            ex.Start_Time as StartTime,
            ex.End_Time as EndTime,
            'Allowed' as Status
        from Student_Exam ste
        inner join Exam ex on ste.Exam_ID = ex.Id
        where ste.Student_ID = @StudentId 
          and ex.Id = @ExamId;
    end
    else
    begin
        -- failure: return error message
        select 
            null as ExamId,
            null as StartTime,
            null as EndTime,
            'Error: Exam not active or student not enrolled' as Status;
    end
end


go
USE ExamSystemDB;

-- Test TMAddIntake: Add intake for 2026
EXEC TMAddIntake 
    @Year = 2026, 
    @startdate = '2026-09-01 08:00:00', 
    @enddate = '2027-06-30 18:00:00';

-- Test TmUpdateTrack: Update track ID 5 to new name and department
EXEC TmUpdateTrack 
    @TrackId = 2, 
    @NewName = 'Advanced Software Engineering', 
    @des = 'Updated curriculum focusing on cloud architecture', 
    @deptId = 2;

-- Test sp_AddTrack: Add new track under Computer Science department
EXEC sp_AddTrack 
    @Name = 'Data Science Fundamentals', 
    @Description = 'Introduction to analytics and ML', 
    @DepartmentName = 'Computer Science';

-- Test sp_removetrack: Remove track ID 10
EXEC sp_removetrack @id = 11;

-- Test sp_StudentStartExam: Student 101 attempting to start Exam 55
EXEC sp_StudentStartExam 
    @ExamId = 1, 
    @StudentId = 1;