
-- 1. INCUBATEURS
INSERT INTO INCUBATEUR (nom, annee_creation, budget_accompagnement) VALUES
('Station F', 2017, 500000.00),
('Compiègne Tech Hub', 2020, 150000.00),
('EuraTechnologies', 2009, 350000.00);

-- 2. PROJETS (Tables Mère + Filles)
-- Projet 1 : Artistique (Hideo Kojima & Yoji Shinkawa)
INSERT INTO PROJET (titre, description, objectif_financier, date_lancement, id_incubateur) VALUES
('Death Stranding - Artbook & OST', 'Un projet artistique visuel et sonore unique.', 10000.00, '2025-01-15', 1);
INSERT INTO PROJET_ARTISTIQUE (id_projet, medium_principal) VALUES
(1, 'Jeux Vidéo & Musique');

-- Projet 2 : Artistique
INSERT INTO PROJET (titre, description, objectif_financier, date_lancement, id_incubateur) VALUES
('Symphonie des Étoiles', 'Album orchestral inspiré de la science-fiction.', 5000.00, '2025-02-01', NULL);
INSERT INTO PROJET_ARTISTIQUE (id_projet, medium_principal) VALUES
(2, 'Musique');

-- Projet 3 : Social (Soutenu par Amnesty International)
INSERT INTO PROJET (titre, description, objectif_financier, date_lancement, id_incubateur) VALUES
('Accès Eau Potable pour Tous', 'Installation de puits et de filtres écologiques.', 20000.00, '2025-03-01', 2);
INSERT INTO PROJET_SOCIAL (id_projet, region_cible) VALUES
(3, 'Afrique de l''Ouest');

-- Projet 4 : Social
INSERT INTO PROJET (titre, description, objectif_financier, date_lancement, id_incubateur) VALUES
('Écoles Numériques Rurales', 'Équipement en tablettes et ordinateurs pour zones isolées.', 15000.00, '2025-04-10', NULL);
INSERT INTO PROJET_SOCIAL (id_projet, region_cible) VALUES
(4, 'Amérique du Sud');

-- Projet 5 : Technologique (Accompagné par Station F, livraisons Chronopost)
INSERT INTO PROJET (titre, description, objectif_financier, date_lancement, id_incubateur) VALUES
('Capteur EcoSens IoT', 'Capteur environnemental open-source à ultra-basse consommation.', 30000.00, '2025-05-01', 1);
INSERT INTO PROJET_TECHNOLOGIQUE (id_projet, type_innovation) VALUES
(5, 'Internet des Objets (IoT)');

-- Projet 6 : Technologique
INSERT INTO PROJET (titre, description, objectif_financier, date_lancement, id_incubateur) VALUES
('QuantumSim Engine', 'Moteur de simulation quantique accessible aux étudiants.', 50000.00, '2025-06-01', 3);
INSERT INTO PROJET_TECHNOLOGIQUE (id_projet, type_innovation) VALUES
(6, 'Informatique Quantique');

-- 3. ONG ET SOUTIENS

INSERT INTO ONG (numero_enregistrement, nom, pays_origine) VALUES
('ONG-897654', 'Amnesty International', 'Royaume-Uni'),
('ONG-123456', 'Médecins Sans Frontières', 'France'),
('ONG-654321', 'WWF', 'Suisse');

INSERT INTO SOUTIEN (id_projet, numero_enregistrement) VALUES
(3, 'ONG-897654'), -- Projet 3 (Social) soutenu par Amnesty International
(3, 'ONG-123456'),
(4, 'ONG-654321');

-- 4. MEMBRES D'ÉQUIPE ET PARTICIPATIONS
INSERT INTO MEMBRE_EQUIPE (nom, prenom, pays_residence, date_naissance) VALUES
('Kojima', 'Hideo', 'Japon', '1963-08-24'),       -- id_membre = 1
('Shinkawa', 'Yoji', 'Japon', '1971-12-25'),     -- id_membre = 2
('Dupont', 'Alice', 'France', '1995-04-12'),      -- id_membre = 3
('Silva', 'Carlos', 'Brésil', '1990-11-05');      -- id_membre = 4

INSERT INTO PARTICIPATION (id_projet, id_membre, role) VALUES
(1, 1, 'chefDeProjet'),      -- Hideo Kojima sur Projet 1
(1, 2, 'designer'),          -- Yoji Shinkawa sur Projet 1
(2, 3, 'chefDeProjet'),
(3, 4, 'chefDeProjet'),
(4, 4, 'chefDeProjet'),      -- chaque projet doit avoir au moins un membre
(5, 3, 'developpeur'),
(6, 4, 'chefDeProjet');

