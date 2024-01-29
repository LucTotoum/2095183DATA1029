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


