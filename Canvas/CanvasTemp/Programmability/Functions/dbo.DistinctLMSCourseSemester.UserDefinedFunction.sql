USE [CanvasTemp]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*=========================================================================================================================
OVERVIEW: Returns the SemesterSourceID for each LMSCourse which corresponds to the section with the most students. Courses 
like canvas_ids 87654 and 31168 have multiple semesters/blocks, so we use this function in situations where we need one
LMSCourse level SemesterID, as with loading LMSCourse, LMSContentItem, LMSContentModule, LMSDiscussionReply, and 
LMSDiscussionTopic.

CHANGE LOG:
**WHEN**       **WHO**             **WHAT**
10/08/2020     Bart Cullimore      Created proc.
04/26/2021     Bart Cullimore      Moved to CanvasDataTemp
============================================================================================================================*/

CREATE   FUNCTION [dbo].[DistinctLMSCourseSemester] ()
RETURNS @SectionLMSCourse TABLE
(
    LMSCourseID BIGINT NOT NULL
   ,SemesterSourceID VARCHAR(14) NOT NULL
   ,SectionSourceID VARCHAR(26) NOT NULL
)
AS
BEGIN
    WITH Enrolled
    AS (SELECT cse.LMSCourseID
              ,cse.SemesterSourceID
              ,cse.SectionSourceID
              ,COUNT(*) AS EnrolledCount
          FROM dbo.cleanSectionEnrollment AS cse
         WHERE cse.WorkflowState <> 'deleted'
         GROUP BY cse.SectionSourceID
                 ,cse.LMSCourseID
                 ,cse.SemesterSourceID)
    ,CourseRankedByEnrolled
    AS (SELECT enr.LMSCourseID
              ,enr.SemesterSourceID
              ,enr.SectionSourceID
              ,enr.EnrolledCount
              ,ROW_NUMBER() OVER (PARTITION BY enr.LMSCourseID ORDER BY enr.EnrolledCount DESC) AS Rank
          FROM Enrolled AS enr
         WHERE enr.SectionSourceID IS NOT NULL
           AND enr.LMSCourseID IS NOT NULL
           AND enr.SemesterSourceID IS NOT NULL)
    INSERT INTO @SectionLMSCourse
    SELECT crbe.LMSCourseID
          ,crbe.SemesterSourceID
          ,crbe.SectionSourceID
      FROM CourseRankedByEnrolled AS crbe
     WHERE crbe.Rank = 1 --Exclude dupes like C.Campus.2019.Spring.FDREL 250.24 and Online.2020.Summer.GS 100.1

    RETURN
END

GO
