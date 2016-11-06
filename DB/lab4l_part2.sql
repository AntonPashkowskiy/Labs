/*
Сформировать таблицу, содержащую информацию о заказах с машинами марки HONDA.
В таблицу должны войти информация о заказе, контактные данные клиента, данные о технике.
Ссылки в итоговую таблицу не входят. Результат отсортировать по стоимости заказа по убыванию.
Колонки назвать так что бы они имели удобочитаемый вид.
*/

SELECT
   o.RepairPrice AS 'Repair Price',
   o.[Date] AS 'Order Start Date',
   cd.FirstName AS 'Client First Name',
   cd.LastName AS 'Client Last Name',
   cd.PhoneNumber As 'Client Phone Number',
   cd.Email AS 'Client Email',
   cr.Model AS 'Car Model',
   cr.Breaking AS 'Car Breaking'  
FROM [Order] o
INNER JOIN [Client] c ON o.ClientId = c.Id
INNER JOIN [ContactDetails] cd ON cd.Id = c.ContactDetailsId
INNER JOIN [Car] cr ON cr.OrderId = o.Id
WHERE cr.Model LIKE '%Honda%'
ORDER BY o.RepairPrice DESC 

/*
Сформировать таблицу сведений о все поставщиках оборудования для автомобилей. Указать 
адрес и контактные данные поставщиков. В таблицу с результатами не входят ссылки. Отсортировать результат
по фамилии и имени в контактных данных. Привести имена колонок в удобочитаемый вид.
*/

SELECT 
    dp.Name AS 'Detail Producer Name',
    a.Country AS 'Producer Country',
    a.City AS 'Producer City',
    a.Street AS 'Producer Street',
    cd.LastName AS 'Last Name',
    cd.FirstName AS 'First Name',
    cd.PhoneNumber AS 'Phone Number',
    cd.Email
FROM [DetailProducer] dp
LEFT JOIN [Address] a ON a.Id = dp.AddressId
LEFT JOIN [ContactDetails] cd ON cd.Id = dp.ContactDetailsId
ORDER BY cd.LastName, cd.FirstName

/*
Вывести список деталей, которые не поставляет ни один поставщик деталей.
В результате должна получится колонка Detail Description.
*/

SELECT DISTINCT
    d.[Description] AS 'Detail Description'
FROM Detail d

EXCEPT

SELECT DISTINCT
    d.[Description] AS 'Detail Description'
FROM DetailProducer dp
INNER JOIN CarDetail cd ON cd.DetailProducerId = dp.Id
INNER JOIN Detail d ON d.Id = cd.DetailId







