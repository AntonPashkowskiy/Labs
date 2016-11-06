/*
Сформировать таблицу содержащую информацию о заказах на технику HP. В результат должны войти -
информация о заказе, информация о клиенте, информация о технике. Ссылки из таблицы результата исключить.
Отсортировать по стоимости ремонта по убыванию. Колонки результирующей таблицы привести в удобочитаемый вид.
*/

SELECT
    o.BillingAmount AS 'Order Billing Amount',
    o.ServiceStartDay AS 'Service Start Day',
    o.ServiceStartDay AS 'Service End Day',
    c.CountOfVisits AS 'Client Count of Visits',
    cd.FirstName AS 'First Name',
    cd.LastName AS 'Last Name',
    cd.PhoneNumber AS 'Phone Number',
    cd.Email,
    e.Model,
    e.BreakingDescription AS 'Breaking Description'
FROM [Order] o
INNER JOIN [Client] c ON c.Id = o.ClientId
INNER JOIN [ContactDetails] cd ON cd.Id = c.ContactDetailsId
INNER JOIN [Equipment] e ON e.OrderId = o.Id
WHERE e.Model LIKE '%HP%'
ORDER BY o.BillingAmount DESC

/*
Сформировать таблицу содержацую информацию о всех сотрудниках всех филиалов. 
Добавить информацию о их должностях и расписании. Отсортировать сотрудников по
убыванию зп и по возрастанию описания роли. Привести названия колонок в удобочитаемый вид.
*/

SELECT
    e.StartDate AS 'Start Date',
    r.[Description],
    r.Responsibility,
    r.Salary,
    sc.[Hours],
    sc.WeekDays AS 'Week Days' 
FROM [Employee] e
LEFT JOIN [Schedule] sc ON sc.Id = e.ScheduleId
LEFT JOIN [Role] r ON r.Id = e.RoleId
ORDER BY r.Salary DESC, r.[Description] 

/*
Вывести список файлов которые лежат в системе мёртвым грузом. (нет ни одной ссылки на файл).
*/

SELECT * FROM Document

EXCEPT

SELECT DISTINCT di.*
FROM
(
    SELECT 
        d.* 
    FROM [EmployeeDocument] ed
    INNER JOIN [Document] d ON d.Id = ed.DocumentId

    UNION ALL

    SELECT
        d.*
    FROM [DetailProducerDocument] dpd
    INNER JOIN [Document] d ON d.Id = dpd.DocumentId

    UNION ALL

    SELECT 
        d.*
    FROM [EquipmentDocument] ed
    INNER JOIN [Document] d ON d.Id = ed.DocumentId
) di