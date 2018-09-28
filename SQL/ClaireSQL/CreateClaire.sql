USE [Dev_Claire_DataWarehouse]
GO

/****** Object:  Table [dbo].[Claire]    Script Date: 28/09/2018 10:24:45 ******/
DROP TABLE [dbo].[Claire]
GO

/****** Object:  Table [dbo].[Claire]    Script Date: 28/09/2018 10:24:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Claire](
	[StudentID] [int] NOT NULL,
	[StudentForename] [nvarchar](50) NULL,
	[StudentSurname] [nvarchar](50) NULL,
	[StudentGender] [nvarchar](10) NULL,
	[StudentFaculty] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[StudentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


