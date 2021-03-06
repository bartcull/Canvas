USE [CanvasTemp]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*=========================================================================================================================
OVERVIEW: Populates EnrollmentSourceID, PathwayEnrollmentSourceID, and DepartmentCode in cleanSectionEnrollment table

CHANGE LOG:
**WHEN**    **WHO**                **WHAT**
06/12/2020    Bart Cullimore        Created proc.
06/25/2020    Bart Cullimore        Added one-offs to correct LMS data errors.
09/24/2020    Bart Cullimore        Added section D to populate DepartmentCode
09/28/2020    Bart Cullimore        Added section E to correct SemesterSourceIDs for blocks
04/26/2020    Bart Cullimore        Removed hard-coded CanvasDataStage references
============================================================================================================================*/
CREATE PROCEDURE [dbo].[cleanSectionEnrollmentUpdateEnrollmentID]
AS
BEGIN
    SET NOCOUNT ON;

/*==========================================================================================================================
A. One-off updates because of data errors in LMS
============================================================================================================================*/

--Course is tied to SP19 in LMS but was actually offered in FA19
UPDATE dbo.cleanSectionEnrollment
   SET SectionSourceID = 'CIT  240UG192019FA04'
      ,SemesterSourceID = 'UNDG2019FA'
 WHERE LMSCourseSectionID = 107060000000058008
   AND SectionSourceID = 'CIT  240UG192019SP04';

--Course name issue: REL 275C in LMS; FDREL 275 in SIS
UPDATE dbo.cleanSectionEnrollment
   SET SectionSourceID = 'FDREL275UG172019WI01'
      ,CourseSourceID = 'FDREL275UG17'
      ,SemesterSourceID = 'UNDG2019WI'
 WHERE LMSCourseSectionID = 107060000000023048
   AND SectionSourceID = 'REL  275CUG172019WI01';


/*==========================================================================================================================
B. Update EnrollmentSourceID in cleanSectionEnrollment
============================================================================================================================*/
    WITH EnrollmentSourceIDs
    AS (SELECT e.SourceID AS EnrollmentSourceID
              ,s.SourceID AS SectionSourceID
              ,p.SourceID AS PersonSourceID
              ,ROW_NUMBER() OVER (PARTITION BY e.PersonID, e.SectionID ORDER BY e.SourceID DESC) AS EnrollmentRowOrder
          FROM Registration.dbo.Enrollment e
         INNER JOIN Registration.dbo.Person AS p
            ON p.PersonID = e.PersonID
         INNER JOIN Registration.dbo.Section AS s
            ON e.SectionID = s.SectionID)
    UPDATE dbo.cleanSectionEnrollment
       SET EnrollmentSourceID = esi.EnrollmentSourceID
      FROM dbo.cleanSectionEnrollment AS cse
     INNER JOIN EnrollmentSourceIDs AS esi
        ON esi.SectionSourceID = cse.SectionSourceID
       AND esi.PersonSourceID = cse.PersonSourceID
     WHERE esi.EnrollmentRowOrder = 1

/*==========================================================================================================================
C. Update PathwayEnrollmentSourceID in cleanSectionEnrollment (FK to factPathwayEnrollments)
============================================================================================================================*/
    UPDATE dbo.cleanSectionEnrollment
       SET PathwayEnrollmentSourceID = fpe.SourceID
      FROM dbo.cleanSectionEnrollment AS cse
     INNER JOIN Registration.dbo.Section AS s
        ON s.SourceID = cse.SectionSourceID
     INNER JOIN Registration.dbo.factPathwayEnrollments AS fpe
        ON s.SectionID = fpe.SectionID
     INNER JOIN Registration.dbo.dimPathwayStudent AS dps
        ON dps.dimPathwayStudentID = fpe.dimPathwayStudentID
       AND cse.PersonSourceID = dps.SourceID
     WHERE cse.Institution = 'Pathway'

/*==========================================================================================================================
D. Update DepartmentCode in cleanSectionEnrollment
============================================================================================================================*/
    UPDATE dbo.cleanSectionEnrollment
       SET DepartmentCode = c.DepartmentCode
      FROM dbo.cleanSectionEnrollment AS cse
     INNER JOIN Registration.dbo.Course AS c
        ON c.SourceID = cse.CourseSourceID
     WHERE c.DepartmentCode IS NOT NULL

/*==========================================================================================================================
E. Update SemesterSourceID for semester blocks. Canvas doesn't have block info in sis_source_id, 
   so we have to update using Section.
============================================================================================================================*/
    UPDATE cse
       SET cse.SemesterSourceID = sem.SourceID
      FROM dbo.cleanSectionEnrollment AS cse
     INNER JOIN Registration.dbo.Section AS s
        ON s.SourceID = cse.SectionSourceID
     INNER JOIN Registration.dbo.Semester AS sem
        ON sem.SemesterID = s.SemesterID
     WHERE sem.SourceID <> cse.SemesterSourceID

END

GO
