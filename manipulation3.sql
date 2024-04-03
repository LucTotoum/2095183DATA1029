USE library;
SET autocommit=0;
INSERT INTO `stores`(`stor_name`, `stor_address`,`city`, `state`,`zip`)VALUES
('Bilio CCNB Dieppe', '594 rue du college','Moncton', 'Nouveau Brunswick', 'E3C2R9'),
('Crayon','233 Main ST', 'Diepppe', 'Nouveau Brunswick', 'E2C 5X7');
COMMIT;
UPDATE authors
SET au_fname="Christiano", au_lname="Ronaldo"
WHERE au_id=4;
SELECT * FROM stores;
SELECT * FROM authors WHERE au_id=4;
ROLLBACK;-- pour annuler less requêtes
SELECT *  FROM stores;
SELECT *FROM authors WHERE au_id=4;
