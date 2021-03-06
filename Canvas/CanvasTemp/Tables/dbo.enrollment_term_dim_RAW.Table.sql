USE [CanvasTemp]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[enrollment_term_dim_RAW](
	[id] [bigint] NOT NULL,
	[canvas_id] [bigint] NULL,
	[root_account_id] [bigint] NULL,
	[name] [varchar](256) NULL,
	[date_start] [datetime2](7) NULL,
	[date_end] [datetime2](7) NULL,
	[sis_source_id] [varchar](256) NULL,
 CONSTRAINT [PK_enrollment_term_dim_RAW] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