-- 5. UTILISATEURS
INSERT INTO UTILISATEUR (pseudo, email, nom, date_naissance) VALUES
('rreis', 'rafael.reis@example.com', 'Reis', '2004-05-10'),
('ajeffery', 'alexandre.jeffery@example.com', 'Jeffery', '2003-08-14'),
('hgosse', 'hugo.gosse@example.com', 'Gosse', '2004-02-20'),
('jgomes', 'jaime.gomes@example.com', 'Gomes-Parente', '2003-11-30'),
('mdupond', 'marc.dupond@example.com', 'Dupond', '1998-09-15');

-- 6. TRANSPORTEURS
INSERT INTO TRANSPORTEUR (nom, delai_livraison_moyen) VALUES
('Chronopost', 2),
('DHL Express', 3),
('La Poste - Colissimo', 5);


-- 7. CONTREPARTIES (Tables Mère + Filles)

-- Contrepartie 1 : Numérique (Projet 1)
INSERT INTO CONTREPARTIE (libelle) VALUES ('Bande originale MP3/FLAC');
INSERT INTO CONTREPARTIE_NUMERIQUE (id_contrepartie, format_fichier, taille_mo) VALUES (1, 'FLAC', 650.00);

-- Contrepartie 2 : Physique (Projet 1) via Chronopost
INSERT INTO CONTREPARTIE (libelle) VALUES ('Artbook collector relié cuir');
INSERT INTO CONTREPARTIE_PHYSIQUE (id_contrepartie, poids_estime, frais_livraison, nom_transporteur) VALUES (2, 2.50, 12.00, 'Chronopost');

-- Contrepartie 3 : Physique (Projet 3) via La Poste
INSERT INTO CONTREPARTIE (libelle) VALUES ('Gourde écologique gravée');
INSERT INTO CONTREPARTIE_PHYSIQUE (id_contrepartie, poids_estime, frais_livraison, nom_transporteur) VALUES (3, 0.40, 5.00, 'La Poste - Colissimo');

-- Contrepartie 4 : Physique (Projet 5) via Chronopost
INSERT INTO CONTREPARTIE (libelle) VALUES ('Kit Capteur EcoSens prêt à l''emploi');
INSERT INTO CONTREPARTIE_PHYSIQUE (id_contrepartie, poids_estime, frais_livraison, nom_transporteur) VALUES (4, 0.80, 8.50, 'Chronopost');

-- Contrepartie 5 : Numérique (Projet 5)
INSERT INTO CONTREPARTIE (libelle) VALUES ('Documentation PDF & Schémas 3D');
INSERT INTO CONTREPARTIE_NUMERIQUE (id_contrepartie, format_fichier, taille_mo) VALUES (5, 'PDF', 45.00);

-- 8. CONTRIBUTIONS
-- Contributions sur Projet 1 (Dépasse l'objectif de 10 000 €)
INSERT INTO CONTRIBUTION (pseudo, id_projet, date_heure, montant, id_contrepartie) VALUES
('rreis', 1, '2025-01-20 14:30:00', 8000.00, 2),
('ajeffery', 1, '2025-01-22 10:15:00', 3000.00, 1);

-- Contributions sur Projet 3 (Social - Amnesty International)
INSERT INTO CONTRIBUTION (pseudo, id_projet, date_heure, montant, id_contrepartie) VALUES
('rreis', 3, '2025-03-05 09:00:00', 100.00, 3),   -- > 50€
('hgosse', 3, '2025-03-06 16:45:00', 60.00, NULL),  -- > 50€
('jgomes', 3, '2025-03-07 11:20:00', 30.00, NULL);  -- <= 50€

-- Contributions sur Projet 5 (Technologique + Incubateur Station F + Chronopost)
INSERT INTO CONTRIBUTION (pseudo, id_projet, date_heure, montant, id_contrepartie) VALUES
('rreis', 5, '2025-05-02 18:00:00', 150.00, 4),   -- Réclame contrepartie 4 (Chronopost)
('ajeffery', 5, '2025-05-03 14:10:00', 150.00, 4),-- Réclame contrepartie 4 (Chronopost)
('mdupond', 5, '2025-05-04 11:00:00', 20.00, 5);  -- Réclame contrepartie 5 (Numérique)

-- 9. AVIS (Condition de contribution préalable respectée)
INSERT INTO AVIS (pseudo, id_projet, note, avis_textuel, date_avis) VALUES
('rreis', 1, 5, 'Un chef-d''œuvre visuel et sonore exceptionnel !', '2025-01-25'),
('rreis', 3, 5, 'Projet fantastique et très transparent.', '2025-03-10'),
('hgosse', 3, 4, 'Très belle initiative pour l''accès à l''eau.', '2025-03-12'),
('jgomes', 3, 2, 'Bonne idée mais peu de nouvelles du projet.', '2025-03-15'); -- contribution de 30 €, ne doit pas compter dans la requête 2