USE [master]
GO

IF DB_ID('AutoRepairService') IS NULL
BEGIN
    CREATE DATABASE [AutoRepairService]
END
GO

USE [AutoRepairService]
GO

IF OBJECT_ID('dbo.Address') IS NULL
BEGIN
    CREATE TABLE [dbo].[Address] 
    (
        [Id] INT NOT NULL IDENTITY(1, 1) CONSTRAINT PK_Address PRIMARY KEY,
        [Country] NVARCHAR(100),
        [City] NVARCHAR(100),
        [Street] NVARCHAR(100)
    )
END
GO

IF OBJECT_ID('dbo.Document') IS NULL
BEGIN
    CREATE TABLE [dbo].[Document]
    (
        [Id] INT NOT NULL IDENTITY(1, 1) CONSTRAINT Pk_Document PRIMARY KEY,
        [FileName] NVARCHAR(500),
        [Content] BINARY NULL
    )
END
GO

IF OBJECT_ID('dbo.ContactDetails') IS NULL
BEGIN
    CREATE TABLE [dbo].[ContactDetails]
    (
        [Id] INT NOT NULL IDENTITY(1, 1) CONSTRAINT Pk_ContactDetails PRIMARY KEY,
        [FirstName] NVARCHAR(100),
        [LastName] NVARCHAR(100),
        [PhoneNumber] NVARCHAR(100),
        [Email] NVARCHAR(100)
    )
END
GO

IF OBJECT_ID('dbo.Role') IS NULL
BEGIN
    CREATE TABLE [dbo].[Role]
    (
        [Id] INT NOT NULL IDENTITY(1, 1) CONSTRAINT Pk_Role PRIMARY KEY,
        [Description] NVARCHAR(500),
        [Responsibility] NVARCHAR(500)
    )
END
GO

IF OBJECT_ID('dbo.Schedule') IS NULL
BEGIN
    CREATE TABLE [dbo].[Schedule]
    (
        [Id] INT NOT NULL IDENTITY(1, 1) CONSTRAINT Pk_Schedule PRIMARY KEY,
        [WeekDays] NVARCHAR(1000),
        [Hours] NVARCHAR(1000)
    )
END
GO

IF OBJECT_ID('dbo.Detail') IS NULL
BEGIN
    CREATE TABLE [dbo].[Detail]
    (
        [Id] INT NOT NULL IDENTITY(1, 1) CONSTRAINT Pk_Detail PRIMARY KEY,
        [Description] NVARCHAR(1000),
        [Price] MONEY NOT NULL
    )
END
GO

IF OBJECT_ID('dbo.Branch') IS NULL
BEGIN
    CREATE TABLE [dbo].[Branch]
    (
        [Id] INT NOT NULL IDENTITY(1, 1) CONSTRAINT Pk_Branch PRIMARY KEY,
        [Name] NVARCHAR(50) NOT NULL,
        [AddressId] INT NOT NULL
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
        [Id] INT NOT NULL IDENTITY(1, 1) CONSTRAINT Pk_Employee PRIMARY KEY,
        [ScheduleId] INT NOT NULL,
        [RoleId] INT NOT NULL,
        [BranchId] INT NOT NULL,
        [ContactDetailsId] INT NOT NULL
    )
END
GO

IF OBJECT_ID('dbo.Employee') IS NOT NULL AND
   OBJECT_ID('fkEmployee_Schedule_Id') IS NULL AND
   OBJECT_ID('fkEmployee_Role_Id') IS NULL AND
   OBJECT_ID('fkEmployee_Branch_Id') IS NULL AND
   OBJECT_ID('fkEmployee_ContactDetails_Id') IS NULL
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

    ALTER TABLE [dbo].[Employee]
    ADD CONSTRAINT [fkEmployee_ContactDetails_Id]
    FOREIGN KEY([ContactDetailsId])
    REFERENCES [dbo].[ContactDetails] ([Id])
END
GO

