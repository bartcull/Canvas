USE [CanvasTemp]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[course_section_dim_RAW](
	[id] [bigint] NOT NULL,
	[canvas_id] [bigint] NULL,
	[name] [varchar](256) NULL,
	[course_id] [bigint] NULL,
	[enrollment_term_id] [bigint] NULL,
	[default_section] [bit] NULL,
	[accepting_enrollments] [bit] NULL,
	[can_manually_enroll] [bit] NULL,
	[start_at] [datetime2](7) NULL,
	[end_at] [datetime2](7) NULL,
	[created_at] [datetime2](7) NULL,
	[updated_at] [datetime2](7) NULL,
	[workflow_state] [varchar](256) NULL,
	[restrict_enrollments_to_section_dates] [bit] NULL,
	[nonxlist_course_id] [bigint] NULL,
	[sis_source_id] [varchar](256) NULL,
 CONSTRAINT [PK_course_section_dim_RAW] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
