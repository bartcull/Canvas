USE [CanvasTemp]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*=========================================================================================================================
CHANGE LOG:
**WHEN**       **WHO**              **WHAT**
06/26/2020     Bart Cullimore       Created function
08/03/2020     Bart Cullimore       Added SemesterSourceID to support refreshing based on Semester
09/03/2020     Bart Cullimore       Included missing courses from account_ids 107060000000000001 and 107060000000000048
09/04/2020     Bart Cullimore       Moved to CanvasDataRaw
09/11/2020     Bart Cullimore       Added cleanCourseSemesterTermCode CTE to allow SemesterTermCode for courses that have
                                    a valid csd.sis_source_id but an invalid enrollment_term_id
09/25/2020     Bart Cullimore       Filter out course_dim.workflow_state = 'claimed'
09/30/2020     Bart Cullimore       Restored Blueprint courses and claimed courses that have enrollments
04/26/2021     Bart Cullimore       Moved to CanvasDataTemp
============================================================================================================================*/

CREATE FUNCTION [dbo].[ActiveCourse]
(
    @Institution NVARCHAR(10)
)
RETURNS TABLE
AS
RETURN (
    WITH Enrolled
    AS (SELECT ed.course_id
              ,COUNT(ed.id) AS cnt
          FROM dbo.enrollment_dim_RAW AS ed
         INNER JOIN dbo.course_section_dim_RAW AS csd
            ON ed.course_section_id = csd.id
         WHERE csd.sis_source_id IS NOT NULL
           AND ed.type = 'StudentEnrollment'
           AND ed.workflow_state NOT IN ( 'deleted', 'rejected' )
         GROUP BY ed.course_id)
    ,cleanCourseSemesterTermCode
    AS (SELECT LMSCourseID
            ,SemesterSourceID
            ,SemesterTermCode
            ,ROW_NUMBER() OVER (PARTITION BY LMSCourseID ORDER BY SemesterSourceID DESC) AS rank
        FROM dbo.SectionTerm() --Has logic for including courses that have valid course_section_dim.sis_source_id but incorrect enrollment_term_id
        )
    ,cleanCourse
    AS (
    SELECT cd.account_id
          ,cd.id AS course_id
          ,cd.name AS Name
          ,cd.code AS Code
          ,cd.sis_source_id
          ,cd.canvas_id AS LMSCourseCanvasID
          ,CASE
               WHEN ISNUMERIC(RIGHT(etd.name, 4)) = 0 THEN
                   stc.SemesterSourceID
               WHEN etd.name LIKE 'Winter %' THEN
                   'UNDG' + RIGHT(etd.name, 4) + 'WI'
               WHEN etd.name LIKE 'Spring %' THEN
                   'UNDG' + RIGHT(etd.name, 4) + 'SP'
               WHEN etd.name LIKE 'Summer %' THEN
                   'UNDG' + RIGHT(etd.name, 4) + 'SS'
               WHEN etd.name LIKE 'Fall %' THEN
                   'UNDG' + RIGHT(etd.name, 4) + 'FA'
               ELSE
                   NULL
           END AS SemesterSourceID
          ,COALESCE(stc.SemesterTermCode, etd.name) AS SemesterTermCode
          ,cd.workflow_state
      FROM dbo.course_dim_RAW AS cd
     INNER JOIN dbo.enrollment_term_dim_RAW AS etd
        ON cd.enrollment_term_id = etd.id
      LEFT JOIN cleanCourseSemesterTermCode AS stc --Exclude terms that don't have a year
        ON cd.id = stc.LMSCourseID
       AND stc.rank = 1 --Make sure we only pull in one row per course
     WHERE cd.workflow_state NOT IN ( 'completed', 'created', 'deleted' )
     )

     SELECT cleanCourse.account_id
           ,cleanCourse.course_id
           ,cleanCourse.Name
           ,cleanCourse.Code
           ,cleanCourse.sis_source_id
           ,cleanCourse.LMSCourseCanvasID
           ,cleanCourse.SemesterSourceID
           ,CAST(LEFT(cleanCourse.SemesterTermCode,50) AS VARCHAR(50)) AS SemesterTermCode
           ,CASE WHEN enr.course_id IS NOT NULL THEN 1 ELSE 0 END AS hasEnrollments
      FROM cleanCourse
     INNER JOIN dbo.CanvasAccountsByInstitution(@Institution) AS act --Note Raw data dependency
        ON act.account_id = cleanCourse.account_id
      LEFT JOIN Enrolled AS enr
        ON enr.course_id = cleanCourse.course_id
     WHERE SemesterSourceID IS NOT NULL
       AND ((cleanCourse.workflow_state = 'claimed' AND enr.course_id IS NOT NULL) --Only include a claimed course if it has enrolled students
           OR (cleanCourse.workflow_state = 'claimed' AND cleanCourse.sis_source_id like '%Blueprint%') --Include all Blueprints that are marked 'claimed'
           OR (cleanCourse.workflow_state <> 'claimed' AND
                ( --This excludes test courses in the root directories that don't have students enrolled
                    enr.course_id IS NOT NULL
                    OR cleanCourse.account_id NOT IN ( 107060000000000001, 107060000000000048 )
                )
           ))
)

GO
