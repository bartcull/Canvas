USE [CanvasTemp]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*=========================================================================================================================
CHANGE LOG:
**WHEN**        **WHO**             **WHAT**
2020-05-12      Bart Cullimore      Created function
2020-08-18      Bart Cullimore      Added check against Person table. Also added ROW_NUMBER() to select top INumber and 
                                    PathwaySourceID. Previously, we used position=1 to select only one pseudonym row per user,
                                    but about 35 users didn't have a position 1 row. Also using MAX(pd.current_login_at) to
                                    get the last time user signed in under any pseudonym.
2020-10-01      Bart Cullimore      Added pd.unique_name
04/26/2021      Bart Cullimore      Moved to CanvasDataTemp
============================================================================================================================*/

CREATE FUNCTION [dbo].[CanvasPerson]()
RETURNS TABLE
AS
RETURN  WITH BYUI
       AS (SELECT pd.user_id
                 ,CASE
                      WHEN pd.sis_user_id NOT LIKE '%[^0-9]%' THEN
                          CAST(pd.sis_user_id AS BIGINT)
                      ELSE
                          NULL
                  END AS sis_user_id
                 ,pd.current_login_at
                 ,pd.unique_name
                 ,ROW_NUMBER() OVER (PARTITION BY pd.user_id
                                         ORDER BY pd.current_login_at DESC
                                                 ,pd.position ASC
                                    ) AS pos
             FROM dbo.user_dim_RAW AS ud
            INNER JOIN dbo.pseudonym_dim_RAW AS pd
               ON pd.user_id = ud.id
            INNER JOIN Registration.dbo.Person AS p
               ON p.SourceID = TRY_CAST(pd.sis_user_id AS INT)
            WHERE ud.workflow_state <> 'deleted'
              AND pd.workflow_state = 'active'
              AND pd.sis_user_id NOT LIKE '%[^0-9]%' --Non-numeric INumbers. Takes care of NULL values as well.
              AND LEN(pd.sis_user_id) < 10)
           ,Pathway
       AS (SELECT pd.user_id
                 ,ud.canvas_id
                 ,CASE
                      WHEN pd.sis_user_id NOT LIKE '%[^0-9]%' THEN
                          CAST(pd.sis_user_id AS BIGINT)
                      ELSE
                          NULL
                  END AS sis_user_id
                 ,pd.current_login_at
                 ,ROW_NUMBER() OVER (PARTITION BY pd.user_id
                                         ORDER BY pd.current_login_at DESC
                                                 ,pd.position ASC
                                    ) AS pos
             FROM dbo.user_dim_RAW AS ud
            INNER JOIN dbo.pseudonym_dim_RAW AS pd
               ON pd.user_id = ud.id
            WHERE ud.workflow_state <> 'deleted'
              AND pd.workflow_state = 'active'
              AND pd.sis_user_id NOT LIKE '%[^0-9]%' --Non-numeric INumbers. Takes care of NULL values as well.
              AND LEN(pd.sis_user_id) > 9)
           ,AllUsers
       AS (SELECT pd.user_id
                 ,ud.canvas_id
                 ,MAX(pd.current_login_at) AS current_login_at
             FROM dbo.user_dim_RAW AS ud
            INNER JOIN dbo.pseudonym_dim_RAW AS pd
               ON pd.user_id = ud.id
            WHERE ud.name NOT LIKE '%Test Student%'
              AND ud.name NOT LIKE '%TestStudent%'
              AND ud.name NOT LIKE '%Test User%'
              AND ud.name NOT LIKE '% Test'
              AND ud.name NOT LIKE 'Test %'
              AND ud.name NOT LIKE '% Test %'
              AND ud.name NOT LIKE 'TD Test %'
              AND ud.name NOT LIKE 'BYUICanvasTest'
              AND ud.name NOT LIKE 'Testy Tester'
              AND ud.name NOT LIKE 'LTIAdmin Testout'
              AND ud.name NOT LIKE 'danes testpathuser'
              AND ud.workflow_state <> 'deleted'
              AND pd.workflow_state = 'active'
              AND pd.unique_name NOT IN ( 'Bensbackdoor', 'danebeingbad', 'dbmarket2', 'fadmin', 'iwidgetlearn'
                                         ,'testeer'
                                        )
              AND pd.unique_name NOT LIKE 'ccd[_]%'
              AND pd.unique_name NOT LIKE 'cct[_]%'
              AND pd.unique_name NOT LIKE 'ftc[_]%'
              AND pd.unique_name NOT LIKE 'ol[_]%'
              AND pd.sis_user_id NOT LIKE '%[^0-9]%' --Non-numeric INumbers. Takes care of NULL values as well.
            GROUP BY pd.user_id
                    ,ud.canvas_id)
       SELECT au.user_id
             ,au.canvas_id
             ,COALESCE(BYUI.sis_user_id, Pathway.sis_user_id) AS sis_user_id
             ,au.current_login_at
             ,BYUI.sis_user_id AS byui_person_source_id
             ,Pathway.sis_user_id AS pathway_student_source_id
             ,BYUI.unique_name
         FROM AllUsers AS au
         LEFT JOIN BYUI
           ON BYUI.user_id = au.user_id
          AND BYUI.pos = 1
         LEFT JOIN Pathway
           ON Pathway.user_id = au.user_id
          AND Pathway.pos = 1
        WHERE (BYUI.sis_user_id IS NOT NULL OR Pathway.sis_user_id IS NOT NULL)

GO
