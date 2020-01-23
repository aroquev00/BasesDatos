-- 1.  List number of female and male members.
SELECT sex, COUNT(*) AS num
FROM Member
GROUP BY sex;

-- 2. Get the number of records (cardinality) of the Videos Table.
SELECT count(*) as Cardinality
FROM Video;

-- 3. Get Fname and Lname of all members, sorted by fname, lname
SELECT fName, lName
FROM Member
ORDER BY fName, lName;

-- 4. Get the Title of the movie and the name of the director
SELECT title, DirectorName
FROM Video V
JOIN Director D ON V.DirectorNo = D.DirectorNo;

-- 5. What is the Inventory value that StayHome has?  (Each copy of the movie is valued at the Movie Price)
SELECT SUM(V.price)
FROM VideoForRent VFR 
JOIN Video V ON VFR.catalogNo = V.catalogNo

-- 6. Get the video title and the number of copies for each movie
SELECT V.title, COUNT(*) AS Copies
FROM VideoForRent VFR 
JOIN Video V ON VFR.catalogNo = V.catalogNo
GROUP BY V.catalogNo;

-- 7. Get the category  and the number of movies in each category
SELECT V.category, COUNT(*) AS NumTitles
FROM Video V
GROUP BY category;
 
-- 8. Get the movie titles that have the highest daily rent
SELECT V.title
FROM Video V
ORDER BY dailyRental DESC;

-- 9. Get the title of the movie and the income obtained by rentals
SELECT V.title, V.price * COUNT() AS income
FROM RentalAgreement RA
JOIN VideoForRent VFR ON RA.videoNo = VFR.videoNo
JOIN Video V ON VFR.catalogNo = V.catalogNo
GROUP BY catalogNo
ORDER BY income;

-- 10. Get first name, last name of members that have a movie rented and still  not returned
SELECT DISTINCT fName, lName 
FROM RentalAgreement RA
JOIN Member M ON RA.memberNo = M.memberNo
WHERE DATEDIFF(DAY, dateReturn, dateOut) > DATEDIFF(DAY, GETDATE(), dateOut);

-- 11. Get Title of the movie with the highest  number of rentals
SELECT V.title, COUNT(*) AS cuenta
FROM RentalAgreement RA
JOIN VideoForRent VFR ON RA.videoNo = VFR.videoNo
JOIN Video V ON VFR.catalogNo = V.catalogNo
GROUP BY catalogNo
ORDER BY cuenta;

-- 12. Get the first name, last name and the birthday of the members of the club who celebrate   birthday today
SELECT fName, lName, DOB
FROM Member
WHERE DATEDIFF(DAY, GETDATE(), DOB) = 0;

-- 13. Get Title of the movie  that has not been rented ever
SELECT V.title
FROM Video V
WHERE V.catalogNo NOT IN (
    SELECT DISTINCT RA.catalogNo
    FROM RentalAgreement RA
    JOIN VideoForRent VFR ON RA.videoNo = VFR.videoNo
);

-- 14. Get the first name, last name of the members that were born the same year as Lorna Smith, but do not include Lorna Smith in the output
SELECT fName, lName 
FROM Member
WHERE YEAR(DOB) = (
    SELECT YEAR(DOB) 
    FROM Member 
    WHERE fName = 'Lorna' AND lName = 'Smith'
)
EXCEPT
SELECT fName, lName 
FROM Member
WHERE fName = 'Lorna' AND lName = 'Smith';

-- 15. Get the first name and last name (fName y lName) of the members that have rented the highest number of videos. 
SELECT fName, lName, COUNT(*) AS cuenta
FROM RentalAgreement RA
JOIN Member M ON RA.memberNo = M.memberNo
GROUP BY memberNo
ORDER BY cuenta;