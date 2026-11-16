-- augmentation de l'objectif
UPDATE PROJET
SET objectif_financier = 8000.00
WHERE titre = 'Symphonie des Étoiles';

UPDATE PROJET
SET id_incubateur = (SELECT id_incubateur FROM INCUBATEUR WHERE nom = 'Compiègne Tech Hub')
WHERE titre = 'Écoles Numériques Rurales';

-- le ON UPDATE CASCADE met à jour CONTREPARTIE_PHYSIQUE
UPDATE TRANSPORTEUR
SET nom = 'Colissimo'
WHERE nom = 'La Poste - Colissimo';

-- +10% sur les frais chronopost
UPDATE CONTREPARTIE_PHYSIQUE
SET frais_livraison = frais_livraison * 1.10
WHERE nom_transporteur = 'Chronopost';

UPDATE PARTICIPATION
SET role = 'chefDeProjet'
WHERE id_membre = (SELECT id_membre FROM MEMBRE_EQUIPE WHERE nom = 'Dupont' AND prenom = 'Alice')
  AND id_projet = (SELECT id_projet FROM PROJET WHERE titre = 'Capteur EcoSens IoT');

UPDATE UTILISATEUR
SET email = 'marc.dupond@nouveau-mail.fr'
WHERE pseudo = 'mdupond';

UPDATE AVIS
SET note = 3,
    avis_textuel = 'Le projet a donné des nouvelles depuis, c''est mieux.',
    date_avis = CURRENT_DATE
WHERE pseudo = 'jgomes'
  AND id_projet = (SELECT id_projet FROM PROJET WHERE titre = 'Accès Eau Potable pour Tous');
