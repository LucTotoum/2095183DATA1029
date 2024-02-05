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
SELECT A.au_fname, P.pub_name 
FROM authors A
LEFT JOIN publishers P ON A.city = P.city;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Question 4 La liste des paires (auteur, éditeur) demeurant dans la même ville, incluant aussi les auteurs et éditeurs qui ne répondent pas à ce critère
SELECT A.au_fname, P.pub_name 
FROM authors A
LEFT JOIN publishers P ON A.city = P.city OR P.city IS NULL;
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



