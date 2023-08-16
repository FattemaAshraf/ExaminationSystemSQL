CREATE DATABASE Examination_system ;

USE Examination_system;
GO

-- Create the AdminTB table
CREATE TABLE AdminTB (
    Admin_Id INT PRIMARY KEY,
    Admin_Name VARCHAR(50),
    Admin_Username VARCHAR(50),
    Admin_Password VARCHAR(50)
);

-- Create the Trak table
CREATE TABLE Trak (
    Trak_Id INT PRIMARY KEY,
    Trak_Name VARCHAR(50)
);

-- Create the Trak_CoursesTB table
CREATE TABLE Trak_CoursesTB (
    Trak_Id INT FOREIGN KEY REFERENCES Trak(Trak_Id),
    Cur_Id INT FOREIGN KEY REFERENCES CoursesTB(Cur_Id)
);
Use Examination_system
-- Create the CoursesTB table
CREATE TABLE CoursesTB (
    Cur_Id INT PRIMARY KEY,
    Cur_Name VARCHAR(50),
    Cur_Description VARCHAR(500),
    Cur_MaxDegree INT,
    Cur_MinDegree INT
);

Use Examination_system

-- Create the Course_InstractorTB table
CREATE TABLE Course_InstractorTB (
    Cur_Id INT FOREIGN KEY REFERENCES CoursesTB(Cur_Id),
    Ins_Id INT FOREIGN KEY REFERENCES InstractorTB(Ins_Id),
    Year INT
);

-- Create the InstractorTB table
CREATE TABLE InstractorTB (
    Ins_Id INT PRIMARY KEY,
    Ins_Name VARCHAR(50),
    Ins_UserName VARCHAR(50),
    Ins_Password VARCHAR(50),
    Ins_HireDate DATE,
    MG_Id INT
);

-- Create the ExamsTB table
CREATE TABLE ExamsTB (
    Ex_Id INT PRIMARY KEY,
    Ex_Name VARCHAR(50),
    Ex_Type VARCHAR(50),
    Ex_StartTime DATETIME,
    Ex_EndTime DATETIME,
    Ex_Duration INT,
    Ins_Id INT FOREIGN KEY REFERENCES InstractorTB(Ins_Id),
    Cur_Id INT FOREIGN KEY REFERENCES CoursesTB(Cur_Id)
);

-- Create the StudentTB table
CREATE TABLE StudentTB (
    St_Id INT PRIMARY KEY,
    St_Name VARCHAR(50),
    St_UserName VARCHAR(50),
    St_Password VARCHAR(50),
    St_Phone VARCHAR(50),
    Trak_Id INT FOREIGN KEY REFERENCES Trak(Trak_Id)
);
Use Examination_system

-- Create the Exam_Questions table
CREATE TABLE Exam_Questions (
    Q_Id INT PRIMARY KEY,
    Q_Title VARCHAR(500),
    Q_ChoiceA VARCHAR(500),
    Q_ChoiceB VARCHAR(500),
    Q_ChoiceC VARCHAR(500),
    Q_ChoiceD VARCHAR(500),
    Q_CorrectAnswer VARCHAR(500),
    Q_Degree INT,
    Q_type VARCHAR(50),
    Cur_Id INT FOREIGN KEY REFERENCES CoursesTB(Cur_Id),
    Ex_Id INT FOREIGN KEY REFERENCES ExamsTB(Ex_Id)
);

Use Examination_system

-- Create the ResultsTB table
CREATE TABLE ResultsTB (
    St_Id INT FOREIGN KEY REFERENCES StudentTB(St_Id),
    Ex_Id INT FOREIGN KEY REFERENCES ExamsTB(Ex_Id),
    St_TotalDegree INT
);
Use Examination_system

-- Create the QuestionsTB table
CREATE TABLE QuestionsTB (
    Q_Id INT PRIMARY KEY,
    Q_Title VARCHAR(500),
    Q_ChoiceA VARCHAR(500),
    Q_ChoiceB VARCHAR(500),
    Q_ChoiceC VARCHAR(500),
    Q_ChoiceD VARCHAR(500),
    Q_CorrectAnswer VARCHAR(500),
    Q_Degree INT,
    Q_type VARCHAR(50),
    Cur_Id INT,
    Ex_Id INT
);
Use Examination_system

-- Create the StudentAswerTB table
CREATE TABLE StudentAswerTB (
    St_Id INT FOREIGN KEY REFERENCES StudentTB(St_Id),
    Ex_Id INT FOREIGN KEY REFERENCES ExamsTB(Ex_Id),
    Q_Id INT FOREIGN KEY REFERENCES Exam_Questions(Q_Id),
    St_Answer VARCHAR(500),
    St_degree INT
);