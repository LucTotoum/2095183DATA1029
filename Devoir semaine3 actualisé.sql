USE library;
-- Devoir semaine 3
-- Écrire les requetes SQL pour obtenir les listes suivantes. Pour chacune des requetes,
-- bien vouloir mentionner en commentaire, le numero de la question ainsi que son enonce

-- Question 1. La liste des paires (auteur, editeur) demeurant dans la même ville;
SELECT A.au_fname, P.pub_name 
FROM authors A
JOIN publishers P ON A.city = P.city;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Question 2. La liste des paires (auteur, éditeur) demeurant dans la même ville, incluant 
-- aussi les auteurs qui ne répondent pas à ce critère 10pts.
SELECT A.au_fname, P.pub_name 
FROM authors A
LEFT JOIN publishers P ON A.city = P.city;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Question 3 La liste des paires (auteur, éditeur) demeurant dans la même ville, incluant 
-- aussi les éditeurs qui ne répondent pas à ce critère
USE library;
SELECT A.au_fname, P.pub_name 
FROM authors A
RIGHT JOIN publishers P ON A.city = P.city;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Question 4 La liste des paires (auteur, éditeur) demeurant dans la même ville, incluant aussi les auteurs et éditeurs qui ne répondent pas à ce critère
SELECT A.au_fname, P.pub_name 
FROM authors A
LEFT JOIN publishers P ON A.city = P.city
UNION
SELECT A.au_fname, P.pub_name 
FROM authors A
RIGHT JOIN publishers P ON A.city = P.city OR P.city IS NULL;
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Question 5. Effectif(nombre) d'employes par niveau d'experience
-- déterminons le niveau d'experience
SELECT * FROM employees;
-- reponse
SELECT job_lvl, COUNT(*) AS effectif
FROM employees
GROUP BY job_lvl;
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Question 6. Liste des employes par maison d'edition
SELECT E.emp_id, M.pub_name 
FROM employees E
JOIN publishers M ON E.pub_id = M.pub_id;

-- ou

SELECT CONCAT(fname," ", lname) AS  employes , pub_name 
FROM employees JOIN publishers ON employees.pub_id = publishers.pub_id
ORDER BY publishers.pub_id;






use library;
SELECT pub_name, pub_id
FROM publishers
WHERE pub_id IN
(
SELECT pub_id
FROM titles
WHERE type IN ('Business' , 'psychology')
);	

SELECT pub_name, publishers.pub_id 
from publishers
join titles on publishers.pub_id = titles.pub_id
where titles.type = 'Business' or titles.type = 'psychology';



-- .type = 'Business' or titles.type = 'psychology';
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Question7. Salaires horaires moyens des employes par maison d'edition
SELECT M.pub_name, AVG(S.salary) AS salaire_horaire_moyen
FROM employees S
JOIN publishers M ON S.pub_id = M.pub_id
GROUP BY m.pub_name;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Question 8- Effectif(nombre) d'employées de niveau SEINIOR par maison d'edition
SELECT M.pub_name, COUNT(*) AS effectif_senior
FROM employees E
JOIN publishers M ON E.pub_id = M.pub_id
WHERE E.job_lvl = 'SEINIOR'
GROUP BY M.pub_name;
-- vérifions 
SELECT * FROM publishers, employees;



