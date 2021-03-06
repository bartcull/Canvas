USE [Registration]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LMSCourse](
	[LMSCourseID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SourceID] [bigint] NOT NULL,
	[SemesterID] [int] NOT NULL,
	[BlueprintCourseID] [int] NULL,
	[Name] [varchar](256) NULL,
	[Code] [varchar](256) NULL,
	[SISSourceID] [varchar](256) NULL,
	[IsBlueprintCourse] [bit] NOT NULL,
	[IsLMSCrosslisted] [bit] NOT NULL,
	[SectionCount] [int] NOT NULL,
	[LMSCourseCanvasID] [bigint] NOT NULL,
	[ETLLoadDate] [datetime2](7) NULL,
	[ETLLastUpdateDate] [datetime2](7) NULL,
	[ETLDeleteDate] [datetime] NULL,
 CONSTRAINT [PK_LMSCourse] PRIMARY KEY CLUSTERED 
(
	[LMSCourseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[LMSCourse]  WITH NOCHECK ADD  CONSTRAINT [FK_LMSCourse_Course] FOREIGN KEY([BlueprintCourseID])
REFERENCES [dbo].[Course] ([CourseID])
GO
ALTER TABLE [dbo].[LMSCourse] NOCHECK CONSTRAINT [FK_LMSCourse_Course]
GO
ALTER TABLE [dbo].[LMSCourse]  WITH NOCHECK ADD  CONSTRAINT [FK_LMSCourse_Semester] FOREIGN KEY([SemesterID])
REFERENCES [dbo].[Semester] ([SemesterID])
GO
ALTER TABLE [dbo].[LMSCourse] NOCHECK CONSTRAINT [FK_LMSCourse_Semester]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED COLUMNSTORE INDEX [CX_LMSCourse] ON [dbo].[LMSCourse]
(
	[LMSCourseID],
	[SourceID],
	[SemesterID],
	[BlueprintCourseID],
	[Name],
	[Code],
	[SISSourceID],
	[IsBlueprintCourse],
	[IsLMSCrosslisted],
	[SectionCount],
	[LMSCourseCanvasID],
	[ETLLoadDate],
	[ETLLastUpdateDate],
	[ETLDeleteDate]
)WITH (DROP_EXISTING = OFF) ON [PRIMARY]
GO
