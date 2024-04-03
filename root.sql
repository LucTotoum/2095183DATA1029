USE epharmacy;
SELECT user FROM mysql.user;
DROP USER 'pharma'@'localhost';
-- ------------------------------------------------------------------------------
-- 3/ Créeons un nouveau compte pharma avec pour mot de passe 1234.
CREATE USER "pharma"@"localhost" IDENTIFIED BY "1234";
-- accordons tous les privilèges a pharma pour qu'il puisse interagir avec la base de données
FLUSH PRIVILEGES; -- actualisations des privileges
GRANT ALL PRIVILEGES ON epharmacy.* TO 'pharma'@'localhost';
FLUSH PRIVILEGES; -- actualisations des privileges
-- -------------------------------------------------------------------------------------------------------
-- 4. Les noms complets utilisateurs de la e-pharmacie et la durée moyenne de chacun une fois connecté dans l’application ? 5pts
SELECT CONCAT(u.firstname, " ", u.lastname) AS "fullname",
AVG(TIMESTAMPDIFF(SECOND, c.login_date, c.logout_date))/60 AS "TMM"
FROM users u
JOIN connection_history c ON u.id = c.user_id
GROUP BY u.id, "fullname"
ORDER BY "fullname";
-- -------------------------------------------------------------------------------------------------------------------------
-- 5. Le rôle de l’utilisateur ayant passé le plus de temps étant connecté dans l’application ?
-- a/ Calculons d'abord le temps total de connexion pour chaque utilisateur.
-- b/ Trouvons l'utilisateur ayant le temps total de connexion le plus élevé.
-- c/ Obtenons le rôle de cet utilisateur.
SELECT r.name AS "Role",u.firstname,u.lastname,
    SUM(TIMESTAMPDIFF(MINUTE, ch.login_date, ch.logout_date)) AS "Temps Total"
FROM connection_history ch
JOIN users u ON ch.user_id = u.id
JOIN roles r ON u.role_id = r.id
GROUP BY u.id
ORDER BY "Temps Total" DESC
LIMIT 1;

-- --------------------------------------------------------------------------------------------------------------

-- 6. Les fournisseurs des 3 produits les plus commercialisés ? 7pts
SELECT p.name AS "Produit", s.name AS "Fournisseur", SUM(cp.quantity) AS "Qté Vdue"
FROM cart_product cp
JOIN products p ON cp.product_id = p.id
JOIN suppliers s ON p.supplier_id = s.id
GROUP BY cp.product_id
ORDER BY "Qté Vdue" DESC
LIMIT 3;
-- apres votre intervation, nous pouvons dire:
SELECT p.name AS "Produit", s.name AS "Fournisseur",
COUNT(cp.product_id) AS "Nombre de Commandes"
FROM orders o
JOIN carts c ON o.cart_id = c.id
JOIN cart_product cp ON c.id = cp.cart_id
JOIN products p ON cp.product_id = p.id
JOIN suppliers s ON p.supplier_id = s.id
GROUP BY p.id
ORDER BY "Nombre de Commandes" DESC
LIMIT 3;

-- ---------------------------------------------------------------------------------------------------------------------------
-- 7. Les chiffres d'affaires par entrepôts. 5pts
SELECT w.name AS "Entrepôt",
SUM(o.total_amount) AS "Chiffre d'affaires"
FROM orders o
JOIN carts c ON o.cart_id = c.id
JOIN cart_product cp ON c.id = cp.cart_id
JOIN products p ON cp.product_id = p.id
JOIN warehouses w ON p.warehouse_id = w.id
GROUP BY w.id;
    
   

