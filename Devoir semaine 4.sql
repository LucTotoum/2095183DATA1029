-- Devoir Semaine 4
-- 1- Obtenir la liste des auteurs dont l’éditeur « Harmattan » n’a publié aucun livre
USE library;
SELECT DISTINCT a.au_id, a.au_fname, a.au_lname
FROM authors a
LEFT JOIN titleauthor ta ON a.au_id = ta.au_id
LEFT JOIN titles t ON ta.title_id = t.title_id
LEFT JOIN publishers p ON t.pub_id = p.pub_id
WHERE p.pub_name IS NULL OR NOT p.pub_name ='Harmattan';
-- ou encore , nous pouvons d'abord déterminer tous les auteurs ayant publier chez harmattan. 
SELECT DISTINCT a.au_id
FROM authors a
JOIN titleauthor ta ON a.au_id = ta.au_id
JOIN titles t ON ta.title_id = t.title_id
JOIN publishers p ON t.pub_id = p.pub_id
WHERE p.pub_name = 'Harmattan';
-- deuxieme solution ,
SELECT DISTINCT au_id, au_fname, au_lname
FROM authors
WHERE au_id NOT IN (
    SELECT DISTINCT a.au_id
    FROM authors a
    JOIN titleauthor ta ON a.au_id = ta.au_id
    JOIN titles t ON ta.title_id = t.title_id
    JOIN publishers p ON t.pub_id = p.pub_id
    WHERE p.pub_name = 'Harmattan'
);

-- Question 2-Obtenir la liste des auteurs dont l’éditeur «Eyrolles » a publié tous les livres
SELECT Au.*
FROM authors Au
JOIN titles t ON Au.au_id = t.pub_id
JOIN publishers P ON t.pub_id = P.pub_id
WHERE p.pub_name = 'Eyrolles';


