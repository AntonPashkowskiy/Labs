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

IF OBJECT_ID('dbo.Order') IS NULL
BEGIN
    CREATE TABLE [dbo].[Order]
    (
        [Id] INT NOT NULL CONSTRAINT Pk_Order PRIMARY KEY,
        [ClientId] INT NOT NULL,
        [BranchId] INT NOT NULL,
        [BillingAmount] INT NOT NULL,
        [ServiceStartDay] DATE NOT NULL,
        [ServiceEndDay] DATE NOT NULL
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

IF OBJECT_ID('dbo.Equipment') IS NULL
BEGIN
    CREATE TABLE [dbo].[Equipment]
    (
        [Id] INT NOT NULL CONSTRAINT Pk_Equipment PRIMARY KEY,
        [OrderId] INT NOT NULL,
        [Model] NVARCHAR(500),
        [BreakingDescription] NVARCHAR(1000)
    )
END
GO

IF OBJECT_ID('dbo.Equipment') IS NOT NULL AND 
   OBJECT_ID('fkEquipment_Order_Id') IS NULL
BEGIN
    ALTER TABLE [dbo].[Equipment]
    ADD  CONSTRAINT [fkEquipment_Order_Id] 
    FOREIGN KEY([OrderId])
    REFERENCES [dbo].[Order] ([Id])
END
GO

IF OBJECT_ID('dbo.DetailProducer') IS NULL
BEGIN
    CREATE TABLE [dbo].[DetailProducer]
    (
        [Id] INT NOT NULL CONSTRAINT Pk_DetailProducer PRIMARY KEY,
        [BranchId] INT NOT NULL,
        [AddressId] INT NOT NULL,
        [ContactDetailsId] INT NOT NULL,
        [CompanyName] NVARCHAR(500),
        [StartDate] DATE NOT NULL
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

IF OBJECT_ID('dbo.ComputerDetail') IS NULL
BEGIN
    CREATE TABLE [dbo].[ComputerDetail]
    (
        [DetailProducerId] INT NOT NULL,
        [DetailId] INT NOT NULL,
        [SupportedInterfaces] NVARCHAR(1000),
        [WarrancyCardNumber] INT NOT NULL,
        CONSTRAINT Pk_ComputerDetail PRIMARY KEY (DetailProducerId, DetailId)
    )
END
GO

IF OBJECT_ID('dbo.ComputerDetail') IS NOT NULL AND 
   OBJECT_ID('fkComputerDetail_DetailProducer_Id') IS NULL AND 
   OBJECT_ID('fkComputerDetail_Detail_Id') IS NULL
BEGIN
    ALTER TABLE [dbo].[ComputerDetail]
    ADD  CONSTRAINT [fkComputerDetail_DetailProducer_Id]
    FOREIGN KEY([DetailProducerId])
    REFERENCES [dbo].[DetailProducer] ([Id])

    ALTER TABLE [dbo].[ComputerDetail]
    ADD  CONSTRAINT [fkComputerDetail_Detail_Id]
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

IF OBJECT_ID('dbo.EquipmentDocument') IS NULL
BEGIN
    CREATE TABLE [dbo].[EquipmentDocument]
    (
        [EquipmentId] INT NOT NULL,
        [DocumentId] INT NOT NULL,
        CONSTRAINT Pk_EquipmentDocument PRIMARY KEY (EquipmentId, DocumentId)
    )
END
GO

IF OBJECT_ID('dbo.EquipmentDocument') IS NOT NULL AND 
   OBJECT_ID('fkEquipmentDocument_Equipment_Id') IS NULL AND 
   OBJECT_ID('fkEquipmentDocument_Document_Id') IS NULL
BEGIN
    ALTER TABLE [dbo].[EquipmentDocument]
    ADD  CONSTRAINT [fkEquipmentDocument_Equipment_Id]
    FOREIGN KEY([EquipmentId])
    REFERENCES [dbo].[Equipment] ([Id])

    ALTER TABLE [dbo].[EquipmentDocument]
    ADD  CONSTRAINT [fkEquipmentDocument_Document_Id]
    FOREIGN KEY([DocumentId])
    REFERENCES [dbo].[Document] ([Id])
END
GO

/* rollback script

EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'ComputersRepairService'
GO

USE [master]
GO

DROP DATABASE [ComputersRepairService]
GO

*/