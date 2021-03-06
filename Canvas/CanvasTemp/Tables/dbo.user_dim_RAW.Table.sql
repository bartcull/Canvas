USE [CanvasTemp]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user_dim_RAW](
	[id] [bigint] NOT NULL,
	[canvas_id] [bigint] NULL,
	[root_account_id] [bigint] NULL,
	[name] [varchar](256) NULL,
	[time_zone] [varchar](256) NULL,
	[created_at] [datetime2](7) NULL,
	[visibility] [varchar](256) NULL,
	[school_name] [varchar](256) NULL,
	[school_position] [varchar](256) NULL,
	[gender] [varchar](256) NULL,
	[locale] [varchar](256) NULL,
	[public] [varchar](256) NULL,
	[birthdate] [datetime2](7) NULL,
	[country_code] [varchar](256) NULL,
	[workflow_state] [varchar](256) NULL,
	[sortable_name] [varchar](256) NULL,
	[global_canvas_id] [varchar](256) NULL,
 CONSTRAINT [PK_user_dim_RAW] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
