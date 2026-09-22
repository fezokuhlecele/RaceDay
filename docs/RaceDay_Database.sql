/*
========================================================
RaceDay Database
Part 1 - Section C: SQL Database Script
========================================================
*/

USE master;
GO

IF DB_ID('RaceDay') IS NULL
BEGIN
    CREATE DATABASE RaceDay;
END;
GO

USE RaceDay;
GO


/* ======================================================
   USERS
   ====================================================== */

CREATE TABLE Users
(
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    Role NVARCHAR(20) NOT NULL,
    PhoneNumber NVARCHAR(20) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT CK_Users_Role
        CHECK (Role IN ('Organiser', 'Participant'))
);
GO


/* ======================================================
   EVENTS
   ====================================================== */

CREATE TABLE Events
(
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserID INT NOT NULL,
    EventName NVARCHAR(150) NOT NULL,
    Description NVARCHAR(500) NULL,
    EventDate DATE NOT NULL,
    StartTime TIME NOT NULL,
    Location NVARCHAR(200) NOT NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Upcoming',
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Events_Users
        FOREIGN KEY (OrganiserID)
        REFERENCES Users(UserID),

    CONSTRAINT CK_Events_Status
        CHECK (Status IN ('Upcoming', 'Open', 'Completed', 'Cancelled'))
);
GO


/* ======================================================
   CATEGORIES
   ====================================================== */

CREATE TABLE Categories
(
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(300) NULL,
    DistanceKm DECIMAL(6,2) NOT NULL,
    EventType NVARCHAR(20) NOT NULL,

    CONSTRAINT CK_Categories_Distance
        CHECK (DistanceKm > 0),

    CONSTRAINT CK_Categories_EventType
        CHECK (EventType IN ('Running', 'Walking', 'Cycling'))
);
GO


/* ======================================================
   EVENT CATEGORIES
   ====================================================== */

CREATE TABLE EventCategories
(
    EventCategoryID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL,
    CategoryID INT NOT NULL,
    EntryFee DECIMAL(10,2) NOT NULL,
    MaximumParticipants INT NOT NULL,

    CONSTRAINT FK_EventCategories_Events
        FOREIGN KEY (EventID)
        REFERENCES Events(EventID),

    CONSTRAINT FK_EventCategories_Categories
        FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID),

    CONSTRAINT UQ_EventCategories
        UNIQUE (EventID, CategoryID),

    CONSTRAINT CK_EventCategories_EntryFee
        CHECK (EntryFee >= 0),

    CONSTRAINT CK_EventCategories_MaxParticipants
        CHECK (MaximumParticipants > 0)
);
GO


/* ======================================================
   ENROLMENTS
   ====================================================== */

CREATE TABLE Enrolments
(
    EnrolmentID INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantID INT NOT NULL,
    EventCategoryID INT NOT NULL,
    EnrolmentDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    RaceNumber INT NOT NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT FK_Enrolments_Participants
        FOREIGN KEY (ParticipantID)
        REFERENCES Users(UserID),

    CONSTRAINT FK_Enrolments_EventCategories
        FOREIGN KEY (EventCategoryID)
        REFERENCES EventCategories(EventCategoryID),

    CONSTRAINT UQ_Enrolments_Participant_EventCategory
        UNIQUE (ParticipantID, EventCategoryID),

    CONSTRAINT UQ_Enrolments_RaceNumber
        UNIQUE (EventCategoryID, RaceNumber),

    CONSTRAINT CK_Enrolments_Status
        CHECK (Status IN ('Active', 'Cancelled'))
);
GO


/* ======================================================
   RESULTS
   ====================================================== */

CREATE TABLE Results
(
    ResultID INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentID INT NOT NULL UNIQUE,
    FinishTime TIME NOT NULL,
    OverallPosition INT NOT NULL,
    CategoryPosition INT NOT NULL,
    ResultStatus NVARCHAR(20) NOT NULL DEFAULT 'Finished',
    RecordedAt DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Results_Enrolments
        FOREIGN KEY (EnrolmentID)
        REFERENCES Enrolments(EnrolmentID),

    CONSTRAINT CK_Results_OverallPosition
        CHECK (OverallPosition > 0),

    CONSTRAINT CK_Results_CategoryPosition
        CHECK (CategoryPosition > 0),

    CONSTRAINT CK_Results_Status
        CHECK (ResultStatus IN ('Finished', 'DNF', 'DNS', 'Disqualified'))
);
GO


/* ======================================================
   ROUTES
   ====================================================== */

CREATE TABLE Routes
(
    RouteID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL UNIQUE,
    RouteName NVARCHAR(150) NOT NULL,
    DistanceKm DECIMAL(6,2) NOT NULL,
    RouteDescription NVARCHAR(500) NULL,
    MapUrl NVARCHAR(500) NULL,

    CONSTRAINT FK_Routes_Events
        FOREIGN KEY (EventID)
        REFERENCES Events(EventID),

    CONSTRAINT CK_Routes_Distance
        CHECK (DistanceKm > 0)
);
GO


/* ======================================================
   WEATHER INFORMATION
   ====================================================== */

