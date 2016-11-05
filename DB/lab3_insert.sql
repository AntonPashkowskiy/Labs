USE [ComputersRepairService]
GO

INSERT INTO [dbo].[Address] ([Country], [City], [Street])
VALUES
(N'Belarus', N'Minsk', N'Goretskya'),
(N'Belarus', N'Vitebsk', N'Goretskya'),
(N'Belarus', N'Brest', N'Goretskya'),
(N'Belarus', N'Test', N'Goretskya')
GO

INSERT INTO [dbo].[Document] ([FileName], [FileType], [Content])
VALUES
(N'file1.txt', N'text/txt', NULL),
(N'file2.txt', N'text/txt', NULL),
(N'file3.txt', N'text/txt', NULL),
(N'file4.txt', N'text/txt', NULL)
GO

INSERT INTO [dbo].[ContactDetails] ([FirstName], [LastName], [PhoneNumber], [Email])
VALUES
(N'Jugen', N'Raul', N'3123123', N'W@g.com'),
(N'Alex', N'Raul', N'3123123', N'W@g.com'),
(N'Tom', N'Raul', N'3123123', N'W@g.com'),
(N'Ron', N'Raul', N'3123123', N'W@g.com')
GO

INSERT INTO [dbo].[Role] ([Description], [Responsibility], [Salary])
VALUES
(N'Director', N'responsibility', 10000),
(N'Manager', N'responsibility', 1000),
(N'Cleaner', N'responsibility', 100)
GO

INSERT INTO [dbo].[Schedule] ([WeekDays], [Hours])
VALUES
(N'week days descrition 1', N'hours description 1'),
(N'week days descrition 2', N'hours description 2'),
(N'week days descrition 3', N'hours description 3')
GO

INSERT INTO [dbo].[Detail] ([Description], [Price])
VALUES
(N'Processor', 1200),
(N'HDD', 200),
(N'SSD', 1250),
(N'RAM S', 370)
GO

INSERT INTO [dbo].[Branch] ([AddressId], [RegistrationNumber], [StartDate])
VALUES
(1, 55443, GETDATE()),
(2, 12333, GETDATE())
GO

INSERT INTO [dbo].[Employee] ([BranchId], [RoleId], [ScheduleId], [StartDate])
VALUES
(1, 1, 2, GETDATE()),
(1, 2, 1, GETDATE()),
(1, 2, 3, GETDATE()),
(2, 3, 3, GETDATE())
GO

INSERT INTO [dbo].[Client] ([ContactDetailsId], [CountOfVisits])
VALUES
(1, 0),
(2, 0),
(3, 5)
GO

INSERT INTO [dbo].[Order] ([ClientId], [BranchId], [BillingAmount], [ServiceStartDay], [ServiceEndDay])
VALUES
(1, 1, 100, GETDATE(), GETDATE()),
(3, 1, 100, GETDATE(), GETDATE()),
(2, 2, 100, GETDATE(), GETDATE())
GO

INSERT INTO [dbo].[Equipment] ([OrderId], [Model], [BreakingDescription])
VALUES
(1, N'Model 1', N'Description 1'),
(2, N'Model 2', N'Description 2'),
(3, N'Model 3', N'Description 3'),
(3, N'Model 4', N'Description 4')
GO

INSERT INTO [dbo].[DetailProducer] ([BranchId], [AddressId], [ContactDetailsId], [CompanyName], [StartDate])
VALUES
(1, 2, 3, N'DDN', GETDATE()),
(2, 3, 4, N'ASPFORM', GETDATE())
GO

INSERT INTO [dbo].[ComputerDetail] ([DetailProducerId], [DetailId], [SupportedInterfaces], [WarrancyCardNumber])
VALUES
(1, 2, N'SFFE', 1234),
(1, 3, N'DSDER', 2434),
(1, 4, N'SAER', 5543),
(2, 2, N'SAER', 2342),
(2, 1, N'SDSD', 2345)
GO

INSERT INTO [dbo].[DetailProducerDocument] (DetailProducerId, DocumentId)
VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 2)
GO

INSERT INTO [dbo].[EmployeeDocument] (EmployeeId, DocumentId)
VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 2),
(3, 1),
(3, 2)
GO

INSERT INTO [dbo].[EquipmentDocument] (EquipmentId, DocumentId)
VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 2),
(3, 1),
(3, 2),
(4, 1),
(4, 2)
GO