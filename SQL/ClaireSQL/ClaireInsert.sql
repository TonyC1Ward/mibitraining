USE [Dev_Claire_DataWarehouse]
GO

INSERT INTO [dbo].[Claire]
           ([StudentID]
           ,[StudentForename]
           ,[StudentSurname]
           ,[StudentGender]
           ,[StudentFaculty])
     VALUES
           (990876     --<StudentID, int,>
           ,'Tony'     --<StudentForename, nvarchar(50),>
           ,'Ward'     --<StudentSurname, nvarchar(50),>
           ,'Male'     --<StudentGender, nvarchar(10),>
           ,'ICT'     --<StudentFaculty, nvarchar(50),>
		   );


