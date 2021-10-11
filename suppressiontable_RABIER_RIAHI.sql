--Suppression des tables
DROP TABLE Citerne;
DROP TABLE Camion;
DROP TABLE Modele;
DROP TABLE Fabricant;
DROP TABLE Protege;
DROP TABLE Pompier;
ALTER TABLE Adresse DROP CONSTRAINT adresse_proche_caserne_fkey; /*suppression de la clé étrangère 'Proche_caserne' qui empêche la suppression de la table caserne*/
DROP TABLE Caserne;
DROP TABLE Adresse;
DROP TABLE Ville;
--Suppression du type
DROP TYPE habitation;

--Suppression du schéma
DROP SCHEMA projet_caserne;
