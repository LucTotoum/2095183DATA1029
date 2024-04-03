USE library;
SET autocommit=1;
START TRANSACTION;-- pour demarer une transaction, ilmsuffit de lancer la commmande suivante:
INSERT INTO `stores`(`stor_name`, `stor_address`,`city`, `state`,`zip`)VALUES-- Insertiooon de nouvelle boutiques
('Centre d\'études acadiennes Anselme-Chiasson', 'Pavillion Clément-cormier, 405 Université Ave','Moncton', 
'Nouveau Brunswick', 'NBE1A3E9'),
('Bibliothèque champlain','415 Av. de l\'Université', 'Moncton', 'Nouveau Brunswick', 'NBE1A3E9');
START TRANSACTION; -- Ouverture d'une transaction
INSERT INTO sales(stor_id, ord_num, title_id, qty) -- Ajoutons ventes effectues au centre d\'études acadiennes Anselme-Chiasson
VALUES(4,1,1,2),(4,1,3,3);
ROLLBACK;-- pour annuler less requêtes de la transaction, ce qui termine celle-ci
INSERT INTO sales(stor_id, ord_num, title_id, qty) -- Ajoutons ventes effectues au centre d\'études acadiennes Anselme-Chiasson
VALUES(4,1,2,10),(4,1,3,5);
START TRANSACTION; -- Ouverture d'une transaction
DELETE FROM sales WHERE stor_id = 4; -- suppression des ventes effectuees a la Bibliothèque champlain
COMMIT; -- on valide les requêtes de la transaction, ce qui termine celle-ci.
select * from stores;


-- Créer un nouveau compte pharma avec pour mot de passe 1234.
CREATE USER "pharma"@"localhost" IDENTIFIED BY "1234";
-- accordons des privilèges pour qu'il puisse interagir avec la base de données
GRANT ALL PRIVILEGES ON epharmacy.* TO "pharma"@"localhost";
-- pour que les modifications prennent effet
FLUSH PRIVILEGES;