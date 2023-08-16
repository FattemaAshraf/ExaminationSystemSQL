USE Examination_system
go
-- to get Admin Information
create view AdminInfo(ID,[Name],UserName)
as
(	
	select Admin_Id,Admin_Name,Admin_Username from AdminTB 
)
select * from AdminInfo



-- to get Students Resultes
create view StudentResults(StudentID,ExamID , Student_Degree)
as
(
	select * from ResultsTB
)
select * from StudentResults
