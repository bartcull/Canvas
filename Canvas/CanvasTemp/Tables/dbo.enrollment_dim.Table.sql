USE [CanvasTemp]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[enrollment_dim](
	[source_id] [bigint] NOT NULL,
	[canvas_id] [bigint] NULL,
	[root_account_id] [bigint] NULL,
	[course_section_id] [bigint] NULL,
	[role_id] [bigint] NULL,
	[type] [varchar](256) NULL,
	[workflow_state] [varchar](256) NULL,
	[created_at] [datetime2](7) NULL,
	[updated_at] [datetime2](7) NULL,
	[start_at] [datetime2](7) NULL,
	[end_at] [datetime2](7) NULL,
	[completed_at] [datetime2](7) NULL,
	[self_enrolled] [bit] NULL,
	[sis_source_id] [varchar](256) NULL,
	[course_id] [bigint] NULL,
	[user_id] [bigint] NULL,
	[last_activity_at] [datetime2](7) NULL,
 CONSTRAINT [PK_enrollment_dim] PRIMARY KEY CLUSTERED 
(
	[source_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
