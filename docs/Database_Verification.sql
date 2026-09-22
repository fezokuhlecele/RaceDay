/*
========================================================
RaceDay Database Verification
Part 1 - Section C
========================================================

Purpose:
This script verifies that the RaceDay database contains
the required sample data and that the relationships
between the main entities are working correctly.
========================================================
*/

USE RaceDay;
GO


/* ======================================================
   RECORD COUNTS
   ====================================================== */

SELECT 'Users' AS TableName, COUNT(*) AS NumberOfRecords
FROM dbo.Users

UNION ALL

SELECT 'Events', COUNT(*)
FROM dbo.Events

UNION ALL

SELECT 'Categories', COUNT(*)
FROM dbo.Categories

UNION ALL

SELECT 'EventCategories', COUNT(*)
FROM dbo.EventCategories

UNION ALL

SELECT 'Enrolments', COUNT(*)
FROM dbo.Enrolments

UNION ALL

SELECT 'Results', COUNT(*)
FROM dbo.Results

UNION ALL

SELECT 'Routes', COUNT(*)
FROM dbo.Routes

UNION ALL

SELECT 'WeatherInformation', COUNT(*)
FROM dbo.WeatherInformation;


/* ======================================================
   ENROLMENT RELATIONSHIP TEST
   ====================================================== */

SELECT
    e.EnrolmentID,
    u.FirstName + ' ' + u.LastName AS Participant,
    ev.EventName,
    c.CategoryName,
    e.RaceNumber,
    e.Status
FROM dbo.Enrolments e

INNER JOIN dbo.Users u
    ON e.ParticipantID = u.UserID

INNER JOIN dbo.EventCategories ec
    ON e.EventCategoryID = ec.EventCategoryID

INNER JOIN dbo.Events ev
    ON ec.EventID = ev.EventID

INNER JOIN dbo.Categories c
    ON ec.CategoryID = c.CategoryID

ORDER BY e.EnrolmentID;


/* ======================================================
   RESULTS RELATIONSHIP TEST
   ====================================================== */

SELECT
    r.ResultID,
    u.FirstName + ' ' + u.LastName AS Participant,
    ev.EventName,
    c.CategoryName,
    r.FinishTime,
    r.OverallPosition,
    r.CategoryPosition,
    r.ResultStatus

FROM dbo.Results r

INNER JOIN dbo.Enrolments e
    ON r.EnrolmentID = e.EnrolmentID

INNER JOIN dbo.Users u
    ON e.ParticipantID = u.UserID

INNER JOIN dbo.EventCategories ec
    ON e.EventCategoryID = ec.EventCategoryID

INNER JOIN dbo.Events ev
    ON ec.EventID = ev.EventID

INNER JOIN dbo.Categories c
    ON ec.CategoryID = c.CategoryID

ORDER BY r.ResultID;