CREATE TABLE WeatherInformation
(
    WeatherID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL UNIQUE,
    Temperature DECIMAL(5,2) NOT NULL,
    WeatherCondition NVARCHAR(100) NOT NULL,
    WindSpeed DECIMAL(6,2) NULL,
    RainProbability DECIMAL(5,2) NULL,
    RecordedAt DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_WeatherInformation_Events
        FOREIGN KEY (EventID)
        REFERENCES Events(EventID),

    CONSTRAINT CK_WeatherInformation_RainProbability
        CHECK (RainProbability >= 0 AND RainProbability <= 100)
);
GO


/* ======================================================
   SAMPLE USERS
   ====================================================== */

INSERT INTO Users
    (FirstName, LastName, Email, PasswordHash, Role, PhoneNumber)
VALUES
    ('Thando', 'Mkhize',
     'thando.mkhize@raceday.co.za',
     'DemoHash_Organiser1',
     'Organiser',
     '0821112233'),

    ('Lerato', 'Naidoo',
     'lerato.naidoo@raceday.co.za',
     'DemoHash_Organiser2',
     'Organiser',
     '0832223344'),

    ('Sipho', 'Dlamini',
     'sipho.dlamini@example.com',
     'DemoHash_Participant1',
     'Participant',
     '0843334455'),

    ('Ayanda', 'Cele',
     'ayanda.cele@example.com',
     'DemoHash_Participant2',
     'Participant',
     '0854445566');
GO


/* ======================================================
   SAMPLE EVENTS
   ====================================================== */

INSERT INTO Events
    (OrganiserID, EventName, Description, EventDate,
     StartTime, Location, Status)
VALUES
    (1,
     'Durban Summer Run',
     'A road running event along the Durban beachfront.',
     '2026-11-15',
     '06:00',
     'Durban Beachfront, KwaZulu-Natal',
     'Open'),

    (1,
     'Umlazi Community Road Race',
     'A community running and walking event in Umlazi.',
     '2026-12-06',
     '06:30',
     'Umlazi, KwaZulu-Natal',
     'Open'),

    (2,
     'KwaZulu-Natal Cycle Challenge',
     'A cycling event for recreational and competitive cyclists.',
     '2027-01-24',
     '05:30',
     'Durban, KwaZulu-Natal',
     'Upcoming');
GO


/* ======================================================
   SAMPLE CATEGORIES
   ====================================================== */

INSERT INTO Categories
    (CategoryName, Description, DistanceKm, EventType)
VALUES
    ('5KM Run',
     '5 kilometre road running category.',
     5.00,
     'Running'),

    ('10KM Run',
     '10 kilometre road running category.',
     10.00,
     'Running'),

    ('21.1KM Half Marathon',
     'Half marathon road running category.',
     21.10,
     'Running'),

    ('10KM Walk',
     '10 kilometre walking category.',
     10.00,
     'Walking'),

    ('40KM Cycle',
     '40 kilometre cycling category.',
     40.00,
     'Cycling'),

    ('80KM Cycle',
     '80 kilometre cycling category.',
     80.00,
     'Cycling');
GO


/* ======================================================
   EVENT CATEGORY LINKS
   ====================================================== */

INSERT INTO EventCategories
    (EventID, CategoryID, EntryFee, MaximumParticipants)
VALUES
    (1, 1, 120.00, 500),
    (1, 2, 180.00, 750),
    (1, 3, 250.00, 500),

    (2, 1, 80.00, 300),
    (2, 2, 120.00, 500),
    (2, 4, 100.00, 300),

    (3, 5, 350.00, 500),
    (3, 6, 500.00, 300);
GO


/* ======================================================
   SAMPLE ENROLMENTS
   ====================================================== */

INSERT INTO Enrolments
    (ParticipantID, EventCategoryID, RaceNumber, Status)
VALUES
    (3, 1, 101, 'Active'),
    (4, 2, 102, 'Active'),
    (3, 4, 201, 'Active'),
    (4, 7, 301, 'Active');
GO


/* ======================================================
   SAMPLE RESULTS
   ====================================================== */

INSERT INTO Results
    (EnrolmentID, FinishTime, OverallPosition,
     CategoryPosition, ResultStatus)
VALUES
    (1, '00:28:45', 35, 8, 'Finished'),
    (2, '00:52:30', 72, 15, 'Finished');
GO


/* ======================================================
   SAMPLE ROUTES
   ====================================================== */

INSERT INTO Routes
    (EventID, RouteName, DistanceKm,
     RouteDescription, MapUrl)
VALUES
    (1,
     'Durban Beachfront Route',
     21.10,
     'A coastal route starting and finishing near the Durban beachfront.',
     'https://example.com/routes/durban-summer'),

    (2,
     'Umlazi Community Route',
     10.00,
     'A community road route through selected Umlazi areas.',
     'https://example.com/routes/umlazi-community'),

    (3,
     'KZN Cycle Challenge Route',
     80.00,
     'A cycling route starting in Durban and covering surrounding roads.',
     'https://example.com/routes/kzn-cycle');
GO


/* ======================================================
   SAMPLE WEATHER INFORMATION
   ====================================================== */

INSERT INTO WeatherInformation
    (EventID, Temperature, WeatherCondition,
     WindSpeed, RainProbability)
VALUES
    (1, 24.50, 'Partly Cloudy', 12.00, 20.00),
    (2, 23.00, 'Sunny', 8.00, 10.00),
    (3, 21.50, 'Cloudy', 15.00, 30.00);
GO