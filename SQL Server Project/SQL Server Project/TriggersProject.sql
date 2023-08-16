USE ExaminationSystem
Go

create trigger CheckTotalDegreeOfExam_trg
on [dbo].[Exam_Questions]
after insert
as
begin
	declare @sumDegree int , @Cur_Maxdeg int , @CourseID int 
	select distinct @sumDegree= Sum(Q_Degree) , @CourseID = Cur_Id from Exam_Questions group by Cur_Id	
	select @Cur_Maxdeg= Cur_MaxDegree from CoursesTB c , Exam_Questions e where c.Cur_Id=@CourseID 	
	if(@sumDegree>@Cur_Maxdeg)
		begin
			rollback
			print'Sorry you have exceeded the maximum grade of the course'
		end
end
--check triger CheckTotalDegreeOfExam_trg
insert into Exam_Questions
select * from SelectQuestionExam_Fun(11,1,'mu123') -- add 
insert into Exam_Questions
select * from SelectQuestionExam_Fun(12,1,'mu123') -- add 
insert into Exam_Questions
select * from SelectQuestionExam_Fun(13,1,'mu123') -- add 
insert into Exam_Questions
select * from SelectQuestionExam_Fun(15,1,'mu123') -- not add because you have exceeded the maximum grade of the course

-- trigger prevent instructor  from adding questions in a course other than his course.
create trigger PreventInsFromEdit_trg
on [dbo].[QuestionsTB]
after insert
as
begin
	declare @UserName nvarchar(50)
	declare @InsID int , @CurID int
	select @UserName=SUSER_NAME();
	select @InsId= Ins_Id
	from InstractorsTB where Ins_UserName=@UserName
	select @CurID=Cur_Id from inserted
	if(@CurID in(select Cur_Id from Course_InstractorTB where Ins_Id=@InsID))
	begin
		commit
	end
	else
	begin
		rollback
		print 'You cannot edit this course!!!'
	end
end
------------------------------------------------------------------------------------------------
--prevent instructor  from update questions in a course other than his course.
create trigger PreventInsFromUpdate_trg
on [dbo].[QuestionsTB]
after update
as
begin
	declare @UserName nvarchar(50)
	declare @InsID int , @CurID int
	select @UserName=SUSER_NAME();
	select @InsId= Ins_Id
	from InstractorsTB where Ins_UserName=@UserName
	select @CurID=Cur_Id from inserted
	if(@CurID in(select Cur_Id from Course_InstractorTB where Ins_Id=@InsID))
	begin
		commit
	end
	else
	begin
		rollback
		print 'You cannot edit this course!!!'
	end
end
----------------------------------------------------------------------------------------------------------
--prevent instructor  from delete questions in a course other than his course.
create trigger PreventInsFromDelete_trg
on [dbo].[QuestionsTB]
after delete
as
begin
	declare @UserName nvarchar(50)
	declare @InsID int , @CurID int
	select @UserName=SUSER_NAME();
	select @InsId= Ins_Id
	from InstractorsTB where Ins_UserName=@UserName
	select @CurID=Cur_Id from deleted
	if(@CurID in(select Cur_Id from Course_InstractorTB where Ins_Id=@InsID))
	begin
		commit
	end
	else
	begin
		rollback
		print 'You cannot edit this course!!!'
	end
end
---------------------------------------------------------------------------------------------
--prevent Training Manager from update column MG_ID on Instructor table.
create trigger PreventMngFromupdateMGIDcol_trg
on [dbo].[InstractorTB]
after update
as
begin
	declare @UserName nvarchar(50)
	select @UserName=SUSER_NAME();
	if(@UserName=(select Admin_Username from AdminTB))
		begin
			commit
		end
	else if(@UserName in (select Ins_UserName from InstractorsTB))
		begin
			if(update(MG_Id))
				begin
					rollback
					print 'You cannot edit this column!!!'
				end
		end	
end
--------------------------------------------------------------------------------------------------------
--Check answer C, and answer D based on the type of question.
create trigger CheckQuesTypeAnswer_trg
on [dbo].[QuestionsTB]
after insert
as
begin
	declare @ChoiceC nvarchar(max), @ChoiceD nvarchar(max),@Type nvarchar(20)
	select @ChoiceC = Q_ChoiceC from inserted
	select @ChoiceD = Q_ChoiceD from inserted
	select @Type = Q_Type from inserted
	if(@Type='Choices')
		begin
			if(@ChoiceC is null or @ChoiceC='' or @ChoiceD is null or @ChoiceD='')
				begin
					rollback
					print 'Multiple choice questions must contain four choices.'
				end
		end
	else if(@Type='TrueOrFalse')
		begin
				if(@ChoiceC is not null or @ChoiceC='' or @ChoiceD is not null or @ChoiceD='')
					begin
						rollback
						print 'True or False questions must contain two choices.'
					end
		end
end
---------------------------------------------------------------------------------------------------------------
--prevent instructor  from adding questions in a course other than his course.
create trigger PreventtInsFromEditExamQue_trg
on [dbo].[Exam_Questions]
after insert
as
begin
	declare @UserName nvarchar(50)
	declare @InsID int , @CurID int
	select @UserName=SUSER_NAME();
	select @InsId= Ins_Id
	from InstractorsTB where Ins_UserName=@UserName
	select @CurID=Cur_Id from inserted
	if(@CurID in(select Cur_Id from Course_InstractorTB where Ins_Id=@InsID))
	begin
		commit
	end
	else
	begin
		rollback
		print 'You cannot edit this course!!!'
	end
