USE [CanvasTemp]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[account_dim_RAW](
	[id] [bigint] NOT NULL,
	[canvas_id] [bigint] NULL,
	[name] [varchar](256) NULL,
	[depth] [int] NULL,
	[workflow_state] [varchar](256) NULL,
	[parent_account] [varchar](256) NULL,
	[parent_account_id] [bigint] NULL,
	[grandparent_account] [varchar](256) NULL,
	[grandparent_account_id] [bigint] NULL,
	[root_account] [varchar](256) NULL,
	[root_account_id] [bigint] NULL,
	[subaccount1] [varchar](256) NULL,
	[subaccount1_id] [bigint] NULL,
	[subaccount2] [varchar](256) NULL,
	[subaccount2_id] [bigint] NULL,
	[subaccount3] [varchar](256) NULL,
	[subaccount3_id] [bigint] NULL,
	[subaccount4] [varchar](256) NULL,
	[subaccount4_id] [bigint] NULL,
	[subaccount5] [varchar](256) NULL,
	[subaccount5_id] [bigint] NULL,
	[subaccount6] [varchar](256) NULL,
	[subaccount6_id] [bigint] NULL,
	[subaccount7] [varchar](256) NULL,
	[subaccount7_id] [bigint] NULL,
	[subaccount8] [varchar](256) NULL,
	[subaccount8_id] [bigint] NULL,
	[subaccount9] [varchar](256) NULL,
	[subaccount9_id] [bigint] NULL,
	[subaccount10] [varchar](256) NULL,
	[subaccount10_id] [bigint] NULL,
	[subaccount11] [varchar](256) NULL,
	[subaccount11_id] [bigint] NULL,
	[subaccount12] [varchar](256) NULL,
	[subaccount12_id] [bigint] NULL,
	[subaccount13] [varchar](256) NULL,
	[subaccount13_id] [bigint] NULL,
	[subaccount14] [varchar](256) NULL,
	[subaccount14_id] [bigint] NULL,
	[subaccount15] [varchar](256) NULL,
	[subaccount15_id] [bigint] NULL,
	[sis_source_id] [varchar](256) NULL,
 CONSTRAINT [PK_account_dim_RAW] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
