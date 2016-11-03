USE [master]
GO

IF DB_ID('ComputersRepairService') IS NULL
BEGIN
    CREATE DATABASE [ComputersRepairService]
END
GO

USE [ComputersRepairService]
GO

IF OBJECT_ID('dbo.Address') IS NULL
BEGIN
    CREATE TABLE [dbo].[Address] 
    (
        [Id] INT NOT NULL CONSTRAINT PK_Address PRIMARY KEY,
        [Country] NVARCHAR(50),
        [City] NVARCHAR(50),
        [Street] NVARCHAR(50)
    )
END
GO

IF OBJECT_ID('dbo.Document') IS NULL
BEGIN
    CREATE TABLE [dbo].[Document]
    (
        [Id] INT NOT NULL CONSTRAINT Pk_Document PRIMARY KEY,
        [FileName] NVARCHAR(1000),
        [FileType] NVARCHAR(50),
        Content BINARY NULL
    )
END
GO


IF OBJECT_ID('dbo.ContactDetails') IS NULL
BEGIN
    CREATE TABLE [dbo].[ContactDetails]
    (
        [Id] INT NOT NULL CONSTRAINT Pk_ContactDetails PRIMARY KEY,
        [FirstName] NVARCHAR(50),
        [LastName] NVARCHAR(50),
        [PhoneNumber] NVARCHAR(50),
        [Email] NVARCHAR(50)
    )
END
GO

IF OBJECT_ID('dbo.Role') IS NULL
BEGIN
    CREATE TABLE [dbo].[Role]
    (
        [Id] INT NOT NULL CONSTRAINT Pk_Role PRIMARY KEY,
        [Description] NVARCHAR(1000),
        [Responsibility] NVARCHAR(1000),
        [Salary] MONEY NOT NULL
    )
END
GO

IF OBJECT_ID('dbo.Schedule') IS NULL
BEGIN
    CREATE TABLE [dbo].[Schedule]
    (
        [Id] INT NOT NULL CONSTRAINT Pk_Schedule PRIMARY KEY,
        [WeekDays] NVARCHAR(1000),
        [Hours] NVARCHAR(1000)
    )
END
GO

IF OBJECT_ID('dbo.Detail') IS NULL
BEGIN
    CREATE TABLE [dbo].[Detail]
    (
        [Id] INT NOT NULL CONSTRAINT Pk_Detail PRIMARY KEY,
        [Description] NVARCHAR(1000),
        [Price] MONEY NOT NULL
    )
END
GO

IF OBJECT_ID('dbo.Branch') IS NULL
BEGIN
    CREATE TABLE [dbo].[Branch]
    (
        [Id] INT NOT NULL CONSTRAINT Pk_Branch PRIMARY KEY,
        [RegistrationNumber] INT NOT NULL,
        [AddressId] INT NOT NULL,
        [StartDate] DATE NOT NULL
    )
END
GO

IF OBJECT_ID('dbo.Branch') IS NOT NULL AND 
   OBJECT_ID('fkBranch_Address_Id') IS NULL
BEGIN
    ALTER TABLE [dbo].[Branch]
    ADD  CONSTRAINT [fkBranch_Address_Id] 
    FOREIGN KEY([AddressId])
    REFERENCES [dbo].[Address] ([Id])
END
GO

IF OBJECT_ID('dbo.Employee') IS NULL
BEGIN
    CREATE TABLE [dbo].[Employee]
    (
        [Id] INT NOT NULL CONSTRAINT Pk_Employee PRIMARY KEY,
        [ScheduleId] INT NOT NULL,
        [RoleId] INT NOT NULL,
        [BranchId] INT NOT NULL,
        [StartDate] DATE NOT NULL
    )
END
GO

IF OBJECT_ID('dbo.Employee') IS NOT NULL AND
   OBJECT_ID('fkEmployee_Schedule_Id') IS NULL AND
   OBJECT_ID('fkEmployee_Role_Id') IS NULL AND
   OBJECT_ID('fkEmployee_Branch_Id') IS NULL 
BEGIN
    ALTER TABLE [dbo].[Employee]
    ADD  CONSTRAINT [fkEmployee_Schedule_Id] 
    FOREIGN KEY([ScheduleId])
    REFERENCES [dbo].[Schedule] ([Id])

    ALTER TABLE [dbo].[Employee]
    ADD  CONSTRAINT [fkEmployee_Role_Id] 
    FOREIGN KEY([RoleId])
    REFERENCES [dbo].[Role] ([Id])

    ALTER TABLE [dbo].[Employee]
    ADD CONSTRAINT [fkEmployee_Branch_Id]
    FOREIGN KEY([BranchId])
    REFERENCES [dbo].[Branch] ([Id])
END
GO

IF OBJECT_ID('dbo.Client') IS NULL
BEGIN
    CREATE TABLE [dbo].[Client]
    (
        [Id] INT NOT NULL CONSTRAINT Pk_Client PRIMARY KEY,
        [CountOfVisits] INT NOT NULL,
        [ContactDetailsId] INT NOT NULL,
    )
END
GO

IF OBJECT_ID('dbo.Client') IS NOT NULL AND 
   OBJECT_ID('fkClient_ContactDetails_Id') IS NULL
BEGIN
    ALTER TABLE [dbo].[Client]
    ADD  CONSTRAINT [fkClient_ContactDetails_Id] 
    FOREIGN KEY([ContactDetailsId])
    REFERENCES [dbo].[ContactDetails] ([Id])
END
GO