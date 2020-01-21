-- #11 Armando Roque Villasana A01138717

-- 1. List Department names
SELECT dname 
FROM department;

-- 2. List first name and Last name of all women employees.
SELECT fname, lname 
FROM employee
WHERE sex='F';

-- 3. List employee first and last name and the department name in which he works
SELECT fname, lname, dname
FROM employee JOIN department
ON dno=dnumber;

--4. List name of department  and the first name and last name of the department manager
SELECT dname, fname, lname 
FROM department JOIN employee
ON mgrssn=ssn;

--5. Retrieve the name and address of all employees who work for the 'Research' department
SELECT fname, lname, addres
FROM employee
WHERE dno = (
    SELECT dnumber
    FROM department WHERE dname='Research'
);

SELECT fname, lname, addres
FROM employee JOIN department
ON dno=dnumber
WHERE dname='Research';

--6. For every project located in 'Stafford', list the project number, the controlling department number, and the department manager's last name, address, and birthdate.
SELECT pnumber, dnum, lname, addres, bdate
FROM project JOIN department
ON dnum=dnumber
JOIN employee
ON mgrssn=ssn
WHERE plocation='Stafford';

--7. Make a list of project numbers for projects that involve an employee whose last name is 'Smith', either as a worker or as a manager of the department that controls the project.
SELECT pno
FROM works_on 
WHERE essn = (
    SELECT ssn 
    FROM employee
    WHERE lname='Smith'
)
UNION
SELECT pnumber
FROM project
WHERE dnum = (
    SELECT dnumber
    FROM department
    WHERE mgrssn = (
        SELECT ssn
        FROM employee
        WHERE lname = 'Smith'
    )
);

-- with joins
SELECT pno
FROM employee JOIN works_on
ON ssn=essn
WHERE lname='Smith'
UNION
SELECT lname
FROM project JOIN department
ON dnum=dnumber
JOIN employee
ON mgrssn=ssn
WHERE lname='Smith';

--8. Retrieve the names of employees who have no dependents.
SELECT fname, lname
FROM employee
WHERE ssn NOT IN (
    SELECT essn
    FROM dependent
);

SELECT fname, lname
FROM employee LEFT JOIN dependent
ON ssn=essn
WHERE essn IS NULL;


--9. Retrieve the names of managers who have at least one dependent.
SELECT fname, lname
FROM employee
WHERE ssn IN (
    SELECT essn
    FROM dependent
)
AND ssn IN (
    SELECT mgrssn
    FROM department
);

--10. Retrieve name of the employee and the name of the supervisor.
 SELECT e.fname, e.lname, s.fname, s.lname
 FROM employee e JOIN employee s
 ON e.superssn=s.ssn;

--Optional queries:
 
--11. List the names of all employees with two or more dependents.
SELECT fname, lname
FROM employee
WHERE 2 <= (
    SELECT COUNT(essn)
    FROM dependent
    WHERE ssn=essn
);

--12. Find the names of employees who work on all the projects controlled by department number 5.
SELECT fname, lname
FROM employee
WHERE (
    SELECT COUNT(dnum)
    FROM project
    WHERE dnum = 5
) = (
    SELECT count(pno)
    from works_on
    WHERE (
        5 = (
            SELECT dnum
            from project
            WHERE (
                pnumber = pno
            )
        )
        AND ssn = essn
    )
);
