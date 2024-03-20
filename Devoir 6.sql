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

-- 3. Noms complets des employés des éditeurs canadiens. (10 pts)
SELECT CONCAT( fname, " ", lname) AS fullname
FROM employees E JOIN publishers P ON E.pub_id = P.pub_id
WHERE P.country = "canada";

-- 4. Noms complets des employés qui ont un manager. (10pts
-- le premier code ci-dessous est Sujet de reflexion
-- SELECT CONCAT( fname, " ", lname) AS fullname
-- FROM employees E WHERE EXISTS ( SELECT 1 FROM employees Em
-- WHERE Em.pub_id = E.pub_id AND Em.job_lvl > E.job_lvl);
-- apres constat que nous n'avons pas de niveau manger ou colonne manger, nous pouvons donc  ecrire: 
SELECT CONCAT(fname, " ", lname) AS fullname
FROM employees e
JOIN jobs j ON e.job_id = j.job_id
WHERE j.max_lvl = 'SENIOR' OR j.max_lvl = 'MANAGER';


-- 5. Noms complets des employés qui ont un salaire au-dessus de la moyenne de 
-- salaire chez leur employeur. (10 pts)
SELECT CONCAT(fname, ' ', lname) AS fullname
FROM employees E
JOIN (
    SELECT pub_id, AVG(salary) AS SM
    FROM employees
    GROUP BY pub_id
 ) SMe ON E.pub_id = SMe.pub_id
WHERE salary > SMe.SM;

-- 6. Noms complets des employés qui ont le salaire minimum de leur grade (10 pts)
SELECT CONCAT(fname, " ", lname) AS fullname
FROM employees E
JOIN (
    SELECT job_id, MIN(salary) AS minsalary
    FROM employees
    GROUP BY job_id
) min_sal ON E.job_id = min_sal.job_id AND E.salary = min_sal.minsalary;

-- 7. De quels types sont les livres les plus vendus? (10 pts)
-- SELECT type FROM titles t ORDER BY t.ytd_sales DESC limit 1;
SELECT t.type, SUM(s.qty) AS total_quantity
FROM titles t
JOIN sales s ON t.title_id = s.title_id
GROUP BY t.type
ORDER BY total_quantity DESC;


-- 8. Pour chaque boutique, les 2 livres les plus vendus et leurs prix. (10 pts)
SELECT s.stor_id, t.title, t.price 
FROM sales s 
JOIN titles t ON s.title_id = t.title_id 
JOIN stores st ON s.stor_id = st.stor_id
ORDER BY s.qty DESC 
LIMIT publisherstitleauthorsalesauthors2;

-- 9. Les auteurs des 5 livres les plus vendus. (10 pts)
-- SELECT CONCAT(a.au_fname, ' ', a.au_lname) AS fullname
-- FROM authors a
-- JOIN titleauthor ta ON a.au_id = ta.au_id
-- JOIN titles t ON ta.title_id = t.title_id
-- ORDER BY t.ytd_sales DESC
-- LIMIT 5;-- ou encore le code en dessous
-- SELECT a.au_fname, a.au_lname
-- FROM authors a
-- JOIN titleauthor ta ON a.au_id = ta.au_id
--  JOIN titles t ON ta.title_id = t.title_id
-- ORDER BY t.ytd_sales DESC
-- LIMIT 5;
SELECT a.au_fname, a.au_lname, t.title, SUM(s.qty) AS total_sales
FROM sales s
JOIN titles t ON s.title_id = t.title_id
JOIN titleauthor ta ON t.title_id = ta.title_id
JOIN authors a ON ta.au_id = a.au_id
GROUP BY t.title_id, a.au_id
ORDER BY total_sales DESC
LIMIT 5;


-- 10. Prix moyens des livres par maisons d’édition. (10 pts)
SELECT pub_name, AVG(price) AS PM
FROM titles t JOIN publishers p ON t.pub_id = p.pub_id
GROUP BY p.pub_name;

-- 11. Les 3 auteurs ayant les plus de livres (10 pts
SELECT CONCAT(a.au_fname, ' ', a.au_lname) AS fullname, COUNT(ta.title_id) AS Dcpte
FROM authors a
JOIN titleauthor ta ON a.au_id = ta.au_id
GROUP BY a.au_id, a.au_fname, a.au_lname
ORDER BY Dcpte DESC
LIMIT 3;

