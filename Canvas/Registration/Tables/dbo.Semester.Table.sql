USE [Registration]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Semester](
	[SemesterID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SourceID] [varchar](14) NULL,
	[CatalogID] [int] NULL,
	[TermCode] [varchar](4) NULL,
	[Term] [varchar](29) NULL,
	[Year] [varchar](4) NULL,
	[AcademicYear] [varchar](4) NULL,
	[FAYear] [varchar](4) NULL,
	[Session] [varchar](24) NULL,
	[Subsession] [varchar](24) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[FirstRegistrationDate] [datetime] NULL,
	[LastRegistrationDate] [datetime] NULL,
	[LastAddDate] [datetime] NULL,
	[LastDropDate] [datetime] NULL,
	[LastWithdrawalDate] [datetime] NULL,
	[FirstStudentRegistrationDate] [datetime] NULL,
	[LastStudentRegistrationDate] [datetime] NULL,
	[LastGradeUpdateDate] [datetime] NULL,
	[SemesterOrder] [int] NULL,
	[SessionOrder] [int] NULL,
	[GradDate] [datetime] NULL,
	[CurrentSemester] [bit] NULL,
	[PreviousSemester] [bit] NULL,
	[NextSemester] [bit] NULL,
	[CurrentSession] [bit] NULL,
	[PreviousSession] [bit] NULL,
	[NextSession] [bit] NULL,
	[CurrentSemesterWithBreak] [bit] NULL,
	[PreviousSemesterWithBreak] [bit] NULL,
	[NextSemesterWithBreak] [bit] NULL,
	[ETLLoadDate] [datetime] NULL,
	[ETLLastUpdateDate] [datetime] NULL,
	[WithdrawalDeadline] [datetime] NULL,
	[NextMajorSemesterSemesterID] [int] NULL,
	[AcademicReportingYear] [varchar](4) NULL,
	[CurrentSemesterWithPriorBreak] [bit] NULL,
	[SemesterOrderRelativeToCurrent] [int] NULL,
	[SessionOrderRelativeToCurrent] [int] NULL,
 CONSTRAINT [PK_Semester] PRIMARY KEY CLUSTERED 
(
	[SemesterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Semester]  WITH NOCHECK ADD  CONSTRAINT [FK_Semester_Catalog] FOREIGN KEY([CatalogID])
REFERENCES [dbo].[Catalog] ([CatalogID])
GO
ALTER TABLE [dbo].[Semester] NOCHECK CONSTRAINT [FK_Semester_Catalog]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED COLUMNSTORE INDEX [CX_Semester] ON [dbo].[Semester]
(
	[SemesterID],
	[SourceID],
	[CatalogID],
	[TermCode],
	[Term],
	[Year],
	[AcademicYear],
	[FAYear],
	[Session],
	[Subsession],
	[StartDate],
	[EndDate],
	[FirstRegistrationDate],
	[LastRegistrationDate],
	[LastAddDate],
	[LastDropDate],
	[LastWithdrawalDate],
	[FirstStudentRegistrationDate],
	[LastStudentRegistrationDate],
	[LastGradeUpdateDate],
	[SemesterOrder],
	[SessionOrder],
	[GradDate],
	[CurrentSemester],
	[PreviousSemester],
	[NextSemester],
	[CurrentSession],
	[PreviousSession],
	[NextSession],
	[CurrentSemesterWithBreak],
	[PreviousSemesterWithBreak],
	[NextSemesterWithBreak],
	[ETLLoadDate],
	[ETLLastUpdateDate],
	[WithdrawalDeadline],
	[NextMajorSemesterSemesterID],
	[AcademicReportingYear],
	[CurrentSemesterWithPriorBreak],
	[SemesterOrderRelativeToCurrent],
	[SessionOrderRelativeToCurrent]
)WITH (DROP_EXISTING = OFF) ON [PRIMARY]
GO
