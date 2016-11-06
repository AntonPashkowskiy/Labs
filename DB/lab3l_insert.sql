USE [AutoRepairService]
GO

INSERT INTO [dbo].[Address] ([Country], [City], [Street])
VALUES
(N'France', N'Paris', N'Test'),
(N'France', N'Bret', N'Test'),
(N'France', N'Orea', N'Test'),
(N'France', N'Test', N'Test')
GO

INSERT INTO [dbo].[Document] ([FileName], [Content])
VALUES
(N'file1.txt', NULL),
(N'file2.txt', NULL),
(N'file3.txt', NULL),
(N'file4.txt', NULL)
GO

INSERT INTO [dbo].[ContactDetails] ([FirstName], [LastName], [PhoneNumber], [Email])
VALUES
(N'Anton', N'Zever', N'123123', N'Sara@gmail.com'),
(N'Juri', N'Zever', N'123123', N'Sara@gmail.com'),
(N'Panda', N'Zever', N'123123', N'Sara@gmail.com'),
(N'Alex', N'Zever', N'123123', N'Sara@gmail.com')
GO

INSERT INTO [dbo].[Role] ([Description], [Responsibility])
VALUES
(N'Director', N'responsibility description'),
(N'Manager', N'responsibility description'),
(N'Coder', N'responsibility description')
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

INSERT INTO [dbo].[Branch] ([AddressId], [Name])
VALUES
(1, N'First branch'),
(2, N'Second branch')
GO

INSERT INTO [dbo].[Employee] ([BranchId], [RoleId], [ScheduleId], [ContactDetailsId])
VALUES
(1, 1, 2, 1),
(1, 2, 1, 2),
(1, 2, 3, 3),
(2, 3, 3, 4)
GO

INSERT INTO [dbo].[Client] ([ContactDetailsId])
VALUES
(1),
(2),
(3)
GO

INSERT INTO [dbo].[Order] ([ClientId], [BranchId], [RepairPrice], [Date])
VALUES
(1, 2, 110, GETDATE()),
(3, 1, 110, GETDATE()),
(2, 1, 110, GETDATE())
GO

INSERT INTO [dbo].[Car] ([OrderId], [Model], [Breaking])
VALUES
(1, N'Honda', N'Breaking description 1'),
(2, N'BMW', N'Breaking description 2'),
(3, N'Shkoda', N'Breaking description 3'),
(3, N'Suzuki', N'Breaking description 4')
GO

INSERT INTO [dbo].[DetailProducer] ([BranchId], [AddressId], [ContactDetailsId], [Name])
VALUES
(1, 2, 3, N'SDSaS'),
(2, 3, 4, N'UNIRpoR')
GO

INSERT INTO [dbo].[CarDetail] ([DetailProducerId], [DetailId], [LifeTime])
VALUES
(1, 2, N'Test'),
(1, 3, N'Test'),
(1, 4, N'Test'),
(2, 2, N'Test'),
(2, 1, N'Test')
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

INSERT INTO [dbo].[CarDocument] (CarId, DocumentId)
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