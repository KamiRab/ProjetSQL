-- Q1: Casernes protégeant Brignoles et Le Luc et leur ville
SELECT Cas.id_caserne, Cas.nom_ville, Cas.cp
    FROM caserne Cas, protege Pr
    WHERE Cas.id_caserne = Pr. id_caserne
      AND Pr.nom_ville = 'Brignoles'
INTERSECT
SELECT Cas.id_caserne, Cas.nom_ville, Cas.cp
    FROM caserne Cas, protege Pr
    WHERE Cas.id_caserne = Pr. id_caserne
      AND Pr.nom_ville = 'Le Luc';

--Q2 : Id, noms et prénoms des pompiers de la caserne 3 habitant à plus de 5km d'une caserne
SELECT Po.id_pompier, Po.nom, Po.prenom
    FROM pompier Po, adresse A
    WHERE A.nom_rue = Po.nom_rue AND A.num_rue = Po.num_rue
      AND A.nom_ville = Po.nom_ville AND A.cp = Po.cp
      AND Po.id_caserne = 3 AND A.km > 5;

--Q3 id, noms et prénoms des pompiers habitant Le Luc ou des villes >= 20 000 habitants
SELECT  Po.id_pompier, Po.nom, Po.prenom
    FROM pompier Po
    WHERE Po.nom_ville = 'Le Luc'
UNION
SELECT  Po.id_pompier, Po.nom, Po.prenom
    FROM pompier Po, ville V
    WHERE Po.nom_ville = V.nom_ville AND Po.cp = V.cp
      AND V.nb_hab >= 20000;

--Q4 Délai moyen de livraison des fabriquants de citernes de moins de 1000 litres
/*ici on utilise une sous requete pour ne pas tenir compte dans le calcul de la
  moyenne, des doublons de fabricants (certains fabricants fabriquent plusieurs
  modeles de citernes et pour plusieurs casernes, donc certaines lignes sont dedoublées)*/
SELECT AVG(F.delai) AS "Delai moyen"
    FROM fabricant F
    WHERE F.nom_fabricant in
          (SELECT F.nom_fabricant
            FROM fabricant F, modele M,  Camion Cam, citerne Ci
            WHERE F.nom_fabricant = M.nom_fabricant AND M.nom_modele = Cam.modele
              AND Cam.id_caserne = Ci.id_caserne AND Cam.id_camion = Ci.id_camion
              AND Ci.contenance < 1000);



--Q5 Temps moyen de livraison des camions par caserne en ordre décroissant
SELECT Cam.id_caserne, AVG(F.delai) AS "Temps moyen de livraison"
    FROM fabricant F, modele M, camion Cam
    WHERE F.nom_fabricant = M.nom_fabricant
      AND M.nom_modele = Cam.modele
    GROUP BY Cam.id_caserne
    ORDER BY avg(F.delai) DESC;

--Q6 Nombre de pompiers par caserne
SELECT Po.id_caserne ,COUNT(Po.id_pompier) AS "Nombre de pompiers"
    FROM pompier Po
    GROUP BY Po.id_caserne ;
--Q7 Id et ville des casernes avec citerne avec le plus de contenance
SELECT Cas.id_caserne, Cas.nom_ville, Cas.cp
    FROM caserne Cas, citerne Ci
    WHERE Cas.id_caserne = Ci.id_caserne
      AND ci.contenance = (SELECT MAX(contenance)
                              FROM citerne Ci);
--Q8 Casernes ayant atteint leur capacité maximale humaine
SELECT Po.id_caserne
    FROM caserne Cas, pompier Po
    WHERE Po.id_caserne = Cas.id_caserne
    GROUP BY Po.id_caserne, Cas.capa_pompiers
    HAVING Cas.capa_pompiers = count(distinct (Po.id_caserne,Po.id_pompier));
--Q9 Id, nom, prenom ne travaillant pas dans la ville où ils habitent
/*On prend l'ensemble des pompiers et on enlève ceux qui travaillent où ils habitent*/
SELECT Po.id_caserne, Po.id_pompier, Po.nom, Po.prenom,
       Po.nom_ville AS "Ville d'habitation", Po.cp AS "CP d'habitation",
       Cas.nom_ville AS "Ville de caserne",Cas.cp AS "CP de caserne"
    FROM caserne Cas, pompier Po
    WHERE Po.id_caserne = Cas.id_caserne
EXCEPT
SELECT  Po.id_caserne, Po.id_pompier, Po.nom, Po.prenom,
        Po.nom_ville, Po.cp,
        Cas.nom_ville,Cas.cp
    FROM caserne Cas, pompier Po
    WHERE Po.id_caserne = Cas.id_caserne
      AND Po.nom_ville = Cas.nom_ville AND Po.cp=Cas.cp;

--Q10 Liste décroissante des casernes en fonction du nombre de pompiers y travaillant
SELECT Po.id_caserne ,count(Po.id_pompier) AS "Nombre de pompiers"
    FROM pompier Po
    GROUP BY Po.id_caserne
    ORDER BY count(Po.id_pompier) DESC ;

