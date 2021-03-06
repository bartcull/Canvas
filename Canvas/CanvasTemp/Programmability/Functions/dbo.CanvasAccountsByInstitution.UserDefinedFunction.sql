USE [CanvasTemp]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*=========================================================================================================================
CHANGE LOG:
**WHEN**        **WHO**             **WHAT**
2020-05-12      Bart Cullimore      Created proc.
2020-06-26      Bart Cullimore      Forcing blueprint accounts
2020-09-02      Bart Cullimore      Added 107060000000000001 and 107060000000000048 to BYUI
04/26/2021      Bart Cullimore      Moved to CanvasDataTemp
============================================================================================================================*/

CREATE FUNCTION [dbo].[CanvasAccountsByInstitution]
(
    @Institution NVARCHAR(10)
)
RETURNS @Accounts TABLE
(
    account_id BIGINT NOT NULL
   ,name VARCHAR(256) NULL
   ,subaccount1 VARCHAR(256) NULL
   ,subaccount2 VARCHAR(256) NULL
)
AS
BEGIN

    IF @Institution = 'BYUI'
        INSERT INTO @Accounts   
        SELECT DISTINCT id AS account_id
              ,ad.name
              ,ad.subaccount1
              ,ad.subaccount2
          FROM dbo.account_dim_RAW AS ad
         WHERE ad.workflow_state = 'active'
           AND (    ad.id in (107060000000000001, 107060000000000048) --A lot of test courses/modules are at these levels, so need to filter them out in ActiveCourse
                    OR (ad.subaccount1_id = 107060000000000048) --BYUI
                    OR ad.subaccount2_id IN ( 107060000000000096 ) --Devotional
                    OR (ad.subaccount1_id = 107060000000000005 --Online
                            AND
                            (
                                (ad.subaccount2 NOT LIKE 'Online Prototype Subaccount'
                                    AND ad.subaccount2 NOT LIKE '%Portfolio%' --Exclude LDSBC Portfolio, Cindy's, and Jim's
                                )
                                OR (ad.subaccount2 IN ( 'Design Portfolios', 'Semester Blueprint' )
                                    AND ad.name LIKE '%Blueprint%' --Include Blueprint courses
                                )
                            )
                       )
               )
    ELSE IF @Institution = 'Pathway'
        INSERT INTO @Accounts
        SELECT DISTINCT id AS account_id
              ,ad.name
              ,ad.subaccount1
              ,ad.subaccount2
          FROM dbo.account_dim_RAW AS ad
         WHERE ad.workflow_state = 'active'
           AND ad.id <> 107060000000000024 --Only test courses/modules are at root level
           AND ad.subaccount1_id = 107060000000000024 --Pathway

    RETURN
END

GO
