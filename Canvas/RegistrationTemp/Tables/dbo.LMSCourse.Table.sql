USE [RegistrationTemp]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LMSCourse](
	[SourceID] [bigint] NOT NULL,
	[SemesterID] [varchar](14) NOT NULL,
	[BlueprintCourseID] [varchar](16) NULL,
	[Name] [varchar](256) NULL,
	[Code] [varchar](256) NULL,
	[SISSourceID] [varchar](256) NULL,
	[IsBlueprintCourse] [bit] NOT NULL,
	[IsLMSCrosslisted] [bit] NOT NULL,
	[SectionCount] [int] NOT NULL,
	[LMSCourseCanvasID] [bigint] NOT NULL,
 CONSTRAINT [PK_LMSCourse] PRIMARY KEY CLUSTERED 
(
	[SourceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
