USE [Registration]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*=========================================================================================================================
OVERVIEW: ETL Update script for LMSCourse

CHANGE LOG:
**WHEN**    **WHO**             **WHAT**
05/18/2020  Bart Cullimore      Created proc.
09/17/2020  Bart Cullimore      Added soft delete logic.
=========================================================================================================================*/
CREATE PROCEDURE [dbo].[LMSCourseUpdate]

AS
BEGIN

--Note ETLDeleteDate used for soft delete
update a set
[SourceID] = b.[SourceID],
[SemesterID] = SemesterIDtable.[SemesterID],
[BlueprintCourseID] = BlueprintCourseIDtable.[CourseID],
[Name] = b.[Name],
[Code] = b.[Code],
[SISSourceID] = b.[SISSourceID],
[IsBlueprintCourse] = b.[IsBlueprintCourse],
[IsLMSCrosslisted] = b.[IsLMSCrosslisted],
[SectionCount] = b.[SectionCount],
[LMSCourseCanvasID] = b.[LMSCourseCanvasID],
[ETLLastUpdateDate] = GetDate(),
[ETLDeleteDate] = NULL
from [Registration].[dbo].[LMSCourse] a
inner join [RegistrationTemp].[dbo].[LMSCourse] b on a.[SourceID] = b.[SourceID]
inner join [Registration].[dbo].[Semester] SemesterIDtable on b.[SemesterID] = SemesterIDtable.[SourceID]
left outer join [Registration].[dbo].[Course] BlueprintCourseIDtable on b.[BlueprintCourseID] = BlueprintCourseIDtable.[SourceID]
where a.[SourceID] <> b.[SourceID] or (a.[SourceID] is null and b.[SourceID] is not null) or (a.[SourceID] is not null and b.[SourceID] is null)
or a.[SemesterID] <> SemesterIDtable.[SemesterID] or (a.[SemesterID] is null and SemesterIDtable.[SemesterID] is not null) or (a.[SemesterID] is not null and SemesterIDtable.[SemesterID] is null)
or a.[BlueprintCourseID] <> BlueprintCourseIDtable.[CourseID] or (a.[BlueprintCourseID] is null and BlueprintCourseIDtable.[CourseID] is not null) or (a.[BlueprintCourseID] is not null and BlueprintCourseIDtable.[CourseID] is null)
or a.[Name] <> b.[Name] or (a.[Name] is null and b.[Name] is not null) or (a.[Name] is not null and b.[Name] is null)
or a.[Code] <> b.[Code] or (a.[Code] is null and b.[Code] is not null) or (a.[Code] is not null and b.[Code] is null)
or a.[SISSourceID] <> b.[SISSourceID] or (a.[SISSourceID] is null and b.[SISSourceID] is not null) or (a.[SISSourceID] is not null and b.[SISSourceID] is null)
or a.[IsBlueprintCourse] <> b.[IsBlueprintCourse] or (a.[IsBlueprintCourse] is null and b.[IsBlueprintCourse] is not null) or (a.[IsBlueprintCourse] is not null and b.[IsBlueprintCourse] is null)
or a.[IsLMSCrosslisted] <> b.[IsLMSCrosslisted] or (a.[IsLMSCrosslisted] is null and b.[IsLMSCrosslisted] is not null) or (a.[IsLMSCrosslisted] is not null and b.[IsLMSCrosslisted] is null)
or a.[SectionCount] <> b.[SectionCount] or (a.[SectionCount] is null and b.[SectionCount] is not null) or (a.[SectionCount] is not null and b.[SectionCount] is null)
or a.[LMSCourseCanvasID] <> b.[LMSCourseCanvasID] or (a.[LMSCourseCanvasID] is null and b.[LMSCourseCanvasID] is not null) or (a.[LMSCourseCanvasID] is not null and b.[LMSCourseCanvasID] is null)
or a.[ETLDeleteDate] IS NOT NULL

END

GO
