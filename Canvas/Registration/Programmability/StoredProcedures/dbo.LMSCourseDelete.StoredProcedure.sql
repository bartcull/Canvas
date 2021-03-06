USE [Registration]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*=========================================================================================================================
OVERVIEW: ETL Delete script for LMSCourse

CHANGE LOG:
**WHEN**    **WHO**             **WHAT**
05/18/2020  Bart Cullimore      Created proc.
08/04/2020  Bart Cullimore      Modified Alexstrasza to limit deletes to Semesters in associated RegistrationTemp table.		
09/17/2020  Bart Cullimore      Changed to soft delete.
=========================================================================================================================*/
CREATE PROCEDURE [dbo].[LMSCourseDelete]

AS
BEGIN

-- Soft delete
-- This is a modified Alexstrasza procedure which allows for a narrowed refresh window.
-- Deletes will only happen for semesters that exist in the associated Temp table. 
-- The refresh window is configured in the associated TRANSFORM2 dtsx package.
update [Registration].[dbo].[LMSCourse]
set ETLDeleteDate = GetDate()
where SourceID not in (select SourceID from [RegistrationTemp].[dbo].[LMSCourse])
AND SemesterID IN --Limit deletes to Semesters that are in the Temp table (this supports partial refreshes)
       (
           SELECT DISTINCT
                  SemesterIDtable.SemesterID
             FROM RegistrationTemp.dbo.LMSCourse AS b
            INNER JOIN Registration.dbo.Semester SemesterIDtable
               ON b.SemesterID = SemesterIDtable.SourceID
       )
AND ETLDeleteDate IS NULL

END

GO
