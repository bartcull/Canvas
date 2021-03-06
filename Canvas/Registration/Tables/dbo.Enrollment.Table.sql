USE [Registration]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Enrollment](
	[EnrollmentID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SourceID] [int] NOT NULL,
	[PersonID] [int] NOT NULL,
	[CourseID] [int] NULL,
	[SectionID] [int] NULL,
	[SemesterID] [int] NULL,
	[StudentAcademicID] [int] NULL,
	[StudentID] [int] NULL,
	[InstructorID] [int] NULL,
	[ApplicantID] [int] NULL,
	[PathwayCWID] [int] NULL,
	[CourseNumber] [varchar](12) NULL,
	[CourseTitle] [varchar](32) NULL,
	[SectionNumber] [varchar](2) NULL,
	[Catalog] [varchar](50) NULL,
	[Credits] [numeric](6, 3) NULL,
	[FinalGrade] [varchar](3) NULL,
	[MidtermGrade] [varchar](3) NULL,
	[Status] [varchar](20) NULL,
	[Session] [varchar](24) NULL,
	[Grading] [varchar](24) NULL,
	[Counting] [varchar](24) NULL,
	[RepeatCode] [varchar](2) NULL,
	[RepeatDescription] [varchar](24) NULL,
	[RegistrationCategory] [varchar](24) NULL,
	[TempFinalGrade] [varchar](3) NULL,
	[TempMidTermGrade] [varchar](3) NULL,
	[RequiredCourseNumber] [varchar](12) NULL,
	[SubstituteUpdateDate] [datetime] NULL,
	[OfficialEnrollments] [bit] NULL,
	[WaitList] [varchar](4) NULL,
	[Participated] [varchar](1) NULL,
	[CumAttemptedHrs] [numeric](6, 3) NULL,
	[CumEarnedHrs] [numeric](6, 3) NULL,
	[CumPassedHrs] [numeric](6, 3) NULL,
	[CumQualityHrs] [numeric](6, 3) NULL,
	[Points] [numeric](4, 1) NULL,
	[EarnedHrs] [numeric](6, 3) NULL,
	[ETLLoadDate] [datetime] NULL,
	[ETLLastUpdateDate] [datetime] NULL,
	[CourseRetakeRank] [int] NULL,
	[OfficialEnrollmentsWithSecondBlock] [bit] NULL,
	[dimStudentTermID] [int] NULL,
	[PreviousEnrollmentID] [int] NULL,
	[PathwayEnrollment] [bit] NULL,
	[MaxEnrollmentPeriod] [bit] NULL,
	[MaxEnrollmentPeriodWithSecondBlock] [bit] NULL,
	[RegisteredDateID] [int] NULL,
	[DropWithdrawDateID] [int] NULL,
	[IsProgramApplicable] [bit] NULL,
 CONSTRAINT [PK_Enrollment] PRIMARY KEY CLUSTERED 
(
	[EnrollmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX [IX_OfficalEnrollments_SectionID_dimStudentTermID] ON [dbo].[Enrollment]
(
	[OfficialEnrollments] ASC
)
INCLUDE ( 	[SectionID],
	[dimStudentTermID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SectionID_Semester_ID_RegisteredDateID_DropWithdrawDateID] ON [dbo].[Enrollment]
(
	[SectionID] ASC
)
INCLUDE ( 	[SemesterID],
	[RegisteredDateID],
	[DropWithdrawDateID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Enrollment]  WITH NOCHECK ADD  CONSTRAINT [FK_Enrollment_Applicant] FOREIGN KEY([ApplicantID])
REFERENCES [dbo].[Applicant] ([ApplicantID])
GO
ALTER TABLE [dbo].[Enrollment] NOCHECK CONSTRAINT [FK_Enrollment_Applicant]
GO
ALTER TABLE [dbo].[Enrollment]  WITH NOCHECK ADD  CONSTRAINT [FK_Enrollment_Course] FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([CourseID])
GO
ALTER TABLE [dbo].[Enrollment] NOCHECK CONSTRAINT [FK_Enrollment_Course]
GO
ALTER TABLE [dbo].[Enrollment]  WITH NOCHECK ADD  CONSTRAINT [FK_Enrollment_dimDate] FOREIGN KEY([RegisteredDateID])
REFERENCES [dbo].[Date] ([dimDateID])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[Enrollment] NOCHECK CONSTRAINT [FK_Enrollment_dimDate]
GO
ALTER TABLE [dbo].[Enrollment]  WITH NOCHECK ADD  CONSTRAINT [FK_Enrollment_dimDate1] FOREIGN KEY([DropWithdrawDateID])
REFERENCES [dbo].[Date] ([dimDateID])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[Enrollment] NOCHECK CONSTRAINT [FK_Enrollment_dimDate1]
GO
ALTER TABLE [dbo].[Enrollment]  WITH NOCHECK ADD  CONSTRAINT [FK_Enrollment_dimStudentTerm] FOREIGN KEY([dimStudentTermID])
REFERENCES [dbo].[StudentTerm] ([StudentTermID])
GO
ALTER TABLE [dbo].[Enrollment] NOCHECK CONSTRAINT [FK_Enrollment_dimStudentTerm]
GO
ALTER TABLE [dbo].[Enrollment]  WITH NOCHECK ADD  CONSTRAINT [FK_Enrollment_Enrollment] FOREIGN KEY([PreviousEnrollmentID])
REFERENCES [dbo].[Enrollment] ([EnrollmentID])
GO
ALTER TABLE [dbo].[Enrollment] NOCHECK CONSTRAINT [FK_Enrollment_Enrollment]
GO
ALTER TABLE [dbo].[Enrollment]  WITH NOCHECK ADD  CONSTRAINT [FK_Enrollment_Instructor] FOREIGN KEY([InstructorID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Enrollment] NOCHECK CONSTRAINT [FK_Enrollment_Instructor]
GO
ALTER TABLE [dbo].[Enrollment]  WITH NOCHECK ADD  CONSTRAINT [FK_Enrollment_PathwayCW] FOREIGN KEY([PathwayCWID])
REFERENCES [dbo].[PathwayCW] ([PathwayCWID])
GO
ALTER TABLE [dbo].[Enrollment] NOCHECK CONSTRAINT [FK_Enrollment_PathwayCW]
GO
ALTER TABLE [dbo].[Enrollment]  WITH NOCHECK ADD  CONSTRAINT [FK_Enrollment_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Enrollment] NOCHECK CONSTRAINT [FK_Enrollment_Person]
GO
ALTER TABLE [dbo].[Enrollment]  WITH NOCHECK ADD  CONSTRAINT [FK_Enrollment_Section] FOREIGN KEY([SectionID])
REFERENCES [dbo].[Section] ([SectionID])
GO
ALTER TABLE [dbo].[Enrollment] NOCHECK CONSTRAINT [FK_Enrollment_Section]
GO
ALTER TABLE [dbo].[Enrollment]  WITH NOCHECK ADD  CONSTRAINT [FK_Enrollment_Semester] FOREIGN KEY([SemesterID])
REFERENCES [dbo].[Semester] ([SemesterID])
GO
ALTER TABLE [dbo].[Enrollment] NOCHECK CONSTRAINT [FK_Enrollment_Semester]
GO
ALTER TABLE [dbo].[Enrollment]  WITH NOCHECK ADD  CONSTRAINT [FK_Enrollment_Student] FOREIGN KEY([StudentID])
REFERENCES [dbo].[Student] ([StudentID])
GO
ALTER TABLE [dbo].[Enrollment] NOCHECK CONSTRAINT [FK_Enrollment_Student]
GO
ALTER TABLE [dbo].[Enrollment]  WITH NOCHECK ADD  CONSTRAINT [FK_Enrollment_StudentAcademic] FOREIGN KEY([StudentAcademicID])
REFERENCES [dbo].[StudentAcademic] ([StudentAcademicID])
GO
ALTER TABLE [dbo].[Enrollment] NOCHECK CONSTRAINT [FK_Enrollment_StudentAcademic]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED COLUMNSTORE INDEX [CX_Enrollment] ON [dbo].[Enrollment]
(
	[EnrollmentID],
	[SourceID],
	[PersonID],
	[CourseID],
	[SectionID],
	[SemesterID],
	[StudentAcademicID],
	[StudentID],
	[InstructorID],
	[ApplicantID],
	[PathwayCWID],
	[CourseNumber],
	[CourseTitle],
	[SectionNumber],
	[Catalog],
	[Credits],
	[FinalGrade],
	[MidtermGrade],
	[Status],
	[Session],
	[Grading],
	[Counting],
	[RepeatCode],
	[RepeatDescription],
	[RegistrationCategory],
	[TempFinalGrade],
	[TempMidTermGrade],
	[RequiredCourseNumber],
	[SubstituteUpdateDate],
	[OfficialEnrollments],
	[WaitList],
	[Participated],
	[CumAttemptedHrs],
	[CumEarnedHrs],
	[CumPassedHrs],
	[CumQualityHrs],
	[Points],
	[EarnedHrs],
	[ETLLoadDate],
	[ETLLastUpdateDate],
	[CourseRetakeRank],
	[OfficialEnrollmentsWithSecondBlock],
	[dimStudentTermID],
	[PreviousEnrollmentID],
	[PathwayEnrollment],
	[MaxEnrollmentPeriod],
	[MaxEnrollmentPeriodWithSecondBlock],
	[RegisteredDateID],
	[DropWithdrawDateID],
	[IsProgramApplicable]
)WITH (DROP_EXISTING = OFF) ON [PRIMARY]
GO
