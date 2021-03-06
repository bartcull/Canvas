USE [CanvasTemp]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cleanActiveCourse](
	[course_id] [bigint] NOT NULL,
	[account_id] [bigint] NOT NULL,
	[Name] [varchar](256) NULL,
	[Code] [varchar](256) NULL,
	[sis_source_id] [varchar](256) NULL,
	[LMSCourseCanvasID] [bigint] NULL,
	[SemesterSourceID] [varchar](10) NULL,
	[SemesterTermCode] [varchar](50) NULL,
	[Institution] [varchar](10) NOT NULL,
 CONSTRAINT [PK_cleanActiveCourse] PRIMARY KEY CLUSTERED 
(
	[course_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
