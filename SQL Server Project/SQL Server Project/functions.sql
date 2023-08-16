
use Examination_system 
go 

----------- Instructor can make Exam by selecting number of questions of each type------------------------

create or alter function SelectQuestionExam_fn (@Que_ID int , @INS_ID int , @Password nvarchar(50))
returns @t table
(
Q_Id int,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
Q_Title nvarchar(max) ,
Q_ChoiceA nvarchar(max),
Q_ChoiceB nvarchar(max),
Q_ChoiceC nvarchar(max),
Q_ChoiceD nvarchar(max),
Q_CorrectAnswer nvarchar(1),
Q_Degree int,
Q_type nvarchar(20),
Cur_Id int,
Ex_Id int
)
as
begin
	declare @insID int , @CUR_ID int 
	select @insID = Ins_Id from InstractorTB where Ins_Password=@Password;	
	select @CUR_ID= Cur_Id from QuestionsTB where Q_Id = @Que_ID	
	if(@insID=@INS_ID)
		begin
			if(@CUR_ID=(select Cur_Id from Course_InstractorTB where Ins_Id=@INS_ID))
				begin
					insert into @t
					select * from QuestionsTB where Q_Id = @Que_ID	
				end	
		end
return 
end

--que , ins , pass

insert into Exam_Questions select * from SelectQuestionExam_fn(1,1,'mu123') -- inserted 
insert into Exam_Questions select * from SelectQuestionExam_fn(2,1,'mu123') -- inserted 

----------//////////////////////////////////////////////////////////////////////////////////////////-------
----------------- Students can see the exam ------------------

create or alter function ShowExam_fn (@EX_ID int)
returns @t table
(
Course_Name nvarchar(50),
Instractor_Name nvarchar (50),
Exam_Year int
)
as
begin
	declare @ins int ,@course int , @y int
	select @course= Cur_id , @y=year(Ex_StartTime), @ins= Ins_Id from ExamsTB where Ex_Id=@EX_ID 
	declare @insname nvarchar(30) , @coursename nvarchar(30)
	select @coursename = Cur_Name from CoursesTB where Cur_Id =@course
	select @insname= Ins_Name from InstractorTB where Ins_Id =@ins
	insert into @t values (@coursename , @insname ,  @y)
	return
end
--exec fn

select * from  ShowExam_fn(1)
select * from  ShowExam_fn(2)
select * from  ShowExam_fn(3)

----------//////////////////////////////////////////////////////////////////////////////////////////-------
-----------. Students can see the exam and do it only on the specified time ---------------------


create or alter function SpecifiedtimeExam_fn (@INS_ID int , @Password nvarchar(50),@EX_ID int , @CurID int)
returns @t table
(
Q_Id int,
Q_Title nvarchar(max) ,
Q_ChoiceA nvarchar(max),
Q_ChoiceB nvarchar(max),
Q_ChoiceC nvarchar(max),
Q_ChoiceD nvarchar(max),
Q_CorrectAnswer nvarchar(1),
Q_Degree int,
Q_type nvarchar(20),
Cur_Id int,
Ex_Id int
)
as
begin
	declare @starttime datetime , @endtime datetime , @Examtime datetime , @insID int , @CUR_ID int	
	select @insID = Ins_Id from InstractorTB where Ins_Password=@Password;			
	if(@insID=@INS_ID)
		begin
			if(@CurID=(select Cur_Id from Course_InstractorTB where Ins_Id=@INS_ID))
				begin
					select @starttime= Ex_StartTime from ExamsTB where Ex_Id=@EX_ID
					select @endtime= Ex_EndTime from ExamsTB where Ex_Id=@EX_ID
					set @Examtime=GETDATE();
					if (@Examtime between @starttime and @endtime)
						begin
							insert into @t
							select * from Exam_Questions where Ex_Id=@EX_ID and Cur_Id=@CurID	
						end					
				end	
		end
return 
end
--tested
select * from  SpecifiedtimeExam_fn(1,'mu123',1,2) --ins , pass , exam , course

----------//////////////////////////////////////////////////////////////////////////////////////////-------
/*he must put a degree for each question on the exam, and total degrees must not exceed the course */

Create or alter function CalcResult_fn (@StdId int, @ExamId int)
returns int
As
Begin 
	declare @result int
	set @result = (select SUM(St_degree) from StudentAnswerTB where St_Id = @StdId and Ex_Id = @ExamId)
	return @result;
end

exec  CalcResult_fn 1,2