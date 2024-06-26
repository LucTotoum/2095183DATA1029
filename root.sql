USE epharmacy;
SELECT user FROM mysql.user;
DROP USER 'pharma'@'localhost';
-- ------------------------------------------------------------------------------
-- Partie Analyse
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

-- -----------------------------------------------------------------------------------------------------------------------------------
-- Partie Evolution du schema
-- 8. Modifier la table products de sorte à affecter l’image “medoc.jpg” comme image par défaut aux produits médicaux.
ALTER TABLE products
CHANGE COLUMN image image VARCHAR(255) DEFAULT 'medoc.jpg';

SET SQL_SAFE_UPDATES = 0; -- désactiver temporairement le contrôle de sécurité en MySQL
-- mise a jour
UPDATE products 
SET image = 'medoc.jpg' 
WHERE image IS NULL OR image = '';
SET SQL_SAFE_UPDATES = 1; -- remise a jour et fin de la desactivation.
-- ------------------------------------------------------------------------------------------------------------------------------------------
-- 9. Ajouter une colonne gender spécifiant le sexe des utilisateurs de l’application. Cette colonne doit être une énumération contenant pour valeur MALE, FEMALE et OTHER
ALTER TABLE users
ADD COLUMN gender ENUM('MALE', 'FEMALE', 'OTHER') DEFAULT 'OTHER';
-- ----------------------------------------------------------------------------------------------------------------------------------------
-- 10.Ecrire une procédure stockée spProfileImage permettant d'affecter une 
-- image de profil par défaut aux utilisateurs : 15pts
-- a. Les utilisateurs MALE auront pour image male.jpg
-- b. Les utilisateurs FEMALE auront pour image femage.jpg
-- c. Les autres auront utilisateur auront pour image other.jpg
DELIMITER $
CREATE PROCEDURE spProfileImage()
BEGIN
    -- Mettre à jour l'image pour les utilisateurs masculins sans image spécifiée
    UPDATE users
    SET image = 'male.jpg'
    WHERE gender = 'MALE' AND (image IS NULL OR image = '');

    -- Mettre à jour l'image pour les utilisateurs féminins sans image spécifiée
    UPDATE users
    SET image = 'female.jpg'
    WHERE gender = 'FEMALE' AND (image IS NULL OR image = '');

    -- Mettre à jour l'image pour les autres utilisateurs sans image spécifiée
    UPDATE users
    SET image = 'other.jpg'
    WHERE (gender = 'OTHER' OR gender IS NULL OR gender = '') AND (image IS NULL OR image = '');
END$
DELIMITER ;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- 11.Ajouter une contrainte a la table users afin de garantir l’unicité des adresses 
-- électroniques(email) des utilisateurs de l’application.
ALTER TABLE users
ADD CONSTRAINT email_unique UNIQUE (email);
-- --------------------------------------------------------------------------------------------------------------------------------------------
-- Insertion de données. (25pts)
-- 12.Effectuez sous forme de transactions toutes les insertions nécessaires pour passer les ventes représentées par la capture suivante : 

-- a. Insérer un nouvel utilisateur au nom de Alain Foka avec un mot de passe correspondant à la chaine vide. 5pts
-- Commencer la transaction
START TRANSACTION;
-- Insérons un nouvel utilisateur Alain Foka avec un mot de passe vide
INSERT INTO users (firstname, lastname, email, password, role_id, country, actif, image)
VALUES ('Alain', 'Foka', 'alain.foka@example.com', '', (SELECT id FROM roles WHERE name = 'Customer'), 'Unspecified', 1, 'default.jpg');
-- Validation de la transaction si tout s'est bien passé
COMMIT;
-- -----------------------------------------------------------------------------------------------------------------------------------------------
-- b. La date de chaque commande doit être à l’instant auquel la commande est insérée
-- Commencer la transaction
START TRANSACTION;
-- Insérons une nouvelle commande dans la table 'orders'
-- Remplacer 'user_id', 'customer_id', 'status', 'cart_id', et 'total_amount' par les valeurs appropriées
INSERT INTO orders (customer_id, order_date, total_amount, status, user_id, cart_id)
VALUES (1, NOW(), 100.00, 1, 1, 1); -- Exemple de valeurs, ajustez selon les besoins réels
-- Valider la transaction pour appliquer les changements
COMMIT;
-- -------------------------------------------------------------------------------------------------------------------------------------
-- c. Ces commandes sont éditées par l’administrateur Abdoulaye Mohamed
START TRANSACTION;
-- Identifier l'ID de l'administrateur Abdoulaye Mohamed
SET @adminUserId := (SELECT id FROM users WHERE firstname = 'Abdoulaye' AND lastname = 'Mohamed');

-- Identifier l'ID de l'utilisateur Fati Amadou
SET @fatiUserId := (SELECT id FROM users WHERE firstname = 'Fati' AND lastname = 'Amadou');

-- Identifier l'ID de l'utilisateur Alain Foka (après son insertion préalable)
SET @alainId := (SELECT id FROM users WHERE firstname = 'Alain' AND lastname = 'Foka');

-- Pour Fati Amadou
INSERT INTO orders (customer_id, order_date, total_amount, status, user_id)
VALUES (@fatiUserId, NOW(), 0, 1, @adminUserId); -- Statut '1' pourrait signifier 'en traitement'
SET @orderIdFati := LAST_INSERT_ID();

