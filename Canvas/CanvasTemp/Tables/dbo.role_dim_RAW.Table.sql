USE [CanvasTemp]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[role_dim_RAW](
	[id] [bigint] NOT NULL,
	[canvas_id] [bigint] NULL,
	[root_account_id] [bigint] NULL,
	[account_id] [bigint] NULL,
	[name] [varchar](256) NULL,
	[base_role_type] [varchar](256) NULL,
	[workflow_state] [varchar](256) NULL,
	[created_at] [datetime2](7) NULL,
	[updated_at] [datetime2](7) NULL,
	[deleted_at] [datetime2](7) NULL,
 CONSTRAINT [PK_role_dim_RAW] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
