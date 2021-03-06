USE [CanvasTemp]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*=========================================================================================================================
OVERVIEW: Populates cleanSectionEnrollment

CHANGE LOG:
**WHEN**    **WHO**             **WHAT**
06/09/2020  Bart Cullimore      Created proc.
07/13/2020  Bart Cullimore      Added Pathway logic.
08/18/2020  Bart Cullimore      CanvasPerson function now returns both BYUI and Pathway.
08/21/2020  Bart Cullimore      Now using role_dim.name instead of enrollment_dim.type for EnrollmentType.
09/04/2020  Bart Cullimore      Now using CanvasDataRaw.dbo.ActiveCourse.
09/10/2020  Bart Cullimore      Added Section CTE so we can include sections that have a valid sis_source_id (CourseSectionCode)
                                but not a valid enrollment_term_id.
09/25/2020  Bart Cullimore      Added LMSCourseCanvasID and changed SemesterSourceID to use SemesterTerm().
09/28/2020  Bart Cullimore      Added SemesterWithoutSubsessionSourceID
10/01/2020  Bart Cullimore      Added UserName from pseudonym_dim.unique_name. Only populated for BYUI rows.
10/07/2020  Bart Cullimore      Added BYUIPathwayCourses CTE to include BYUI sections that are in Pathway Production account.
10/12/2020  Bart Cullimore      Added StudentAcademicSourceID and StudentTermSourceID to support LMSGradebook.
10/12/2020  Bart Cullimore      Removing ed.workflow_state <> 'deleted' filter so we can get old TAs that seem to have been 
                                deleted after grading assignments.
