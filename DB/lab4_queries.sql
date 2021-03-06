-- 1
SELECT
    e.FIRST_NAME,
    e.LAST_NAME,
    e.PHONE_NUMBER,
    e.SALARY
FROM EMPLOYEES e
WHERE e.SALARY > 10000 AND 
      e.COMMISSION_PCT IS NOT NULL
ORDER BY e.SALARY DESC, e.PHONE_NUMBER

-- 2
SELECT 
    e.FIRST_NAME,
    e.LAST_NAME,
    j.JOB_TITLE
FROM EMPLOYEES e 
INNER JOIN DEPARTMENTS d ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
INNER JOIN JOBS j ON j.JOB_ID = e.JOB_ID
WHERE d.DEPARTMENT_NAME = N'IT'
ORDER BY e.SALARY DESC

-- 3
SELECT 
    e.LAST_NAME AS 'LAST NAME',
    e.FIRST_NAME AS 'FIRST NAME',
    d.DEPARTMENT_NAME AS 'DEPARTAMENT NAME',
    l.CITY  
FROM EMPLOYEES e
INNER JOIN DEPARTMENTS d ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
INNER JOIN LOCATIONS l ON l.LOCATION_ID = d.LOCATION_ID
WHERE l.CITY LIKE N'%th%'
ORDER BY e.LAST_NAME, e.FIRST_NAME

-- 4
SELECT DISTINCT
    j.JOB_TITLE
FROM EMPLOYEES e
INNER JOIN DEPARTMENTS d ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
INNER JOIN JOBS j ON j.JOB_ID = e.JOB_ID
WHERE d.DEPARTMENT_NAME IN (N'Marketing', N'Finance', N'Sales')

-- 5
SELECT
    e.EMPLOYEE_ID,
    e.LAST_NAME
FROM EMPLOYEES e 
INNER JOIN 
(
    SELECT
        e.LAST_NAME,
        COUNT(e.LAST_NAME) AS LAST_NAME_COUNT 
    FROM EMPLOYEES e
    GROUP BY e.LAST_NAME
) mt 
ON mt.LAST_NAME = e.LAST_NAME AND
   mt.LAST_NAME_COUNT > 1

-- 6
SELECT
    e1.LAST_NAME AS LAST_NAME1,
    e2.LAST_NAME AS LAST_NAME2,
    e2.DEPARTMENT_ID
FROM EMPLOYEES e1
CROSS JOIN EMPLOYEES e2
WHERE e1.DEPARTMENT_ID = e2.DEPARTMENT_ID AND
      e1.EMPLOYEE_ID != e2.EMPLOYEE_ID


-- 7
SELECT 
    e.FIRST_NAME,
    e.LAST_NAME,
    e.SALARY,
    s.AVG_SALARY
FROM EMPLOYEES e 
INNER JOIN 
(
    SELECT 
    j.JOB_ID,
    (j.MAX_SALARY + j.MIN_SALARY) / 2 AS AVG_SALARY
    FROM JOBS j
) s 
ON e.JOB_ID = s.JOB_ID AND
   e.SALARY >= s.AVG_SALARY
ORDER BY (e.SALARY - s.AVG_SALARY) DESC

-- 8
SELECT 
    e.LAST_NAME AS EMPLOYEE_LAST_NAME,
    m.LAST_NAME AS MANAGER_LAST_NAME,
    d.DEPARTMENT_NAME
FROM EMPLOYEES e
INNER JOIN DEPARTMENTS d 
ON d.DEPARTMENT_ID = e.DEPARTMENT_ID AND
   d.MANAGER_ID = e.MANAGER_ID
INNER JOIN EMPLOYEES m
ON e.MANAGER_ID = m.EMPLOYEE_ID
ORDER BY d.DEPARTMENT_NAME

-- 9
SELECT 
    e.LAST_NAME,
    e.FIRST_NAME,
    j.JOB_TITLE,
    d.DEPARTMENT_NAME,
    l.CITY
FROM EMPLOYEES e
LEFT JOIN DEPARTMENTS d ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
LEFT JOIN LOCATIONS l ON l.LOCATION_ID = d.LOCATION_ID
LEFT JOIN JOBS j ON j.JOB_ID = e.JOB_ID
ORDER BY e.LAST_NAME, e.SALARY

-- 10
SELECT DISTINCT
    j.JOB_TITLE
FROM EMPLOYEES e
INNER JOIN JOBS j ON j.JOB_ID = e.JOB_ID

EXCEPT

SELECT DISTINCT
    j.JOB_TITLE
FROM JOB_HISTORY jh
INNER JOIN JOBS j ON j.JOB_ID = jh.JOB_ID