IF OBJECT_ID('dbo.Client') IS NULL
BEGIN
    CREATE TABLE [dbo].[Client]
    (
        [Id] INT NOT NULL IDENTITY(1, 1) CONSTRAINT Pk_Client PRIMARY KEY,
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

IF OBJECT_ID('dbo.Order') IS NULL
BEGIN
    CREATE TABLE [dbo].[Order]
    (
        [Id] INT NOT NULL IDENTITY(1, 1) CONSTRAINT Pk_Order PRIMARY KEY,
        [ClientId] INT NOT NULL,
        [BranchId] INT NOT NULL,
        [RepairPrice] MONEY NOT NULL,
        [Date] DATE NOT NULL
    )
END
GO

IF OBJECT_ID('dbo.Order') IS NOT NULL AND 
   OBJECT_ID('fkOrder_Client_Id') IS NULL AND
   OBJECT_ID('fkOrder_Branch_Id') IS NULL
BEGIN
    ALTER TABLE [dbo].[Order]
    ADD  CONSTRAINT [fkOrder_Client_Id] 
    FOREIGN KEY([ClientId])
    REFERENCES [dbo].[Client] ([Id])

    ALTER TABLE [dbo].[Order]
    ADD CONSTRAINT [fkOrder_Branch_Id]
    FOREIGN KEY([BranchId])
    REFERENCES [dbo].[Branch] ([Id])
END
GO

IF OBJECT_ID('dbo.Car') IS NULL
BEGIN
    CREATE TABLE [dbo].[Car]
    (
        [Id] INT NOT NULL IDENTITY(1, 1) CONSTRAINT Pk_Car PRIMARY KEY,
        [OrderId] INT NOT NULL,
        [Model] NVARCHAR(500),
        [Breaking] NVARCHAR(500)
    )
END
GO

IF OBJECT_ID('dbo.Car') IS NOT NULL AND 
   OBJECT_ID('fkCar_Order_Id') IS NULL
BEGIN
    ALTER TABLE [dbo].[Car]
    ADD  CONSTRAINT [fkCar_Order_Id] 
    FOREIGN KEY([OrderId])
    REFERENCES [dbo].[Order] ([Id])
END
GO

IF OBJECT_ID('dbo.DetailProducer') IS NULL
BEGIN
    CREATE TABLE [dbo].[DetailProducer]
    (
        [Id] INT NOT NULL IDENTITY(1, 1) CONSTRAINT Pk_DetailProducer PRIMARY KEY,
        [BranchId] INT NOT NULL,
        [AddressId] INT NOT NULL,
        [ContactDetailsId] INT NOT NULL,
        [Name] NVARCHAR(500)
    )
END
GO

IF OBJECT_ID('dbo.DetailProducer') IS NOT NULL AND 
   OBJECT_ID('fkDetailProducer_Branch_Id') IS NULL AND
   OBJECT_ID('fkDetailProducer_Address_Id') IS NULL AND
   OBJECT_ID('fkDetailProducer_ContactDetails_Id') IS NULL
BEGIN
    ALTER TABLE [dbo].[DetailProducer]
    ADD  CONSTRAINT [fkDetailProducer_Branch_Id] 
    FOREIGN KEY([BranchId])
    REFERENCES [dbo].[Branch] ([Id])

    ALTER TABLE [dbo].[DetailProducer]
    ADD  CONSTRAINT [fkDetailProducer_Address_Id] 
    FOREIGN KEY([AddressId])
    REFERENCES [dbo].[Address] ([Id])

    ALTER TABLE [dbo].[DetailProducer]
    ADD  CONSTRAINT [fkDetailProducer_ContactDetails_Id] 
    FOREIGN KEY([ContactDetailsId])
    REFERENCES [dbo].[ContactDetails] ([Id])
END
GO

IF OBJECT_ID('dbo.CarDetail') IS NULL
BEGIN
    CREATE TABLE [dbo].[CarDetail]
    (
        [DetailProducerId] INT NOT NULL,
        [DetailId] INT NOT NULL,
        [LifeTime] NVARCHAR(50), 
        CONSTRAINT Pk_CarDetail PRIMARY KEY (DetailProducerId, DetailId)
    )
END
GO

IF OBJECT_ID('dbo.CarDetail') IS NOT NULL AND 
   OBJECT_ID('fkCarDetail_DetailProducer_Id') IS NULL AND 
   OBJECT_ID('fkCarDetail_Detail_Id') IS NULL
BEGIN
    ALTER TABLE [dbo].[CarDetail]
    ADD  CONSTRAINT [fkCarDetail_DetailProducer_Id]
    FOREIGN KEY([DetailProducerId])
    REFERENCES [dbo].[DetailProducer] ([Id])

    ALTER TABLE [dbo].[CarDetail]
    ADD  CONSTRAINT [fkCarDetail_Detail_Id]
    FOREIGN KEY([DetailId])
    REFERENCES [dbo].[Detail] ([Id])
END
GO

IF OBJECT_ID('dbo.DetailProducerDocument') IS NULL
BEGIN
    CREATE TABLE [dbo].[DetailProducerDocument]
    (
        [DetailProducerId] INT NOT NULL,
        [DocumentId] INT NOT NULL,
        CONSTRAINT Pk_DetailProducerDocument PRIMARY KEY (DetailProducerId, DocumentId)
    )
END
GO

IF OBJECT_ID('dbo.DetailProducerDocument') IS NOT NULL AND 
   OBJECT_ID('fkDetailProducerDocument_DetailProducer_Id') IS NULL AND 
   OBJECT_ID('fkDetailProducerDocument_Document_Id') IS NULL
BEGIN
    ALTER TABLE [dbo].[DetailProducerDocument]
    ADD  CONSTRAINT [fkDetailProducerDocument_DetailProducer_Id]
    FOREIGN KEY([DetailProducerId])
    REFERENCES [dbo].[DetailProducer] ([Id])

    ALTER TABLE [dbo].[DetailProducerDocument]
    ADD  CONSTRAINT [fkDetailProducerDocument_Document_Id]
    FOREIGN KEY([DocumentId])
    REFERENCES [dbo].[Document] ([Id])
END
GO

IF OBJECT_ID('dbo.EmployeeDocument') IS NULL
BEGIN
    CREATE TABLE [dbo].[EmployeeDocument]
    (
        [EmployeeId] INT NOT NULL,
        [DocumentId] INT NOT NULL,
        CONSTRAINT Pk_EmployeeDocument PRIMARY KEY (EmployeeId, DocumentId)
    )
END
GO

IF OBJECT_ID('dbo.EmployeeDocument') IS NOT NULL AND 
   OBJECT_ID('fkEmployeeDocument_Employee_Id') IS NULL AND 
   OBJECT_ID('fkEmployeeDocument_Document_Id') IS NULL
BEGIN
    ALTER TABLE [dbo].[EmployeeDocument]
    ADD  CONSTRAINT [fkEmployeeDocument_Employee_Id]
    FOREIGN KEY([EmployeeId])
    REFERENCES [dbo].[Employee] ([Id])

    ALTER TABLE [dbo].[EmployeeDocument]
    ADD  CONSTRAINT [fkEmployeeDocument_Document_Id]
    FOREIGN KEY([DocumentId])
    REFERENCES [dbo].[Document] ([Id])
END
GO

IF OBJECT_ID('dbo.CarDocument') IS NULL
BEGIN
    CREATE TABLE [dbo].[CarDocument]
    (
        [CarId] INT NOT NULL,
        [DocumentId] INT NOT NULL,
        CONSTRAINT Pk_CarDocument PRIMARY KEY (CarId, DocumentId)
    )
END
GO

IF OBJECT_ID('dbo.CarDocument') IS NOT NULL AND 
   OBJECT_ID('fkCarDocument_Car_Id') IS NULL AND 
   OBJECT_ID('fkCarDocument_Document_Id') IS NULL
BEGIN
    ALTER TABLE [dbo].[CarDocument]
    ADD  CONSTRAINT [fkCarDocument_Car_Id]
    FOREIGN KEY([CarId])
    REFERENCES [dbo].[Car] ([Id])

    ALTER TABLE [dbo].[CarDocument]
    ADD  CONSTRAINT [fkCarDocument_Document_Id]
    FOREIGN KEY([DocumentId])
    REFERENCES [dbo].[Document] ([Id])
END
GO

/* rollback script

EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'AutoRepairService'
GO

USE [master]
GO

DROP DATABASE [AutoRepairService]
GO

*/