10/12/2020  Bart Cullimore      Moved SectionTerm() join to LMSEnrollment CTE so deleted sections do not impact sort order.
04/26/2021  Bart Cullimore      Moved to CanvasDataTemp
============================================================================================================================*/
CREATE  PROCEDURE [dbo].[cleanSectionEnrollmentLoad]
AS
BEGIN
    SET NOCOUNT ON;

    WITH LMSEnrollment
    AS (SELECT DISTINCT
               Person.user_id
              ,Section.LMSCourseID
              ,Section.LMSCourseSectionID
              ,Section.LMSCourseSectionCanvasID
              ,Section.CourseSectionCode
              ,Section.SemesterSourceID
              ,Section.SemesterTermCode
              ,Person.canvas_id AS LMSUserCanvasID
              ,CASE --PersonSourceID
                   WHEN ActiveCourseBYUI.course_id IS NULL AND ed.type = 'StudentEnrollment' 
                       THEN COALESCE(Person.pathway_student_source_id, Person.byui_person_source_id) --For pathway students, try to force PathwaySourceID
                       ELSE Person.sis_user_id --This is a coalesce that prioritizes INumber over PathwaySourceID
               END AS PersonSourceID
              ,Person.current_login_at
              ,Person.unique_name
              ,ed.id AS LMSEnrollmentID
              ,rd.name AS EnrollmentType
              ,ed.course_id
              ,COALESCE(ActiveCourseBYUI.LMSCourseCanvasID, ActiveCoursePathway.LMSCourseCanvasID) AS LMSCourseCanvasID
              ,ed.course_section_id
              ,ed.workflow_state
              ,ed.last_activity_at
              ,CASE WHEN ActiveCourseBYUI.course_id IS NOT NULL THEN 'BYUI' ELSE 'Pathway' END AS Institution
              ,ROW_NUMBER() OVER (PARTITION BY Person.user_id
                                              ,ed.course_id
                                              ,ed.course_section_id
                                      ORDER BY CASE
                                                   WHEN rd.name = 'TeacherEnrollment' THEN
                                                       1
                                                   WHEN rd.name = 'TAEnrollment' THEN
                                                       2
                                                   WHEN ed.type = 'TeacherEnrollment' THEN
                                                       3
                                                   WHEN ed.type = 'TAEnrollment' THEN
                                                       4
                                                   WHEN ed.type = 'Teacher (secondary)' THEN
                                                       5
                                                   ELSE
                                                       6
                                               END ASC
                                              ,CASE
                                                   WHEN ed.workflow_state = 'active' THEN
                                                       1
                                                   WHEN ed.workflow_state = 'inactive' THEN
                                                       2
                                                   ELSE
                                                       3
                                               END ASC
                                 ) AS EnrollmentSectionRank
              ,ROW_NUMBER() OVER (PARTITION BY Person.user_id
                                              ,ed.course_id
                                      ORDER BY CASE
                                                   WHEN rd.name = 'TeacherEnrollment' THEN
                                                       1
                                                   WHEN rd.name = 'TAEnrollment' THEN
                                                       2
                                                   WHEN ed.type = 'TeacherEnrollment' THEN
                                                       3
                                                   WHEN ed.type = 'TAEnrollment' THEN
                                                       4
                                                   WHEN ed.type = 'Teacher (secondary)' THEN
                                                       5
                                                   ELSE
                                                       6
                                               END ASC
                                              ,CASE
                                                   WHEN ed.workflow_state = 'active' THEN
                                                       1
                                                   WHEN ed.workflow_state = 'inactive' THEN
                                                       2
                                                   ELSE
                                                       3
                                               END ASC
                                 ) AS EnrollmentCourseRank
          FROM dbo.CanvasPerson() AS Person
         INNER JOIN dbo.enrollment_dim_RAW AS ed
            ON Person.user_id = ed.user_id
         INNER JOIN dbo.role_dim_RAW AS rd
            ON rd.id = ed.role_id
         INNER JOIN dbo.SectionTerm() AS Section
            ON ed.course_section_id = Section.LMSCourseSectionID
          LEFT JOIN dbo.ActiveCourse('BYUI') AS ActiveCourseBYUI
            ON ActiveCourseBYUI.course_id = ed.course_id
          LEFT JOIN dbo.ActiveCourse('Pathway') AS ActiveCoursePathway
            ON ActiveCoursePathway.course_id = ed.course_id
         WHERE ed.type IN ( 'TeacherEnrollment', 'TAEnrollment', 'StudentEnrollment' )
           AND rd.workflow_state <> 'inactive'
           AND ed.user_id IS NOT NULL
           AND (ActiveCourseBYUI.course_id IS NOT NULL OR ActiveCoursePathway.course_id IS NOT NULL)
    )
    , BYUIPathwayCourses AS (
        SELECT csd.id AS LMSCourseSectionID
              ,'BYUI' AS Institution
          FROM dbo.course_dim_RAW AS cd
         INNER JOIN dbo.course_section_dim_RAW AS csd
            ON cd.id = csd.course_id
         WHERE cd.account_id = 107060000000000110 --Pathway Production
           AND csd.sis_source_id LIKE '%Online%'
           AND csd.sis_source_id NOT LIKE '%Pathway%'
    )
    SELECT DISTINCT le.LMSEnrollmentID
          ,le.LMSCourseID
          ,le.LMSCourseCanvasID
          ,le.LMSCourseSectionID
          ,le.LMSCourseSectionCanvasID
          ,le.CourseSectionCode
          ,le.user_id AS LMSUserID
          ,le.LMSUserCanvasID
          ,dbo.fn_MountainTime(le.current_login_at) AS CurrentLoginAt
          ,dbo.fn_MountainTime(le.last_activity_at) AS LastActivityAt
          ,le.current_login_at AS CurrentLoginAtUTC
          ,le.last_activity_at AS LastActivityAtUTC
          ,COALESCE(bpc.Institution, le.Institution) AS Institution
          ,le.PersonSourceID
          ,LEFT(le.unique_name, 50) AS UserName --Only populated for BYUI rows
          ,le.SemesterSourceID
          ,CAST(LEFT(le.SemesterTermCode,50) AS VARCHAR(50)) AS SemesterTermCode
          ,le.EnrollmentType
          ,le.EnrollmentSectionRank
          ,le.EnrollmentCourseRank
          ,LEFT(le.workflow_state, 20) AS WorkflowState
          ,le.SemesterSourceID AS SemesterWithoutSubsessionSourceID
          ,CASE WHEN LEN(le.PersonSourceID) < 10 THEN LEFT(TRY_CAST(le.PersonSourceID AS VARCHAR(9)) + le.SemesterSourceID + 'BYUI', 26) 
           ELSE NULL END AS StudentAcademicSourceID
          ,CASE WHEN LEN(le.PersonSourceID) < 10 THEN LEFT(TRY_CAST(le.PersonSourceID AS VARCHAR(9)) + le.SemesterSourceID, 50) 
           ELSE NULL END AS StudentTermSourceID
      FROM LMSEnrollment AS le
      LEFT JOIN BYUIPathwayCourses AS bpc --Hack to include BYUI sections in Pathway Production account
        ON bpc.LMSCourseSectionID = le.LMSCourseSectionID
     WHERE (le.Institution = 'Pathway' OR LEN(le.PersonSourceID) < 10) --Limits BYUI results to INumber < 10 chars

END

GO
