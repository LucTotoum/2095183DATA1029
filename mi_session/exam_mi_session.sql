-- exercice 2
USE epharmacy;
-- 1- La liste des utilisateurs de l’application selon leur rôle. Le résultat doit avoir la structure suivante (15 points) 
SELECT u.id, u.full_name, r.name AS role
FROM user u
JOIN role r ON u.role_id = r.id;

-- 2- Noms et quantités des produits achetés par Oumar Moussa.

SELECT p.name AS nom_produit, ol.quantity
FROM User u
JOIN invoice i ON u.id = i.user_id
JOIN orders o ON i.order_id = o.id
JOIN orderline ol ON o.id = ol.order_id
JOIN product p ON ol.product_id = p.id
WHERE u.full_name = 'Oumar Moussa';

-- 3- Quel sont les noms de produits dont le fournisseur est basé à Moncton ? (25 
-- points)
SELECT p.name AS nom_produit
FROM product p
JOIN supplier s ON p.supplier_id = s.id
WHERE s.city = 'Moncton';

-- Qui a passé le plus de temps une fois connecté dans l’application (10 points).
SELECT u.full_name AS utilisateur, ch.onsite_time AS temps_passeconnection_historyuser_id
FROM user u
JOIN connection_history ch ON u.id = ch.user_id
ORDER BY temps_passe DESC
LIMIT 1;