-- Pour chaque produit commandé par Fati Amadou
-- Remplacez les valeurs de product_id par les véritables IDs des produits
INSERT INTO order_details (order_id, product_id, quantity)
VALUES 
(@orderIdFati, (SELECT id FROM products WHERE name = 'Advile'), 4),
(@orderIdFati, (SELECT id FROM products WHERE name = 'Paracetamol2'), 5),
(@orderIdFati, (SELECT id FROM products WHERE name = 'Gravol'), 7);

-- Pour Alain Foka
INSERT INTO orders (customer_id, order_date, total_amount, status, user_id)
VALUES (@alainId, NOW(), 0, 1, @adminUserId);
SET @orderIdAlain := LAST_INSERT_ID();

-- Pour chaque produit commandé par Alain Foka
-- Remplacez les valeurs de product_id par les véritables IDs des produits
INSERT INTO order_details (order_id, product_id, quantity)
VALUES 
(@orderIdAlain, (SELECT id FROM products WHERE name = 'Ibuprofen'), 5),
(@orderIdAlain, (SELECT id FROM products WHERE name = 'Dulcolax'), 3),
(@orderIdAlain, (SELECT id FROM products WHERE name = 'Tilenol'), 4),
(@orderIdAlain, (SELECT id FROM products WHERE name = 'Gravol'), 7);

-- Pour le deuxième ensemble de produits pour Fati Amadou
INSERT INTO order_details (order_id, product_id, quantity)
VALUES 
(@orderIdFati, (SELECT id FROM products WHERE name = 'Multi-Vitamine'), 1),
(@orderIdFati, (SELECT id FROM products WHERE name = 'Bon Koga'), 2),
(@orderIdFati, (SELECT id FROM products WHERE name = 'Gravol'), 10);

COMMIT;
-- ------------------------------------------------------------------------------------------------------------------------------------------------
-- d. Calculez le total de chacune des commandes et insérer convenablement
START TRANSACTION;
-- Définition des variables nécessaires
SET @total := 0;
SET @customerId := 1;  -- en Supposant que nous connaissons déjà l'ID du client
SET @cartId := 1;      -- en Supposant que nous connaissons déjà l'ID du panier
-- Calcule le total de la commande en fonction des produits dans le panier
SELECT SUM(p.price * cp.quantity) INTO @total
FROM cart_product cp
JOIN products p ON cp.product_id = p.id
WHERE cp.cart_id = @cartId;
-- Insére la commande dans la table 'orders' avec le total calculé
INSERT INTO orders (customer_id, order_date, total_amount, status, user_id, cart_id)
VALUES (@customerId, NOW(), @total, 1, 1, @cartId);  -- '1' pour 'status' et 'user_id' comme exemple

COMMIT;
-- -----------------------------------------------------------------------------------------------------------------------------------------

START TRANSACTION;

-- Supposons que nous ayons l'ID du client et l'ID du panier (cart_id)
SET @customerId := 1;  -- Exemple d'ID de client
SET @cartId := 1;      -- Exemple d'ID de panier
SET @userId := 1;      -- Exemple d'ID d'utilisateur (Abdoulaye Mohamed par exemple)

-- Calcule le total de la commande
SET @orderTotal := (
    SELECT SUM(p.price * cp.quantity)
    FROM cart_product cp
    JOIN products p ON cp.product_id = p.id
    WHERE cp.cart_id = @cartId
);

-- Calcule le total des impôts (10% du total de la commande)
SET @taxAmount := @orderTotal * 0.10;

-- Insére la commande dans la table 'orders'
INSERT INTO orders (customer_id, order_date, total_amount, status, user_id, cart_id)
VALUES (@customerId, NOW(), @orderTotal, 1, @userId, @cartId);

-- Obtien l'ID de la commande insérée pour l'utiliser dans la facture
SET @orderId := LAST_INSERT_ID();

-- Insérer la facture dans la table 'invoices'
INSERT INTO invoices (order_id, montant, tax, users_id)
VALUES (@orderId, @orderTotal, @taxAmount, @userId);

COMMIT;
-- -------------------------------------------------------------------------------------------------------------------------
-- Modification de données: (10pts)
-- 13- Modifier les utilisateurs de l’application ainsi qu’il suit
DESCRIBE users;
SET SQL_SAFE_UPDATES = 0; 
UPDATE users 
SET designation = "Comptable", adress = "415 Av. de l’Université",
province = "NB", postal_code = "E1A3E9",phone = "4065954526",email = "Ali@ccnb.ca"
WHERE firstname = "Ali" AND lastname = "Sani";
SET SQL_SAFE_UPDATES = 1;

SET SQL_SAFE_UPDATES = 0;
UPDATE users 
SET designation = 'RH',adress = '1750 Rue Crevier',
province = 'QC',postal_code = 'H4L2X5',phone = '5665954526',email = 'Oumar@gm ail.com'
WHERE firstname = 'Oumar' AND lastname = 'Moussa';
SET SQL_SAFE_UPDATES = 1;

SET SQL_SAFE_UPDATES = 0;
UPDATE users 
SET designation = 'Consultant',adress = '674 Van horne',province = 'NS',
postal_code = 'B4V4V5',phone = '7854665265',email = 'Foka@ccnb.ca'
WHERE firstname = 'Dupont' AND lastname = 'Poupi';
SET SQL_SAFE_UPDATES = 1;




  
   

