use ExamSystemDB

create or alter procedure createexam
    @examtype varchar(15),
    @allowance int,
    @starttime datetime,
    @endtime datetime,
    @courseid int,
    @instructorid int,
    @year int
as
begin
    declare @examid int;
     if @endtime <= @starttime
    begin
        print 'Error: End time must be after start time';
        return;
    end
    insert into exam (type, allowance, start_time, end_time)
    values (@examtype, @allowance, @starttime, @endtime);
    
    set @examid = (select max(id) from exam);
    
    insert into put_exam (examid, courseid, instructorid, year)
    values (@examid, @courseid, @instructorid, @year);
end;

-------------------------------------------------------

create or alter procedure addquestiontoexam
    @examid int,
    @questionid int
as
begin
    declare @questionmark decimal(10,1);
    declare @currenttotal decimal(10,1);
    declare @coursemax int;
    declare @courseid int;
    
    select @questionmark = mark from question where id = @questionid;
    
    select @courseid = courseid from put_exam where examid = @examid;
    
    select @coursemax = max_mark from course where id = @courseid;
    
    select @currenttotal = isnull(sum(q.mark), 0)
    from exam_question eq
    join question q on eq.question_id = q.id
    where eq.exam_id = @examid;
    
    if (@currenttotal + @questionmark) > @coursemax
    begin
        print 'Error: Adding this question would exceed course maximum mark';
        return;
    end
    
    insert into exam_question (exam_id, question_id)
    values (@examid, @questionid);
    
    select 'question added successfully' as message;
end;
-------------------------
create or alter procedure addstudent
    @name varchar(255),
    @intakeid int
as
begin
    insert into student (name, intakeid)
    values (@name, @intakeid);
    
    select 'student added successfully' as message;
end;

----------------------------------------
create or alter procedure makequestion
    @mark int,
    @body varchar(max),
    @answer varchar(max),
    @type varchar(50),
    @courseid int,
    @instructorid int
as
begin
    if @type not in ('MCQ', 'TrueOrFalse')
    begin
        print 'Error: Question type must be MCQ or TrueOrFalse';
        return;
    end
    
    if not exists (select 1 from course where id = @courseid)
    begin
        print 'Error: Course does not exist';
        return;
    end
    
    if not exists (select 1 from instructor where id = @instructorid)
    begin
        print 'Error: Instructor does not exist';
        return;
    end
    
    insert into question (mark, body, answer, type, courseid, instructorid)
    values (@mark, @body, @answer, @type, @courseid, @instructorid);
    
    select 'question added successfully' as message;
end;


---------------------------------------------


create or alter procedure updatestudent
    @studentid int,
    @name varchar(255),
    @intakeid int
as
begin
   
    if not exists (select 1 from student where id = @studentid)
    begin
        print 'Error: Student does not exist';
        return;
    end
    
    
    if not exists (select 1 from intake where id = @intakeid)
    begin
        print 'Error: Intake does not exist';
        return;
    end
    
   
    update student
    set name = @name,
        intakeid = @intakeid
    where id = @studentid;
    
    select 'student updated successfully' as message;
end;

-----------------------------------------------------------------------

create or alter procedure updateexam
    @examid int,
    @examtype varchar(15),
    @allowance int,
    @starttime datetime,
    @endtime datetime,
    @courseid int,
    @instructorid int,
    @year int
as
begin 
    if not exists (select 1 from exam where id = @examid)
    begin
        print 'Error: Exam does not exist';
        return;
    end
    
    if not exists (select 1 from course_instructor 
                   where course_id = @courseid 
                   and instrcutor_id = @instructorid)
    begin
        print 'Error: Instructor does not teach this course';
        return;
    end
    
    if @endtime <= @starttime
    begin
        print 'Error: End time must be after start time';
        return;
    end
    
    update exam
    set type = @examtype,
        allowance = @allowance,
        start_time = @starttime,
        end_time = @endtime
    where id = @examid;
    
    update put_exam
    set courseid = @courseid,
        instructorid = @instructorid,
        year = @year
    where examid = @examid;
    
    select 'exam updated successfully' as message;
end;



-------------------------------------------------------
create or alter procedure updatequestion
    @questionid int,
    @mark int,
    @body varchar(max),
    @answer varchar(max),
    @type varchar(50),
    @courseid int,
    @instructorid int
as
begin
    if not exists (select 1 from question where id = @questionid)
    begin
        print 'Error: Question does not exist';
        return;
    end
    
    if @type not in ('MCQ', 'TrueOrFalse')
    begin
        print 'Error: Question type must be MCQ or TrueOrFalse';
        return;
    end
    
    if not exists (select 1 from course where id = @courseid)
    begin
        print 'Error: Course does not exist';
        return;
    end
    
    if not exists (select 1 from instructor where id = @instructorid)
    begin
        print 'Error: Instructor does not exist';
        return;
    end
    
    update question
    set mark = @mark,
        body = @body,
        answer = @answer,
        type = @type,
        courseid = @courseid,
        instructorid = @instructorid
    where id = @questionid;
    
    select 'question updated successfully' as message;
end;

----------------------------------------------
create or alter procedure addchoices -- ?? ???? ??? ????? ?? ???????
    @questionid int,
    @choice1 varchar(max),
    @choice2 varchar(max),
    @choice3 varchar(max),
    @choice4 varchar(max)
as
begin
    if not exists (select 1 from question where id = @questionid)
    begin
        print 'Error: Question does not exist';
        return;
    end
    
    if (select type from question where id = @questionid) != 'MCQ'
    begin
        print 'Error: Only MCQ questions can have choices';
        return;
    end
    
    delete from choice where questionid = @questionid;
    
    insert into choice (body, questionid) values
    (@choice1, @questionid),
    (@choice2, @questionid),
    (@choice3, @questionid),
    (@choice4, @questionid);
    
    select 'choices added successfully' as message;
end;

---------------------------------------------
create or alter procedure deleteexam
    @examid int
as
begin
    if not exists (select 1 from exam where id = @examid)
    begin
        print 'Error: Exam does not exist';
        return;
    end
    
    delete from exam_question where exam_id = @examid;
    
    delete from put_exam where examid = @examid;
    
    delete from exam where id = @examid;
    
    select 'exam deleted successfully' as message;
end;
--------------------------------------------------
create or alter procedure removequestionfromexam
    @examid int,
    @questionid int
as
begin
    if not exists (select 1 from exam where id = @examid)
    begin
        print 'Error: Exam does not exist';
        return;
    end
    
    if not exists (select 1 from question where id = @questionid)
    begin
        print 'Error: Question does not exist';
        return;
    end
    
    
    if not exists (select 1 from exam_question -- check if question in exam
                   where exam_id = @examid and question_id = @questionid)
    begin
        print 'Error: Question is not in this exam';
        return;
    end
    
    delete from exam_question 
    where exam_id = @examid and question_id = @questionid;
    
    select 'question removed from exam successfully' as message;
end;
------------------------------------------------------------------------
create or alter procedure deletechoices
    @questionid int
as
begin
    if not exists (select 1 from question where id = @questionid)
    begin
        print 'Error: Question does not exist';
        return;
    end
    
    delete from choice where questionid = @questionid;
    
    select 'choices deleted successfully' as message;
end;
go
