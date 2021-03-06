USE [CanvasTemp]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*=========================================================================================================================
OVERVIEW: Populates cleanActiveCourse

CHANGE LOG:
**WHEN**        **WHO**             **WHAT**
09/04/2020      Bart Cullimore      Created proc.
04/26/2021      Bart Cullimore      Moved to CanvasDataTemp
============================================================================================================================*/
CREATE   PROCEDURE [dbo].[cleanActiveCourseLoad]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT course_id
          ,account_id
          ,Name
          ,Code
          ,sis_source_id
          ,LMSCourseCanvasID
          ,SemesterSourceID
          ,SemesterTermCode
          ,'BYUI' AS Institution
      FROM dbo.ActiveCourse('BYUI') AS ActiveCourseBYUI

    UNION ALL

    SELECT course_id
          ,account_id
          ,Name
          ,Code
          ,sis_source_id
          ,LMSCourseCanvasID
          ,SemesterSourceID
          ,SemesterTermCode
          ,'Pathway' AS Institution
      FROM dbo.ActiveCourse('Pathway') AS ActiveCoursePathway

END
GO
