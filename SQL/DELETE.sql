-- 1. Suppressions simples

DELETE FROM AVIS
WHERE pseudo = 'rreis' AND id_projet = 1;

DELETE FROM TRANSPORTEUR
WHERE nom = 'DHL Express';

-- 2. Suppressions avec sous-requête

DELETE FROM PARTICIPATION
WHERE id_membre = (SELECT id_membre FROM MEMBRE_EQUIPE
                   WHERE nom = 'Shinkawa' AND prenom = 'Yoji')
  AND id_projet = (SELECT id_projet FROM PROJET
                   WHERE titre = 'Death Stranding - Artbook & OST');

DELETE FROM MEMBRE_EQUIPE m
WHERE NOT EXISTS (SELECT 1 FROM PARTICIPATION p
                  WHERE p.id_membre = m.id_membre);


-- 3. Suppressions avec effets sur d'autres tables

-- CASCADE : supprime ses soutiens
DELETE FROM ONG
WHERE nom = 'WWF';

-- SET NULL : le projet QuantumSim Engine n'a plus d'incubateur
DELETE FROM INCUBATEUR
WHERE nom = 'EuraTechnologies';

-- Suppression dans la table mère pour respecter la partition
DELETE FROM CONTREPARTIE
WHERE libelle = 'Documentation PDF & Schémas 3D';

-- CASCADE : supprime ses contributions et son avis
DELETE FROM UTILISATEUR
WHERE pseudo = 'hgosse';

-- CASCADE : supprime PROJET_ARTISTIQUE et les participations
DELETE FROM PROJET
WHERE titre = 'Symphonie des Étoiles';


-- 4. Suppressions complexes

-- Contributions totales inférieures à 50 euros
DELETE FROM AVIS a
WHERE (SELECT SUM(c.montant) FROM CONTRIBUTION c
       WHERE c.pseudo = a.pseudo AND c.id_projet = a.id_projet) <= 50;

DELETE FROM CONTRIBUTION c
WHERE (c.pseudo, c.id_projet) IN (SELECT pseudo, id_projet
                                  FROM CONTRIBUTION
                                  GROUP BY pseudo, id_projet
                                  HAVING SUM(montant) <= 50);

-- Utilisateurs sans contribution ni avis
DELETE FROM UTILISATEUR u
WHERE NOT EXISTS (SELECT 1 FROM CONTRIBUTION c WHERE c.pseudo = u.pseudo)
  AND NOT EXISTS (SELECT 1 FROM AVIS a WHERE a.pseudo = u.pseudo);

-- Contreparties Chronopost jamais choisies, puis Chronopost s'il n'expédie plus rien
DELETE FROM CONTREPARTIE ct
WHERE ct.id_contrepartie IN (SELECT id_contrepartie FROM CONTREPARTIE_PHYSIQUE
                             WHERE nom_transporteur = 'Chronopost')
  AND NOT EXISTS (SELECT 1 FROM CONTRIBUTION c
                  WHERE c.id_contrepartie = ct.id_contrepartie);

DELETE FROM TRANSPORTEUR t
WHERE t.nom = 'Chronopost'
  AND NOT EXISTS (SELECT 1 FROM CONTREPARTIE_PHYSIQUE cp
                  WHERE cp.nom_transporteur = t.nom);