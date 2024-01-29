-- exercice 1
-- À partir de la table « titles », obtenir la liste des titres contenant le mot « computer » Afficher le 
-- titre et le prix de chaque livre.
-- select * from titles liste tous les titles
select title, price from titles
where title like '%computer%';