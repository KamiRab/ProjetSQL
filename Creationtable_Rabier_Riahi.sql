--Création du schéma et définition comme chemin par défaut
CREATE SCHEMA projet_caserne;
SET SCHEMA 'projet_caserne';

--Création du type habitation
CREATE TYPE habitation AS ENUM  ('Caserne', 'Ferme','HLM', 'Pavillon');

--Création des tables
---#Création de la table ville
CREATE TABLE Ville (
    
    Nom_ville       VARCHAR(20),
    CP              INTEGER CHECK (CP BETWEEN 1000 AND 98890),
    Nb_hab          INTEGER CHECK ( Nb_hab > 0) NOT NULL ,   
    PRIMARY KEY (Nom_ville,CP)
);

---#Création de la table adresse
CREATE TABLE Adresse (
    
    Num_rue         INTEGER  CHECK (Num_rue>0),
    Nom_rue         VARCHAR(20),
    CP              INTEGER ,
    Nom_ville       VARCHAR(20),
    Type_habitation habitation NOT NULL,
    Proche_caserne  INTEGER ,
    Km              INTEGER NOT NULL,
    FOREIGN KEY (Nom_ville,CP ) REFERENCES Ville (Nom_ville,CP),
    PRIMARY KEY( Num_rue , Nom_rue ,CP,Nom_ville)
);  

---#Création de la table caserne      
CREATE TABLE Caserne (

    Id_caserne      INTEGER ,
    Capa_camion     INTEGER  CHECK ( Capa_camion >0) NOT NULL,
    Capa_pompier    INTEGER  CHECK  (Capa_pompier>0) NOT NULL, 
    Nom_rue         VARCHAR(20) NOT NULL ,
    CP              INTEGER NOT NULL,
    Nom_ville       VARCHAR(20) NOT NULL, 
    Num_rue         INTEGER NOT NULL,
    FOREIGN KEY (Num_rue,Nom_rue,CP, Nom_ville ) REFERENCES Adresse (Num_rue,Nom_rue,CP, Nom_ville),   
    PRIMARY KEY (Id_caserne)
);

--- Ajout de la clé étrangère 'Proche_caserne' de la table Adresse référant à Id_caserne de la table Caserne
ALTER TABLE Adresse ADD CONSTRAINT adresse_proche_caserne_fkey FOREIGN KEY (Proche_caserne ) REFERENCES Caserne (Id_caserne );

---#Création de la table protège
CREATE TABLE Protege (
    Id_caserne      INTEGER ,
    Nom_ville       VARCHAR(20),
    CP              INTEGER ,
    FOREIGN KEY (Id_caserne) REFERENCES Caserne (Id_caserne),
    FOREIGN KEY (Nom_ville,CP ) REFERENCES Ville (Nom_ville,CP),
    PRIMARY KEY (Id_caserne,Nom_ville, CP)
);

--#Création de la table pompier            
CREATE TABLE Pompier (

    Id_caserne      INTEGER,
    Id_pompier      INTEGER ,
    Nom             VARCHAR(20) NOT NULL ,
    Prenom          VARCHAR(20) NOT NULL ,
    Nom_rue         VARCHAR(20) NOT NULL ,
    Num_rue         INTEGER NOT NULL,
    Nom_ville       VARCHAR(20) NOT NULL , 
    CP              INTEGER NOT NULL,
    FOREIGN KEY (Num_rue,Nom_rue,CP, Nom_ville ) REFERENCES Adresse (Num_rue,Nom_rue,CP, Nom_ville),
    FOREIGN KEY (Id_caserne) REFERENCES Caserne (Id_caserne ),
    PRIMARY KEY (Id_caserne,Id_pompier)
);

--#Création de la table fabricant
CREATE TABLE Fabricant  (

    Nom_fabricant   VARCHAR(20),
    Delai           INTEGER NOT NULL,     
    Num_rue         INTEGER NOT NULL,
    Nom_rue         VARCHAR(20) NOT NULL,
    CP              INTEGER NOT NULL,
    Nom_ville       VARCHAR(20) NOT NULL, 
    FOREIGN KEY (Num_rue,Nom_rue,CP, Nom_ville ) REFERENCES Adresse (Num_rue,Nom_rue,CP, Nom_ville),
    PRIMARY KEY (Nom_fabricant)
);

---#Création de la table modèle
CREATE TABLE Modele   (
    Nom_modele      VARCHAR(20),
    Type_modele     VARCHAR(20) NOT NULL ,  
    Motorisation    VARCHAR(20) NOT NULL ,
    Nom_fabricant   VARCHAR(20) NOT NULL , 
    FOREIGN KEY (Nom_fabricant) REFERENCES  Fabricant (Nom_fabricant),
    PRIMARY KEY ( Nom_modele ) 
);

---#Création de la table camion
CREATE TABLE Camion     (
    Id_caserne      INTEGER ,
    Id_camion       INTEGER ,
    Nb_places       INTEGER  NOT NULL ,
    Modele          VARCHAR(20) NOT NULL,
    FOREIGN KEY ( Modele) REFERENCES Modele (Nom_modele),
    FOREIGN KEY (Id_caserne ) REFERENCES Caserne (Id_caserne ),
    PRIMARY KEY ( Id_caserne, Id_camion)   
);

---#Création de la table citerne
CREATE TABLE Citerne    (

    Id_caserne      INTEGER ,
    Id_camion       INTEGER ,
    Contenance      INTEGER NOT NULL ,
    FOREIGN KEY (Id_caserne ,Id_camion) REFERENCES Camion (Id_caserne,Id_camion),
    PRIMARY KEY ( Id_caserne, Id_camion)
);
    
