-- Utiliser la base de données library_08_03_24.sql ci-jointe et donnez la requête 
-- qui renvoie les résultats suivants : 
-- 1. Noms complets des employés Les plus haut grade par employeurs. (10 pts)
USE library;
SELECT CONCAT( fname, " ", lname) AS fullname, job_lvl, pub_name
FROM employees e JOIN publishers p ON e.pub_id = p. pub_id
WHERE job_lvl=( SELECT MAX(job_lvl) FROM employees
WHERE pub_id = e.pub_id);

-- 2. Noms complets des employés ayant un salaire supérieur à celui de Norbert Zongo.
-- (10 pts)
SELECT CONCAT( fname, " ", lname) AS fullname
FROM employees WHERE salary > (SELECT salary FROM employees 
WHERE fname = "Norbert" AND lname = "zongo");

