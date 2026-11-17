-- REQUETE 1
-- Quelle est la moyenne des notes des projets sociaux qui sont soutenus par l'ONG
-- nommée Amnesty International, en ne prenant en compte que les utilisateurs ayant
-- apporté une contribution supérieure à 50 euros sur ces projets ? 

-- REQUETE 2
--Pour chaque projet accompagné par un incubateur, combien d'utilisateurs distincts ont
-- réclamé au moins une contrepartie physique expédiée via le transporteur "Chronopost"
-- lors de leurs contributions ?


--REQUETE 3 
-- Composition d'une equipe
SELECT me.prenom, me.nom, me.pays_residence, part.role
FROM participation part
JOIN membre_equipe me ON part.id_membre = me.id_membre
WHERE part.id_projet = 1; -- Projet artistique (Hideo Kojima & Yoji Shinkawa)

--requete 4
--Liste des contreparties
SELECT 
    ct.id_contrepartie,
    ct.libelle,
    cn.format_fichier,
    cn.taille_mo,
    cp.poids_estime,
    cp.frais_livraison,
    t.nom AS transporteur,
    t.delai_livraison_moyen
FROM contrepartie ct
LEFT JOIN contrepartie_numerique cn ON ct.id_contrepartie = cn.id_contrepartie
LEFT JOIN contrepartie_physique cp ON ct.id_contrepartie = cp.id_contrepartie
LEFT JOIN transporteur t ON cp.nom_transporteur = t.nom
WHERE ct.id_projet = 2; -- Symphonie des Étoiles; contrepartie : Artbook collector relié cuir

--Requete 4
--Liste des contributions d'un membre 
SELECT 
    p.titre AS projet,
    c.date_heure,
    c.montant,
    COALESCE(ct.libelle, 'Contribution sans contrepartie') AS contrepartie_choisie
FROM contribution c
JOIN projet p ON c.id_projet = p.id_projet
LEFT JOIN contrepartie ct ON c.id_contrepartie = ct.id_contrepartie
WHERE c.pseudo = 'rreis' -- contributions dans les projets 1, 3 et 5
ORDER BY c.date_heure DESC;


--Requete 5
--Verification de la possibilité de donné  un avis sur projet ou pas : renvoi un boolean : oui: si l'utilisateur a deja contribué au moins une fois au projet et n'a pas encore donné d'avis
--exemple ou il enverai oui 
SELECT 
    EXISTS (
        SELECT 1 FROM contribution 
        WHERE pseudo = 'ajeffery' AND id_projet = 1
    ) 
    AND NOT EXISTS (
        SELECT 1 FROM avis 
        WHERE pseudo = 'ajeffery' AND id_projet = 1
    ) AS peut_noter;

--Requete 5 bis
--devrai envoyer non car avis déjà donné
SELECT 
    EXISTS (
        SELECT 1 FROM contribution 
        WHERE pseudo = 'rreis' AND id_projet = 1
    ) 
    AND NOT EXISTS (
        SELECT 1 FROM avis 
        WHERE pseudo = 'rreis' AND id_projet = 1
    ) AS peut_noter;


--requete 6
--cherche les informations necessaires qu'on a besoin après que le but de financement soit atteint : 
-- à qui envoyer le colis,
-- quoi envoyer; 
--comment l'evoyer

    SELECT 
    u.pseudo,
    u.nom AS nom_contributeur,
    u.email,
    ct.libelle AS contrepartie_physique,
    cp.poids_estime,
    cp.nom_transporteur,
    t.delai_livraison_moyen
FROM contribution c
JOIN utilisateur u ON c.pseudo = u.pseudo
JOIN contrepartie ct ON c.id_contrepartie = ct.id_contrepartie
JOIN contrepartie_physique cp ON ct.id_contrepartie = cp.id_contrepartie
JOIN transporteur t ON cp.nom_transporteur = t.nom
WHERE c.id_projet = 1 -- 
ORDER BY cp.nom_transporteur;



--Requete 7 
--cherche les prinpales statistiques de la plateforme (nb de projets, argent collecté, nb de contributeurs, nb de ong partenaires)
SELECT 
    COUNT(DISTINCT p.id_projet) AS total_projets_lances,
    COALESCE(SUM(c.montant), 0) AS montant_total_collecte,
    COUNT(DISTINCT c.pseudo) AS total_contributeurs_uniques,
    COUNT(DISTINCT o.numero_enregistrement) AS total_ong_partenaires
FROM projet p
LEFT JOIN contribution c ON p.id_projet = c.id_projet
LEFT JOIN soutien s ON p.id_projet = s.id_projet
LEFT JOIN ong o ON s.numero_enregistrement = o.numero_enregistrement; 


--Requete 8
--Possibilité d'avoir une barre de recherche pour chercher les infos d'un projet. à partir du titre ou de la description
SELECT 
    id_projet,
    titre,
    description,
    objectif_financier,
    date_lancement
FROM projet
WHERE titre ILIKE '%eau%' -- si on cherche seulement "eau" on va trouver le projet 3 
   OR description ILIKE '%eau%'-- car le titre contient ce mot (Accès Eau Potable pour Tous)
ORDER BY date_lancement DESC;

--Requete 9
--Donne le profil de l'utilisateur, ses avis, projets, notes
SELECT 
    p.titre AS projet_concerne,
    a.note,
    a.avis_textuel,
    a.date_avis
FROM avis a
JOIN projet p ON a.id_projet = p.id_projet
WHERE a.pseudo = 'rreis'
ORDER BY a.date_avis DESC;