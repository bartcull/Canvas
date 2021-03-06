USE [CanvasTemp]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[course_dim_RAW](
	[id] [bigint] NOT NULL,
	[canvas_id] [bigint] NULL,
	[root_account_id] [bigint] NULL,
	[account_id] [bigint] NULL,
	[enrollment_term_id] [bigint] NULL,
	[name] [varchar](256) NULL,
	[code] [varchar](256) NULL,
	[type] [varchar](256) NULL,
	[created_at] [datetime2](7) NULL,
	[start_at] [datetime2](7) NULL,
	[conclude_at] [datetime2](7) NULL,
	[publicly_visible] [bit] NULL,
	[sis_source_id] [varchar](256) NULL,
	[workflow_state] [varchar](256) NULL,
	[wiki_id] [bigint] NULL,
	[syllabus_body] [varchar](max) NULL,
 CONSTRAINT [PK_course_dim_RAW] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
