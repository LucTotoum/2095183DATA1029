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

-- Question 3-Obtenir la liste des noms d’auteurs ayant touché une avance supérieure à toutes les avances versées par l'éditeur "Harmattan".
-- d'abord la liste des auteurs qui ont publiés chez
-- On sélectionne le nom de l'auteur et le montant de son avance
SELECT a.au_fname, c.avance
FROM Authors a
JOIN contrat c ON a.au_id = c.au_id
-- On filtre les auteurs qui ont un contrat avec un autre éditeur que "Harmattan"
WHERE c.pub_id <> (SELECT au_id FROM publishers WHERE pub_name = 'Harmattan')
-- On compare l'avance de chaque auteur avec le maximum des avances versées par "Harmattan"
AND c.avance > (SELECT MAX(avance) FROM contrat WHERE pub_id = (SELECT au_id FROM publishers WHERE pub_name = 'Harmattan'));
use library;
SELECT a.au_fname, c.avance
FROM Authors a
JOIN contrat c ON a.au_id = c.au_id
WHERE c.pub_id <> (SELECT au_id FROM publishers WHERE pub_name = 'Harmattan')
AND c.avance > (SELECT MAX(avance) FROM contrat WHERE pub_id = (SELECT au_id FROM publishers WHERE pub_name = 'Harmattan'));


