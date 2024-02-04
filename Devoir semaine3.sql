USE library	
-- Devoir semaine 3
-- Écrire les requetes SQL pour obtenir les listes suivantes. Pour chacune des requetes,
-- bien vouloir mentionner en commentaire, le numero de la question ainsi que son enonce
-- Question 1. La liste des paires (auteur, editeur) demeurant dans la même ville;
SELECT A.author, P.publisher 
FROM authors A
JOIN publishers E ON A.city = E.city

-- Question 2. La liste des paires (auteur, éditeur) demeurant dans la même ville, incluant 
-- aussi les auteurs qui ne répondent pas à ce critère 10pts.
SELECT A.author, P.publisher
FROM authors A
LEFT JOIN publishers P ON A.city = P.city;
