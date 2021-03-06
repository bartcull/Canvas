USE [CanvasTemp]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cleanSectionEnrollment](
	[LMSEnrollmentID] [bigint] NOT NULL,
	[SemesterSourceID] [varchar](14) NOT NULL,
	[CourseSourceID] [varchar](16) NOT NULL,
	[SectionSourceID] [varchar](26) NOT NULL,
	[LMSCourseID] [bigint] NOT NULL,
	[LMSCourseCanvasID] [bigint] NOT NULL,
	[LMSCourseSectionID] [bigint] NOT NULL,
	[LMSCourseSectionCanvasID] [bigint] NOT NULL,
	[LMSCourseSectionSISID] [varchar](256) NOT NULL,
	[LMSUserID] [bigint] NOT NULL,
	[LMSUserCanvasID] [bigint] NOT NULL,
	[CurrentLoginAtUTC] [datetime2](7) NULL,
	[LastActivityAtUTC] [datetime2](7) NULL,
	[CurrentLoginAt] [datetime2](7) NULL,
	[LastActivityAt] [datetime2](7) NULL,
	[Institution] [varchar](20) NOT NULL,
	[PersonSourceID] [bigint] NOT NULL,
	[EnrollmentSourceID] [int] NULL,
	[EnrollmentType] [varchar](256) NOT NULL,
	[EnrollmentSectionRank] [int] NOT NULL,
	[EnrollmentCourseRank] [int] NOT NULL,
	[WorkflowState] [varchar](20) NULL,
	[PathwayEnrollmentSourceID] [varchar](100) NULL,
	[DepartmentCode] [varchar](4) NULL,
	[SemesterWithoutSubsessionSourceID] [varchar](14) NOT NULL,
	[UserName] [varchar](50) NULL,
	[StudentAcademicSourceID] [varchar](26) NULL,
	[StudentTermSourceID] [varchar](50) NULL,
 CONSTRAINT [PK_cleanSectionEnrollment] PRIMARY KEY CLUSTERED 
(
	[LMSEnrollmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
