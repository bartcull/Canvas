USE [CanvasTemp]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*=========================================================================================================================
OVERVIEW: This function allows us to derive SemesterTermCode on either etd.name or csd.sis_source_id. The latter case is
necessary for courses that are not properly assigned an enrollment_term but do have a valid csd.sis_source_id.

CHANGE LOG:
**WHEN**       **WHO**              **WHAT**
09/11/2020     Bart Cullimore       Created function
04/26/2021     Bart Cullimore       Moved to CanvasDataTemp
============================================================================================================================*/
CREATE  FUNCTION [dbo].[SectionTerm] ()
        RETURNS TABLE
AS
RETURN (
    WITH Section
    AS (--Sections with valid enrollment_term_id
        SELECT csd.id AS LMSCourseSectionID
              ,csd.course_id AS LMSCourseID
              ,csd.canvas_id AS LMSCourseSectionCanvasID
              ,csd.sis_source_id AS CourseSectionCode
              ,etd.name AS SemesterTermCode
          FROM dbo.course_section_dim_RAW AS csd
         INNER JOIN dbo.enrollment_term_dim_RAW AS etd
            ON csd.enrollment_term_id = etd.id
         WHERE csd.sis_source_id IS NOT NULL
           AND csd.workflow_state = 'active'
           AND ISNUMERIC(RIGHT(etd.name, 4)) = 1 --Exclude terms that don't have a year

        UNION ALL

        --Sections that have a valid sis_source_id but not enrollment_term_id
        SELECT csd.id AS LMSCourseSectionID
              ,csd.course_id AS LMSCourseID
              ,csd.canvas_id AS LMSCourseSectionCanvasID
              ,csd.sis_source_id AS CourseSectionCode
              ,CASE
                   WHEN CHARINDEX('.',csd.sis_source_id) > 0
                    AND CHARINDEX('.',csd.sis_source_id,CHARINDEX('.',csd.sis_source_id)+1) > 0
                    AND CHARINDEX('.',csd.sis_source_id, CHARINDEX('.',csd.sis_source_id, CHARINDEX('.',csd.sis_source_id)+1)+1) > 0 THEN
                        SUBSTRING(csd.sis_source_id, CHARINDEX('.',csd.sis_source_id,CHARINDEX('.',csd.sis_source_id)+1)+1, 
                        (CHARINDEX('.',csd.sis_source_id, CHARINDEX('.',csd.sis_source_id, CHARINDEX('.',csd.sis_source_id)+1)+1) 
                        - CHARINDEX('.',csd.sis_source_id, CHARINDEX('.',csd.sis_source_id)+1))-1)
                        + ' ' + SUBSTRING(csd.sis_source_id,CHARINDEX('.',csd.sis_source_id)+1, 4)
                   ELSE 
                       NULL
               END AS SemesterTermCode
          FROM dbo.course_section_dim_RAW AS csd
         INNER JOIN dbo.enrollment_term_dim_RAW AS etd
            ON csd.enrollment_term_id = etd.id
         WHERE csd.sis_source_id IS NOT NULL
           AND csd.workflow_state = 'active'
           AND ISNUMERIC(RIGHT(etd.name, 4)) = 0
           AND (csd.sis_source_id LIKE '%Winter%' OR csd.sis_source_id LIKE '%Spring%' OR csd.sis_source_id LIKE '%Summer%' OR csd.sis_source_id LIKE '%Fall%')
           AND csd.sis_source_id LIKE '%.20[1-9][0-9]%' --Has year 2010 or greater
           AND CHARINDEX('.',csd.sis_source_id, CHARINDEX('.',csd.sis_source_id, CHARINDEX('.',csd.sis_source_id)+1)+1) > 0 --Has third period
           )
           
    SELECT DISTINCT 
           Section.LMSCourseSectionID
          ,Section.LMSCourseID
          ,Section.LMSCourseSectionCanvasID
          ,Section.CourseSectionCode
          ,CASE
               WHEN ISNUMERIC(RIGHT(Section.SemesterTermCode, 4)) = 0 THEN
                   NULL
               WHEN Section.SemesterTermCode LIKE 'Winter %' THEN
                   'UNDG' + RIGHT(Section.SemesterTermCode, 4) + 'WI'
               WHEN Section.SemesterTermCode LIKE 'Spring %' THEN
                   'UNDG' + RIGHT(Section.SemesterTermCode, 4) + 'SP'
               WHEN Section.SemesterTermCode LIKE 'Summer %' THEN
                   'UNDG' + RIGHT(Section.SemesterTermCode, 4) + 'SS'
               WHEN Section.SemesterTermCode LIKE 'Fall %' THEN
                   'UNDG' + RIGHT(Section.SemesterTermCode, 4) + 'FA'
               ELSE
                   NULL
           END AS SemesterSourceID
          ,Section.SemesterTermCode
      FROM Section
     WHERE ISNUMERIC(RIGHT(Section.SemesterTermCode, 4)) = 1 --Make sure year was parsed successfully
)


GO