end
----------------------------------------------------------------------------------------------
--prevent instructor  from update questions in a course other than his course.
create trigger PreventInsFromUpdateExamQue_trig
on [dbo].[Exam_Questions]
after update
as
begin
	declare @UserName nvarchar(50)
	declare @InsID int , @CurID int
	select @UserName=SUSER_NAME();
	select @InsId= Ins_Id
	from InstractorsTB where Ins_UserName=@UserName
	select @CurID=Cur_Id from inserted
	if(@CurID in(select Cur_Id from Course_InstractorTB where Ins_Id=@InsID))
	begin
		commit
	end
	else
	begin
		rollback
		print 'You cannot edit this course!!!'
	end
end
--------------------------------------------------------------------------------------------------
--prevent instructor  from delete questions in a course other than his course.
create trigger PreventInsFromDeleteExamQue_trig
on [dbo].[Exam_Questions]
after delete
as
begin
	declare @UserName nvarchar(50)
	declare @InsID int , @CurID int
	select @UserName=SUSER_NAME();
	select @InsId= Ins_Id
	from InstractorsTB where Ins_UserName=@UserName
	select @CurID=Cur_Id from deleted
	if(@CurID in(select Cur_Id from Course_InstractorTB where Ins_Id=@InsID))
	begin
		commit
	end
	else
	begin
		rollback
		print 'You cannot edit this course!!!'
	end
end
------------------------------------------------------------------------------------
--Check answer C, and answer D based on the type of question.
create trigger CheckQuesTypeChoices_trig
on [dbo].[Exam_Questions]
after insert
as
begin
	declare @ChoiceC nvarchar(max), @ChoiceD nvarchar(max),@Type nvarchar(20)
	select @ChoiceC = Q_ChoiceC from inserted
	select @ChoiceD = Q_ChoiceD from inserted
	select @Type = Q_Type from inserted
	if(@Type='Choices')
		begin
			if(@ChoiceC is null or @ChoiceC='' or @ChoiceD is null or @ChoiceD='')
				begin
					rollback
					print 'Multiple choice questions must contain four choices.'
				end
		end
	else if(@Type='TrueOrFalse')
		begin
				if(@ChoiceC is not null or @ChoiceC='' or @ChoiceD is not null or @ChoiceD='')
					begin
						rollback
						print 'True or False questions must contain two choices.'
					end
		end
end
-------------------------------------------------------------------------------------------------
-- proc prevent instructor  from delete questions in a course other than his course.
create proc PreventtInstFromDelete_sp (@insID int ,@Password nvarchar(50),@C_id int, @q_id int)
as
begin
	declare @checkPass nvarchar(50) , @cur_id int
	select @checkPass= Ins_Password from InstractorTB where Ins_Id=@insID
	select @C_id= Cur_Id from Course_InstractorTB where Ins_Id=@insID
	if(@checkPass=@Password and @C_id=@C_id)
		begin
			delete from QuestionsTB where Q_Id=@q_id
		end
	else
		begin
			print 'You cannot edit this course!!!'
		end
end
exec PreventtInstFromDelete_sp 1,'amn123',2,16
exec PreventtInstFromDelete_sp 2,'amnn23',2,16
exec PreventtInstFromDelete_sp 1,'mn123',2,16
--------------------------------------------------------------------------------

--auditing to track changes to the Exams table over time:
CREATE TRIGGER  TR_Exam_Audit
ON [dbo] .[ExamsTB]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
  DECLARE @Action VARCHAR(10);

  IF EXISTS (SELECT * FROM inserted)
  BEGIN
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
      SET @Action = 'UPDATE';
    END
    ELSE
    BEGIN
      SET @Action = 'INSERT';
    END
  END
  ELSE
  BEGIN
    SET @Action = 'DELETE';
  END

  INSERT INTO ExamAudit (Ex_Id, Action, UserID, AuditDate)
  SELECT (SELECT Ex_Id FROM inserted), @Action, USER_ID(), GETDATE();
END
----------------------------------------------------------------------------------
--restrict modification of the question pool to authorized users:
CREATE TRIGGER TR_Question_Edit
ON [dbo] .[QuestionsTB]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
  -- Check that the user is authorized to modify the question pool for the course
  IF USER_NAME() <> 'TrainingManager' AND NOT EXISTS (SELECT 1 FROM Courses c JOIN Instructor ins ON c.CoursesID = ins.CoursesID WHERE c.CoursesID = (SELECT CoursesID FROM inserted) OR c.CoursesID = (SELECT CoursesID FROM deleted) AND ins.InstructorID = USER_ID())
  BEGIN
    RAISERROR('You are not authorized to modify the question pool for this course.', 16, 1);
    ROLLBACK TRANSACTION;
    RETURN;
  END
END

-------------------------------------------------------------------------------
--prevent exams from being created with an invalid total degree:
CREATE TRIGGER TR_ExamQuestion_TotalDegree
ON [dbo].[Exam_Questions]
AFTER INSERT, UPDATE
AS
BEGIN
  -- Check that the total degrees for the exam do not exceed the course's maximum degree
  IF (SELECT SUM(Q_Degree) FROM Exam_Questions WHERE Ex_ID = (SELECT Ex_ID FROM Exam_Questions)) > (SELECT  Cur_MaxDegree FROM CoursesTB WHERE Cur_Id = (SELECT Cur_Id FROM ExamsTB WHERE Ex_ID = (SELECT Ex_ID FROM Exam_Questions)))
  BEGIN
    RAISERROR('Total degrees for the exam cannot exceed the course''s maximum degree.', 16, 1);
    ROLLBACK TRANSACTION;
    RETURN;
  END
END
