USE [CanvasTemp]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pseudonym_dim_RAW](
	[id] [bigint] NOT NULL,
	[canvas_id] [bigint] NULL,
	[user_id] [bigint] NULL,
	[account_id] [bigint] NULL,
	[workflow_state] [varchar](256) NULL,
	[last_request_at] [datetime2](7) NULL,
	[last_login_at] [datetime2](7) NULL,
	[current_login_at] [datetime2](7) NULL,
	[last_login_ip] [varchar](256) NULL,
	[current_login_ip] [varchar](256) NULL,
	[position] [int] NULL,
	[created_at] [datetime2](7) NULL,
	[updated_at] [datetime2](7) NULL,
	[password_auto_generated] [bit] NULL,
	[deleted_at] [datetime2](7) NULL,
	[sis_user_id] [varchar](256) NULL,
	[unique_name] [varchar](256) NULL,
	[integration_id] [varchar](256) NULL,
	[authentication_provider_id] [bigint] NULL,
 CONSTRAINT [PK_pseudonym_dim_RAW] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
