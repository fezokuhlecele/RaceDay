-- ============================================================================
-- RaceDay System - Database Schema & Data Seeding Script (SQL Server / SSMS)
-- ============================================================================

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'RaceDayDb')
BEGIN
    CREATE DATABASE RaceDayDb;
END
GO

USE RaceDayDb;
GO

-- 1. Drop Tables if they exist (Enforces clean execution)
IF OBJECT_ID('dbo.Results', 'U') IS NOT NULL DROP TABLE dbo.Results;
IF OBJECT_ID('dbo.Enrolments', 'U') IS NOT NULL DROP TABLE dbo.Enrolments;
IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL DROP TABLE dbo.Categories;
IF OBJECT_ID('dbo.Events', 'U') IS NOT NULL DROP TABLE dbo.Events;
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;
IF OBJECT_ID('dbo.Roles', 'U') IS NOT NULL DROP TABLE dbo.Roles;

-- 2. Table Creation
CREATE TABLE dbo.Roles (
    RoleId INT IDENTITY(1,1) PRIMARY KEY,
    RoleName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE dbo.Users (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    RoleId INT NOT NULL,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(150) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(20) NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleId) REFERENCES dbo.Roles(RoleId)
);

CREATE TABLE dbo.Events (
    EventId INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserId INT NOT NULL,
    Title VARCHAR(150) NOT NULL,
    Description VARCHAR(MAX) NOT NULL,
    Location VARCHAR(150) NOT NULL,
    EventDate DATETIME NOT NULL,
    ImageBlobUrl VARCHAR(500) NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Events_Users FOREIGN KEY (OrganiserId) REFERENCES dbo.Users(UserId)
);

CREATE TABLE dbo.Categories (
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,
    EventId INT NOT NULL,
    CategoryName VARCHAR(100) NOT NULL,
    DistanceKm DECIMAL(6,2) NOT NULL,
    Fee DECIMAL(10,2) NOT NULL CHECK (Fee >= 0),
    CONSTRAINT FK_Categories_Events FOREIGN KEY (EventId) REFERENCES dbo.Events(EventId) ON DELETE CASCADE
);

CREATE TABLE dbo.Enrolments (
    EnrolmentId INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantId INT NOT NULL,
    CategoryId INT NOT NULL,
    EnrolmentDate DATETIME DEFAULT GETDATE(),
    PaymentStatus VARCHAR(50) NOT NULL DEFAULT 'Confirmed',
    CONSTRAINT FK_Enrolments_Users FOREIGN KEY (ParticipantId) REFERENCES dbo.Users(UserId),
    CONSTRAINT FK_Enrolments_Categories FOREIGN KEY (CategoryId) REFERENCES dbo.Categories(CategoryId),
    CONSTRAINT UC_Participant_Category UNIQUE(ParticipantId, CategoryId)
);

CREATE TABLE dbo.Results (
    ResultId INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentId INT NOT NULL UNIQUE,
    FinishTime TIME NOT NULL,
    OverallPosition INT NOT NULL CHECK (OverallPosition > 0),
    CategoryPosition INT NOT NULL CHECK (CategoryPosition > 0),
    RecordedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Results_Enrolments FOREIGN KEY (EnrolmentId) REFERENCES dbo.Enrolments(EnrolmentId)
);
GO

-- 3. Data Seeding
INSERT INTO dbo.Roles (RoleName) VALUES ('Organiser'), ('Participant');

-- Seed Users (2 Organisers, 2 Participants)
INSERT INTO dbo.Users (RoleId, FullName, Email, PasswordHash, PhoneNumber) VALUES
(1, 'Sipho Zulu', 'sipho@comrades.co.za', 'AQAAAAEAACcQAAAAEHASH1...', '+27821234567'),
(1, 'Anika van der Merwe', 'anika@cycletour.co.za', 'AQAAAAEAACcQAAAAEHASH2...', '+27839876543'),
(2, 'Thabo Molefe', 'thabo.runner@gmail.com', 'AQAAAAEAACcQAAAAEHASH3...', '+27711112222'),
(2, 'Sarah Jenkins', 'sarah.j@yahoo.com', 'AQAAAAEAACcQAAAAEHASH4...', '+27723334444');

-- Seed 3 Iconic SA Events
INSERT INTO dbo.Events (OrganiserId, Title, Description, Location, EventDate) VALUES
(1, 'Comrades Marathon 2027', 'The ultimate human race between Pietermaritzburg and Durban.', 'Durban, KZN', '2027-06-13 05:30:00'),
(2, 'Cape Town Cycle Tour', 'World-class 109km scenic cycle ride around the Cape Peninsula.', 'Cape Town, WC', '2027-03-14 06:00:00'),
(1, 'Soweto Marathon', 'The Peoples Marathon traversing historical landmarks in Soweto.', 'Soweto, GP', '2026-11-01 06:00:00');

-- Seed Categories
INSERT INTO dbo.Categories (EventId, CategoryName, DistanceKm, Fee) VALUES
(1, 'Ultra Marathon', 89.00, 1200.00),
(2, 'Main Cycle Race', 109.00, 850.00),
(2, 'Short Cycle Route', 42.00, 450.00),
(3, 'Full Marathon', 42.20, 350.00),
(3, 'Half Marathon', 21.10, 250.00),
(3, '10km Open Run', 10.00, 150.00);

-- Seed Enrolments
INSERT INTO dbo.Enrolments (ParticipantId, CategoryId) VALUES
(3, 1), -- Thabo in Comrades
(3, 4), -- Thabo in Soweto Full Marathon
(4, 2), -- Sarah in Cape Town Cycle Tour
(4, 6); -- Sarah in Soweto 10km

-- Seed Sample Results
INSERT INTO dbo.Results (EnrolmentId, FinishTime, OverallPosition, CategoryPosition) VALUES
(1, '06:14:22', 142, 38),
(3, '03:45:10', 88, 12);
GO