--Q11 Première caserne de la liste précédente
SELECT Cas.id_caserne ,COUNT(Po.id_pompier) AS "Nombre de pompiers"
    FROM caserne cas, pompier Po
    WHERE Po.id_caserne= Cas.id_caserne
    GROUP BY Cas.id_caserne
    ORDER BY COUNT(Po.id_pompier) DESC
    LIMIT 1;

--Q12 Volume d' eau total des citernes pour chaque caserne
SELECT Cas.id_caserne, SUM(Ci.contenance) AS "Volume en eau total"
    FROM caserne Cas, citerne Ci
    WHERE Cas.id_caserne = Ci.id_caserne
    GROUP BY Cas.id_caserne;

--Q13 Caserne sans citerne
/*On prend l'ensemble des casernes et on enlève les casernes avec citerne*/
SELECT Cas.id_caserne
    FROM caserne Cas
EXCEPT
SELECT Cas.id_caserne
    FROM caserne Cas, citerne Ci
    WHERE Cas.id_caserne= Ci.id_caserne;

--Q14 Villes  protégées par au moins deux casernes
/*On utilise un produit cartésien (Pr1 X Pr2)pour trouver deux villes différentes
  protégeant une meme ville*/
SELECT DISTINCT Pr1.nom_ville, Pr1.cp
    FROM protege Pr1, protege Pr2
    WHERE Pr1.nom_ville = Pr2.nom_ville AND Pr1.cp = Pr2.cp
      AND Pr1.id_caserne != Pr2.id_caserne;

SELECT distinct Pr.nom_ville, Pr.cp
    FROM protege Pr
    GROUP BY Pr.nom_ville, Pr.cp
    HAVING count(distinct Pr.id_caserne) >1;

--Q15 Nb d'habitants moyen dans les villes protégées par des casernes de plus de deux camions
/*ici on utilise une sous requete pour ne pas tenir compte dans le calcul de la
  moyenne, des doublons de villes (certaines villes sont protegees par plusieurs casernes)*/
SELECT avg(V.nb_hab)
FROM Ville V
WHERE (V.nom_ville,V.cp) in (SELECT V.nom_ville,V.cp
    FROM ville V, protege Pr, camion Cam
    WHERE V.nom_ville = Pr.nom_ville AND V.cp=Pr.cp
      AND Pr.id_caserne = Cam.id_caserne
    GROUP BY pr.id_caserne, V.cp, V.nom_ville
    HAVING count(DISTINCT(Cam.id_caserne,Cam.id_camion)) > 2);
SELECT AVG(Nb_hab)AS "Moyenne des habitants"
FROM Ville, Camion, Protege
WHERE Protege.id_caserne = camion.id_caserne
AND Protege.Nom_ville = Ville.Nom_ville
AND Protege.CP = Ville.CP
HAVING COUNT(Camion.id_camion) > 2;

SELECT avg(V.nb_hab)
FROM Ville V
WHERE V. in (SELECT V.nom_ville,V.cp
    FROM ville V, protege Pr, camion Cam
    WHERE V.nom_ville = Pr.nom_ville AND V.cp=Pr.cp
      AND Pr.id_caserne = Cam.id_caserne
    GROUP BY pr.id_caserne, V.cp, V.nom_ville
    HAVING count(DISTINCT(Cam.id_caserne,Cam.id_camion)) > 2);

SELECT *
    FROM ville V, protege Pr, camion Cam1, camion Cam2
    WHERE (V.nom_ville,V.cp) = (Pr.nom_ville,Pr.cp)
      AND Pr.id_caserne = Cam1.id_caserne AND Pr.id_caserne = Cam2.id_caserne
      AND Cam1.id_camion != Cam2.id_camion;

SELECT Pr.id_caserne,V.nom_ville, V.cp, V.nb_hab
    FROM ville V, protege Pr, camion Cam
    WHERE V.nom_ville = Pr.nom_ville AND V.cp=Pr.cp
      AND Pr.id_caserne = Cam.id_caserne
    GROUP BY pr.id_caserne, V.cp, V.nom_ville
    HAVING count(distinct (Cam.id_caserne,Cam.id_camion)) >= 2;

SELECT AVG(Nb_hab) AS "moyenne des habitants"
FROM Ville, Caserne, Camion, Protege
WHERE Protege.id_caserne = Caserne.id_caserne
AND Protege.Nom_ville = Ville.Nom_ville
AND Protege.CP = Ville.CP
AND Caserne.id_caserne = Camion.id_caserne
HAVING COUNT (distinct (Ville.nom_ville,Ville.CP,Camion.id_caserne,Camion.id_camion))> 2;


SELECT distinct Ville.*
FROM ville JOIN protege ON ville.nom_ville = protege.nom_ville
WHERE ville.nom_ville IN (
SELECT protege.nom_ville
FROM protege JOIN caserne ON protege.id_caserne = caserne.id_caserne
WHERE caserne.capa_camions >= 2);
