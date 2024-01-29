-- exercice 1
-- À partir de la table « titles », obtenir la liste des titres contenant le mot « computer » Afficher le 
-- titre et le prix de chaque livre.
-- select * from titles liste tous les titles
select title, price from titles
where title like '%computer%';

-- Exercice 2 : 
-- À partir de la table « titles », obtenir la liste des titres contenant le mot « computer » (au 
-- singulier). Afficher le titre et le prix de chaque livre
-- le mot "computer" étant au singulier, posons une condition
-- pour excluir le mot au pluriel"computers"
select * from titles; -- liste tous les titres
-- liste de titre avec mot "computer" exculuant le mot "computers"
select title, price from titles 
where title like'%computer%' and title not like "computers";

-- Exercice 3 : 
-- À partir de la table « titles », obtenir la liste des titres dont l’identifiant débute par SU ou BU. 
-- Afficher le titre et le prix de chaque livre
select * from titles; -- liste tous les titres
select title, price from titles 
where title_id like"SU%" or title_id  like "BU%";

-- Exercice 4 : 
-- À partir de la table « titles », obtenir la liste des titres dont l’identifiant ne débute pas par SU ou 
-- BU. Afficher le titre et le prix de chaque livre.
-- select * from titles liste tous les titles
SELECT title, price FROM titles
WHERE NOT (title_id LIKE 'SU%' OR title_id LIKE 'BU%');


-- Exercice 5 : 
-- À partir de la table « titles », obtenir la liste des titres ne débutant ni par S, ni par B, mais dont la 
-- seconde lettre est « o ». Afficher le titre et le prix.
-- select * from titles liste tous les titles
select title, price from titles
where not (title like 'S%' or title like 'B%') 
and SUBSTRING(title, 2, 1) = 'o';

-- Exercice 6 : 
-- À partir de la table « titles », obtenir la liste des titres ne débutant ni par S, ni par B, mais dont la 
-- 3ème lettre est « f ». Afficher le titre et le prix.
-- select * from titles liste tous les titles
select title, price from titles
where not (title like 'S%' or title like 'B%') 
and SUBSTRING(title, 3, 1) = 'f';




