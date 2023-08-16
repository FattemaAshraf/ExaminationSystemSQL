-- 1--Instructor can add student into specific exam.
create proc AddStudentIntoExam_sp (@St_Name nvarchar(25) , @Ex_ID int)
as
begin
	if(@St_Name in(select St_Name from StudentTB))
		begin
			declare @St_ID int 
			select @St_ID= St_Id from StudentTB where St_Name = @St_Name
			insert into ResultsTB
			values (@St_ID , @Ex_ID,null)
		end
	else 
		begin
			print'Sorry this student not in system!!'
		end
end
exec AddStudentIntoExam_sp 'Mayar Mohmmed',1 --true
exec AddStudentIntoExam_sp 'xxxxxxxx',1 --error
------------------------------------------------------------------------------------------------


--2--Instructor can add new exam data into exam table.
create proc AddNewExam_sp (@Examname nvarchar(20), @examtype nvarchar(20), @examstarttime datetime, @examendtime datetime,
@examduration time(7),@insID int , @curID int )
as
begin
	declare @INS_ID int
	select @INS_ID=Ins_Id from Course_InstractorTB where Cur_Id=@curID
	if(@INS_ID=@insID)
		begin
			insert into ExamsTB
			values (@Examname,@examtype,@examstarttime,@examendtime,@examduration,@insID,@curID)
		end
	else
		begin
			print'Sorry, you can not add an exam to a course other than yours!'
		end
end
exec AddNewExam_sp 'HTML','corrective','2023-02-02','2023-02-02','01:00:00',1,2 --add
exec AddNewExam_sp 'HTML','corrective','2022-02-02','2022-02-02','01:00:00',1,6 --error

------------------------------------------------------------------------------------------

--3--Corrects exam questions.
create proc ExamCorrection(@Ex_ID int , @St_ID int , @QID int)
as
begin
	declare @Stu_Ans nvarchar(5) , @Corr_Ans nvarchar(5)
	select @Stu_Ans=St_Answer from StudentAswerTB where St_Id = @St_ID and Ex_Id=@Ex_ID and Q_Id=@QID
	select @Corr_Ans= Q_CorrectAnswer from Exam_Questions where Ex_Id = @Ex_ID and Q_Id = @QID 
	if(@Stu_Ans=@Corr_Ans)
		begin
			update StudentAswerTB
			set St_Degree = (select Q_Degree from Exam_Questions where Ex_Id = @Ex_ID and Q_Id = @QID)
			where St_Id = @St_ID and Ex_Id = @Ex_ID and Q_Id = @QID		
		end
	else
		begin
			update StudentAswerTB
			set St_Degree = 0 where St_Id = @St_ID and Ex_Id = @Ex_ID and Q_Id = @QID			
		end
end

exec ExamCorrection 1,1,1
exec ExamCorrection 1,1,2
exec ExamCorrection 1,1,5
exec ExamCorrection 1,1,10
exec ExamCorrection 1,1,18
exec ExamCorrection 1,1,20
exec ExamCorrection 1,1,21

exec ExamCorrection 1,2,1
exec ExamCorrection 1,2,2
exec ExamCorrection 1,2,5
exec ExamCorrection 1,2,10
exec ExamCorrection 1,2,18
exec ExamCorrection 1,2,20
exec ExamCorrection 1,2,21

----------------------------------------------------------------------------------------------------------------------------

--4--Sum the student's degrees in the exam
create proc SummationDegrees (@EX_ID int , @ST_ID int)
as
begin
	declare @Check_EX_ID int
	select @Check_EX_ID = Ex_Id from ResultsTB where St_Id = @ST_ID
	if(@Check_EX_ID=@EX_ID)
		begin
			declare @Sum int 
			select @Sum=sum(St_Degree)from StudentAswerTB
			where St_Id = @ST_ID and Ex_Id = @EX_ID
			update ResultsTB
			set St_TotalDegree = @Sum where St_Id = @ST_ID and Ex_Id = @EX_ID
		end
	else
	begin
		print 'Please check the exam ID or student ID'
	end
end

exec SummationDegrees 1,1
exec SummationDegrees 1,2

------------------------------------------------------------------------------------

--5--show exam details (Exam name , Exam type , Course name , Trak name).
create proc GetExamInfo(@Exam_ID int)
as
begin
	select e.Ex_Name, e.Ex_Type, c.Cur_Name , t.Trak_Name
	from ExamsTB e , CoursesTB c , Trak t ,Trak_CoursesTB tc
	where e.Ex_Id=@Exam_ID and e.Cur_id = c.Cur_Id and tc.Cur_Id = c.Cur_Id and tc.Trak_Id = t.Trak_Id
end


exec GetExamInfo 1

------------------------------------------------------------------------------------

--6-- Make Different options for the users to search and display results with different criteria.
--Search in results table using the student Id and take a variable for it. 
create proc SearchForResultesByStId_sp (@St_Id int)
as
begin
	select * from ResultsTB where St_Id = @St_Id
end
exec SearchForResultesByStId_sp 1

--------------------------------------------------------------------------------------


--7--Search in results table using the Exam Id and take a variable for it.
create proc SearchForResultesByEX_Id_sp (@St_Id int)
as
begin
	select * from ResultsTB where Ex_Id = @St_Id
end
exec SearchForResultesByEX_Id_sp 1

--------------------------------------------------------------------------------------------

--8--Search in results table using the student degree and take a variable for it.
create proc SearchForResultesByDegree_sp (@Degree int)
as
begin
	select * from ResultsTB where St_TotalDegree = @Degree
end



exec SearchForResultesByDegree_sp 98

--------------------------------------------------------------------------------------------
--9--Search in the results table for results that are greater than a specific result and take a variable for it.
create proc SearchForResultesByGreaterThanDegree_sp (@Degree int)
as
begin
	select * from ResultsTB where St_TotalDegree > @Degree
end

exec SearchForResultesByGreaterThanDegree_sp 88

--------------------------------------------------------------------------------------------

--10--Search in the results table for results that are smaller than a specific result and take a variable for it.
create proc SearchForResultesBySmallerThanDegree_sp (@Degree int)
as
begin
	select * from ResultsTB where St_TotalDegree < @Degree
end


exec SearchForResultesBySmallerThanDegree_sp 100

--------------------------------------------------------------------------------------------

