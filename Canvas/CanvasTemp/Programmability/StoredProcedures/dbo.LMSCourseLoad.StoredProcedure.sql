USE [CanvasTemp]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*=========================================================================================================================
OVERVIEW: Populates LMSCourse

CHANGE LOG:
**WHEN**	**WHO**				**WHAT**
05/13/2020	Bart Cullimore		Created proc.
08/03/2020  Bart Cullimore		Added join to Registration.dbo.Semester
09/04/2020  Bart Cullimore      Changed dbo.ActiveCourse() to dbo.cleanActiveCourse table
09/28/2020  Bart Cullimore      Removed Semester.Subsession IS NULL filter
10/08/2020  Bart Cullimore      Added DistinctLMSCourseSemester to support blocks in SemesterID
04/26/2021  Bart Cullimore      Removed hard-coded CanvasDataStage references
10/18/2021  Bart Cullimore      Added TRIM to columns with trailing spaces.
============================================================================================================================*/
CREATE   PROCEDURE [dbo].[LMSCourseLoad] (@SemesterStartDate DATETIME2(7) = '2000-01-01 00:00:00.000') --Default date will include all data
AS
BEGIN
    SET NOCOUNT ON;

    WITH StudentEnrollments
    AS (SELECT DISTINCT
               ed.course_section_id
          FROM dbo.enrollment_dim AS ed
         WHERE ed.type = 'StudentEnrollment'
           AND ed.workflow_state IN ( 'completed', 'active' ))
        ,Section
    AS (SELECT csd.course_id
              ,COUNT(*) AS SectionCount
          FROM dbo.course_section_dim AS csd
         INNER JOIN StudentEnrollments AS se --Exclude sections that have no students
            ON se.course_section_id = csd.source_id
         WHERE csd.workflow_state = 'active'
           AND csd.sis_source_id IS NOT NULL --This excludes custom subsections like extended and American Foundations
         GROUP BY csd.course_id)
    SELECT ac.course_id AS SourceID
          ,COALESCE(dlcs.SemesterSourceID, ac.SemesterSourceID) AS SemesterID --dlcs supports blocks and ac supports blueprint courses
          ,TRIM(ac.Name) AS Name
          ,TRIM(ac.Code) AS Code
          ,ac.sis_source_id AS SISSourceID
          ,CASE
               WHEN ac.sis_source_id LIKE '%Blueprint%' THEN
                   1
               ELSE
                   0
           END AS IsBlueprintCourse --sis_source_id LIKE '%Blueprint%'
          ,CASE
               WHEN Section.SectionCount > 1 THEN
                   1
               ELSE
                   0
           END AS IsLMSCrosslisted
          ,COALESCE(Section.SectionCount, 0) AS SectionCount
          ,ac.LMSCourseCanvasID
          ,CASE
               WHEN ac.sis_source_id LIKE '%Blueprint%' THEN
                   LEFT(REPLACE(ac.Code, ': BP', ''), 16)
               ELSE
                   NULL
           END AS CourseNumber
          ,ac.SemesterTermCode
      FROM dbo.cleanActiveCourse AS ac
      LEFT JOIN Section
        ON Section.course_id = ac.course_id
      LEFT JOIN dbo.DistinctLMSCourseSemester() AS dlcs
        ON dlcs.LMSCourseID = ac.course_id
     INNER JOIN Registration.dbo.Semester
        ON Semester.SourceID = ac.SemesterSourceID
     WHERE Semester.StartDate >= @SemesterStartDate
       AND ac.Institution = 'BYUI' --BYUI, Online, or Devotional

END


GO
