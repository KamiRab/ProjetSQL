--Insertion dans la table ville
INSERT INTO Ville (Nom_ville, CP, Nb_hab) VALUES('Montrouge', 92120, 50260);
INSERT INTO Ville VALUES('Malakoff', 92240, 30720);
INSERT INTO Ville VALUES('Châtillon', 92320, 37555);
INSERT INTO Ville VALUES('Rueil-Malmaison',92500, 78152);
INSERT INTO Ville VALUES('Boulogne-Billancourt',92100, 120071);

--Insertion dans la table adresse
INSERT INTO Adresse (Num_rue, Nom_rue, CP, Nom_ville, Type_habitation, Proche_caserne, Km) VALUES(53,'Rue de la Vanne',92120,'Montrouge','Caserne',NULL,0);
INSERT INTO Adresse VALUES(102,'Avenue de Pompei', 92100,'Boulogne-Billancourt','Caserne',NULL,0);
INSERT INTO Adresse VALUES(15,'Rue André Coin',92240,'Malakoff','Pavillon',NULL,2);
INSERT INTO Adresse VALUES(2,'Allée Berlioz',92320,'Châtillon','HLM',NULL,3);
INSERT INTO Adresse VALUES(7, 'rue de la voiture', 92500,'Rueil-Malmaison', 'Ferme', NULL, 02);
INSERT INTO Adresse VALUES(13,'quai du camion',92100,'Boulogne-Billancourt','Ferme', NULL, 04);

--Insertion dans la table caserne
INSERT INTO Caserne (Id_caserne, Capa_camion, Capa_pompier, Nom_rue, CP, Nom_ville, Num_rue) VALUES(02,10,50,'Rue de la Vanne',92120,'Montrouge',53);
INSERT INTO Caserne VALUES(45,3,16,'Avenue de Pompei', 92100,'Boulogne-Billancourt',102);

--Mise à jour de la table Adresse pour récupérer les valeurs de 'Proche_caserne' à partir du code postal de l'adresse
UPDATE Adresse SET Proche_caserne = Protege.Id_caserne FROM Protege WHERE Adresse.CP = Protege.CP AND Adresse.Nom_Ville = Protege.Nom_Ville;

--Insertion dans la table protege
INSERT INTO Protege (Id_caserne, Nom_ville,CP) VALUES(02, 'Châtillon', 92320);
INSERT INTO Protege VALUES(02, 'Montrouge', 92120);
INSERT INTO Protege VALUES(45, 'Boulogne-Billancourt', 92100);
INSERT INTO Protege VALUES(02, 'Malakoff', 92240);
INSERT INTO Protege VALUES(02, 'Rueil-Malmaison',92500);

--Insertion dans la table pompier
INSERT INTO Pompier (Id_caserne,Id_pompier, Nom, Prenom, Nom_rue, Num_rue, Nom_ville, CP) VALUES(02, 0215, 'DUPONT', 'Robert','Rue André Coin',15,'Malakoff',92240);
INSERT INTO Pompier VALUES(02, 0218, 'SCHNEIDER', 'Sarah', 'Allée Berlioz', 2,'Châtillon',92320);


--Insertion dans la table fabricant
INSERT INTO Fabricant (Nom_fabricant, Delai, Num_rue, Nom_rue, CP, Nom_ville) VALUES('Renault',15 ,13,'quai du camion',92100,'Boulogne-Billancourt');
INSERT INTO Fabricant VALUES('Citroën',10,7, 'rue de la voiture', 92500,'Rueil-Malmaison');

--Insertion dans la table modele
INSERT INTO Modele (Nom_modele, Type_modele, Motorisation, Nom_fabricant) VALUES('85 150 TI','lourd','150ch','Renault');
INSERT INTO Modele VALUES('Premium210','lourd','210ch','Renault');

--Insertion dans la table camion
INSERT INTO Camion (Id_caserne, Id_camion, Nb_places, Modele) VALUES(02,0258,4,'85 150 TI');
INSERT INTO Camion VALUES(45,4551,2,'Premium210');

--Insertion dans la table citerne
INSERT INTO Citerne (Id_caserne,Id_camion,Contenance) VALUES(02,0258,2000);
INSERT INTO Citerne VALUES(45,4551,3500);

--Insertions non respectueuses de contraintes
INSERT INTO Ville VALUES ('Malakoff', 92240, 33720); /*ne respecte pas clé primaire, car Malakoff est déja présent avec un nombre d‘habitants différent*/
INSERT INTO Citerne VALUES(45,4553,3500); /*ne respecte pas clé étrangère, car il n‘y a pas de camion 4553*/
INSERT INTO Ville VALUES ('Beijing',100000,21542000); /*ne respecte pas contrainte sur le code postal */

