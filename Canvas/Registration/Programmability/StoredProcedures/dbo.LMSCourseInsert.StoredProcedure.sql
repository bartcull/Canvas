USE [Registration]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*=========================================================================================================================
OVERVIEW: ETL Insert script for LMSCourse

CHANGE LOG:
**WHEN**    **WHO**             **WHAT**
05/18/2020  Bart Cullimore      Created Proc.
06/30/2020  Bart Cullimore      Added PostAlexstrasza to update FK Section.LMSCourseID
09/17/2020  Bart Cullimore      Defined insert columns to avoid mismatch when columns are added.
04/26/2021  Bart Cullimore      Changed CanvasDataStage to CanvasTemp
=========================================================================================================================*/
CREATE    PROCEDURE [dbo].[LMSCourseInsert]

AS
BEGIN

insert into [Registration].[dbo].[LMSCourse]
(SourceID, SemesterID, BlueprintCourseID, Name, Code, SISSourceID, IsBlueprintCourse, IsLMSCrosslisted, SectionCount, LMSCourseCanvasID, ETLLoadDate, ETLLastUpdateDate)
select b.[SourceID], SemesterIDtable.[SemesterID], BlueprintCourseIDtable.[CourseID], b.[Name], b.[Code], b.[SISSourceID], b.[IsBlueprintCourse], b.[IsLMSCrosslisted], b.[SectionCount], b.[LMSCourseCanvasID], GetDate(), GetDate()
from [RegistrationTemp].[dbo].[LMSCourse] b
inner join [Registration].[dbo].[Semester] SemesterIDtable on b.[SemesterID] = SemesterIDtable.[SourceID]
left outer join [Registration].[dbo].[Course] BlueprintCourseIDtable on b.[BlueprintCourseID] = BlueprintCourseIDtable.[SourceID]
where b.SourceID not in (select SourceID from [Registration].[dbo].[LMSCourse]);

--PostAlexstrasza to update FK Section.LMSCourseID (also gets updated in EDW.dtsx)
WITH LMSCourseToSection
AS (SELECT DISTINCT
           cse.SectionSourceID
          ,lc.LMSCourseID
      FROM CanvasTemp.dbo.cleanSectionEnrollment AS cse
     INNER JOIN Registration.dbo.LMSCourse AS lc
        ON lc.SourceID = cse.LMSCourseID
       AND cse.Institution = 'BYUI'
     WHERE lc.SourceID NOT IN (107060000000054316, 107060000000108332) --Exclude dupes C.Campus.2019.Spring.FDREL 250.24 and Online.2020.Summer.GS 100.1
       AND cse.WorkflowState <> 'deleted'
   )
UPDATE Registration.dbo.Section
   SET LMSCourseID = lcs.LMSCourseID
  FROM Registration.dbo.Section AS s
 INNER JOIN LMSCourseToSection AS lcs
    ON lcs.SectionSourceID = s.SourceID
 WHERE lcs.SectionSourceID IS NOT NULL
   AND (s.LMSCourseID <> lcs.LMSCourseID OR s.LMSCourseID IS NULL);

    --  --Remove outdated Foreign Keys (If LMSCourse allows deletions)
    --  UPDATE Registration.dbo.Section
    --     SET LMSCourseID = NULL
    --    FROM Registration.dbo.Section AS s
    --    LEFT JOIN Registration.dbo.LMSCourse AS lc
    --      ON lc.LMSCourseID = s.LMSCourseID
    --   WHERE lc.LMSCourseID IS NULL
    --     AND s.LMSCourseID IS NOT NULL;

END


GO
