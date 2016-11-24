/*
1. Создать новый филиал (Branch) c регистрационным номером на 1 больше максимального сущесвующего.
   Дата старта - сейчас. Адрес - последний добавленный.
*/

INSERT INTO [dbo].[Branch]
(
    [AddressId],
    [RegistrationNumber],
    [StartDate]
)
SELECT * FROM 
(
    SELECT 
        (SELECT MAX(a.Id) FROM [dbo].[Address] a) AS AddressId,
        MAX(b.RegistrationNumber) + 1 AS RegistrationNumber,
        GETDATE() AS StartDate
    FROM [dbo].[Branch] b
) st

/*
4. Повысить цену на все заказы длительность которых занимает меньше дня.
*/

UPDATE [dbo].[Order]
SET
    [BillingAmount] = [BillingAmount] + 100
WHERE DATEDIFF(DAY, [ServiceStartDay], [ServiceEndDay]) = 0

/*
6. Удалить все документы на которые нету ссылок.
*/

DELETE FROM [dbo].[Document]
WHERE [Id] IN
(
    SELECT d.Id FROM Document d

    EXCEPT

    SELECT DISTINCT *
    FROM
    (
        SELECT 
            d.Id
        FROM [EmployeeDocument] ed
        INNER JOIN [Document] d ON d.Id = ed.DocumentId

        UNION ALL

        SELECT
            d.Id
        FROM [DetailProducerDocument] dpd
        INNER JOIN [Document] d ON d.Id = dpd.DocumentId

        UNION ALL

        SELECT 
            d.Id
        FROM [EquipmentDocument] ed
        INNER JOIN [Document] d ON d.Id = ed.DocumentId
    ) di
)