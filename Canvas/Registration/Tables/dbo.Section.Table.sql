USE [Registration]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Section](
	[SectionID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SourceID] [varchar](26) NULL,
	[CourseID] [int] NULL,
	[InstructorID] [int] NULL,
	[SemesterID] [int] NULL,
	[OnlineDevSemesterID] [int] NULL,
	[OnlineStartSemesterID] [int] NULL,
	[OnlineStopSemesterID] [int] NULL,
	[OnlinePilotSemesterID] [int] NULL,
	[OnlineManagementGroupID] [int] NULL,
	[OCRID] [int] NULL,
	[DevMangerID] [int] NULL,
	[CourseLeadID] [int] NULL,
	[DevFacultyID] [int] NULL,
	[CourseNumber] [varchar](12) NULL,
	[Title] [varchar](32) NULL,
	[Catalog] [varchar](4) NULL,
	[SectionNumber] [varchar](4) NULL,
	[BeginDate] [date] NULL,
	[EndDate] [date] NULL,
	[Credits] [decimal](4, 1) NULL,
	[Grading] [varchar](24) NULL,
	[SubprogramCode] [varchar](4) NULL,
	[Subprogram] [varchar](24) NULL,
	[Registered] [int] NULL,
	[MaxReg] [int] NULL,
	[OfficialMaxReg] [int] NULL,
	[Remedial] [bit] NULL,
	[OpenEnrollment] [bit] NULL,
	[Creditable] [bit] NULL,
	[Status] [varchar](20) NULL,
	[StatusDate] [date] NULL,
	[ScheduleChange] [bit] NULL,
	[ScheduleChangeDate] [date] NULL,
	[ChangesAllowed] [bit] NULL,
	[ReferenceNumber] [int] NULL,
	[PrintSchd] [varchar](1) NULL,
	[Lecture] [bit] NULL,
	[Lab] [bit] NULL,
	[Online] [bit] NULL,
	[DirectedStudy] [bit] NULL,
	[GuidedInstruction] [bit] NULL,
	[Internship] [bit] NULL,
	[Hybrid] [bit] NULL,
	[InternshipOffTrack] [bit] NULL,
	[StudentTeaching] [bit] NULL,
	[Prepretory] [bit] NULL,
	[Tour] [bit] NULL,
	[Competency] [bit] NULL,
	[MaxWait] [int] NULL,
	[WaitNum] [int] NULL,
	[FeeCode] [nvarchar](4) NULL,
	[Remark] [varchar](32) NULL,
	[OnlineSectionType] [nvarchar](50) NULL,
	[OnlineCourseVersion] [nvarchar](255) NULL,
	[OnlineCourseVariant] [nvarchar](255) NULL,
	[OnlineCancellationDate] [datetime] NULL,
	[OnlineCancellationReason] [nvarchar](255) NULL,
	[ExclusionReason] [varchar](8) NULL,
	[DoNotContract] [bit] NULL,
	[BYUICourseArea] [varchar](4) NULL,
	[CurrentDesignerID] [int] NULL,
	[CourseCrossListed] [varchar](200) NULL,
	[OCRMID] [int] NULL,
	[AlternateCourseNumber] [varchar](12) NULL,
	[LMSCourseID] [int] NULL,
	[PathwayLMSCourseID] [int] NULL,
	[LocationCode] [char](1) NULL,
	[LocationDesc] [varchar](50) NULL,
 CONSTRAINT [PK_Section] PRIMARY KEY CLUSTERED 
(
	[SectionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Section]  WITH NOCHECK ADD  CONSTRAINT [FK_Section_Course] FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([CourseID])
GO
ALTER TABLE [dbo].[Section] NOCHECK CONSTRAINT [FK_Section_Course]
GO
ALTER TABLE [dbo].[Section]  WITH NOCHECK ADD  CONSTRAINT [FK_Section_LMSCourse] FOREIGN KEY([LMSCourseID])
REFERENCES [dbo].[LMSCourse] ([LMSCourseID])
GO
ALTER TABLE [dbo].[Section] NOCHECK CONSTRAINT [FK_Section_LMSCourse]
GO
ALTER TABLE [dbo].[Section]  WITH NOCHECK ADD  CONSTRAINT [FK_Section_OnlineManagementGroup] FOREIGN KEY([OnlineManagementGroupID])
REFERENCES [dbo].[OnlineManagementGroup] ([OnlineManagementGroupID])
GO
ALTER TABLE [dbo].[Section] NOCHECK CONSTRAINT [FK_Section_OnlineManagementGroup]
GO
ALTER TABLE [dbo].[Section]  WITH NOCHECK ADD  CONSTRAINT [FK_Section_PathwayLMSCourse] FOREIGN KEY([PathwayLMSCourseID])
REFERENCES [dbo].[PathwayLMSCourse] ([PathwayLMSCourseID])
GO
ALTER TABLE [dbo].[Section] NOCHECK CONSTRAINT [FK_Section_PathwayLMSCourse]
GO
ALTER TABLE [dbo].[Section]  WITH NOCHECK ADD  CONSTRAINT [FK_Section_Person] FOREIGN KEY([InstructorID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Section] NOCHECK CONSTRAINT [FK_Section_Person]
GO
ALTER TABLE [dbo].[Section]  WITH NOCHECK ADD  CONSTRAINT [FK_Section_Person1] FOREIGN KEY([OCRID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Section] NOCHECK CONSTRAINT [FK_Section_Person1]
GO
ALTER TABLE [dbo].[Section]  WITH NOCHECK ADD  CONSTRAINT [FK_Section_Person2] FOREIGN KEY([DevMangerID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Section] NOCHECK CONSTRAINT [FK_Section_Person2]
GO
ALTER TABLE [dbo].[Section]  WITH NOCHECK ADD  CONSTRAINT [FK_Section_Person3] FOREIGN KEY([CourseLeadID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Section] NOCHECK CONSTRAINT [FK_Section_Person3]
GO
ALTER TABLE [dbo].[Section]  WITH NOCHECK ADD  CONSTRAINT [FK_Section_Person4] FOREIGN KEY([DevFacultyID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Section] NOCHECK CONSTRAINT [FK_Section_Person4]
GO
ALTER TABLE [dbo].[Section]  WITH NOCHECK ADD  CONSTRAINT [FK_Section_Person5] FOREIGN KEY([CurrentDesignerID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Section] NOCHECK CONSTRAINT [FK_Section_Person5]
GO
ALTER TABLE [dbo].[Section]  WITH NOCHECK ADD  CONSTRAINT [FK_Section_Person6] FOREIGN KEY([OCRMID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Section] NOCHECK CONSTRAINT [FK_Section_Person6]
GO
ALTER TABLE [dbo].[Section]  WITH NOCHECK ADD  CONSTRAINT [FK_Section_Semester] FOREIGN KEY([SemesterID])
REFERENCES [dbo].[Semester] ([SemesterID])
GO
ALTER TABLE [dbo].[Section] NOCHECK CONSTRAINT [FK_Section_Semester]
GO
ALTER TABLE [dbo].[Section]  WITH NOCHECK ADD  CONSTRAINT [FK_Section_Semester1] FOREIGN KEY([OnlineDevSemesterID])
REFERENCES [dbo].[Semester] ([SemesterID])
GO
ALTER TABLE [dbo].[Section] NOCHECK CONSTRAINT [FK_Section_Semester1]
GO
ALTER TABLE [dbo].[Section]  WITH NOCHECK ADD  CONSTRAINT [FK_Section_Semester2] FOREIGN KEY([OnlineStartSemesterID])
REFERENCES [dbo].[Semester] ([SemesterID])
GO
ALTER TABLE [dbo].[Section] NOCHECK CONSTRAINT [FK_Section_Semester2]
GO
ALTER TABLE [dbo].[Section]  WITH NOCHECK ADD  CONSTRAINT [FK_Section_Semester3] FOREIGN KEY([OnlineStopSemesterID])
REFERENCES [dbo].[Semester] ([SemesterID])
GO
ALTER TABLE [dbo].[Section] NOCHECK CONSTRAINT [FK_Section_Semester3]
GO
ALTER TABLE [dbo].[Section]  WITH NOCHECK ADD  CONSTRAINT [FK_Section_Semester4] FOREIGN KEY([OnlinePilotSemesterID])
REFERENCES [dbo].[Semester] ([SemesterID])
GO
ALTER TABLE [dbo].[Section] NOCHECK CONSTRAINT [FK_Section_Semester4]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED COLUMNSTORE INDEX [CX_Section] ON [dbo].[Section]
(
	[SectionID],
	[SourceID],
	[CourseID],
	[InstructorID],
	[SemesterID],
	[OnlineDevSemesterID],
	[PathwayLMSCourseID],
	[LocationCode],
	[LocationDesc],
	[BYUICourseArea],
	[CurrentDesignerID],
	[CourseCrossListed],
	[OCRMID],
	[AlternateCourseNumber],
	[LMSCourseID],
	[OnlineCourseVersion],
	[OnlineCourseVariant],
	[OnlineCancellationDate],
	[OnlineCancellationReason],
	[ExclusionReason],
	[DoNotContract],
	[Competency],
	[MaxWait],
	[WaitNum],
	[FeeCode],
	[Remark],
	[OnlineSectionType],
	[Internship],
	[Hybrid],
	[InternshipOffTrack],
	[StudentTeaching],
	[Prepretory],
	[Tour],
	[PrintSchd],
	[Lecture],
	[Lab],
	[Online],
	[DirectedStudy],
	[GuidedInstruction],
	[Status],
	[StatusDate],
	[ScheduleChange],
	[ScheduleChangeDate],
	[ChangesAllowed],
	[ReferenceNumber],
	[Registered],
	[MaxReg],
	[OfficialMaxReg],
	[Remedial],
	[OpenEnrollment],
	[Creditable],
	[BeginDate],
	[EndDate],
	[Credits],
	[Grading],
	[SubprogramCode],
	[Subprogram],
	[CourseLeadID],
	[DevFacultyID],
	[CourseNumber],
	[Title],
	[Catalog],
	[SectionNumber],
	[OnlineStartSemesterID],
	[OnlineStopSemesterID],
	[OnlinePilotSemesterID],
	[OnlineManagementGroupID],
	[OCRID],
	[DevMangerID]
)WITH (DROP_EXISTING = OFF) ON [PRIMARY]
GO
