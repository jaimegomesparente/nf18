# Notes de clarification (NDC)

**Auteurs :** Alexandre JEFFERY, Hugo GOSSE, Rafael REIS, Jaime GOMES-PARENTE

### Organisation prévue de l'application Python

Nous prévoyons de développer une application Python avec une interface en console et deux accès distincts : un accès administrateur et un accès utilisateur classique. L'utilisateur classique pourra consulter les projets, afficher leurs informations et leurs contreparties, enregistrer une contribution et déposer un avis en son nom. L'administrateur disposera d'un menu de gestion permettant d'ajouter, de modifier ou de supprimer les données relatives aux projets, aux membres d'équipe, aux partenaires et aux contreparties, dans le respect des contraintes de la base. Il pourra également exécuter les requêtes demandées dans l'énoncé et en afficher les résultats. Les fonctions de gestion seront réservées à l'administrateur ; un utilisateur classique ne pourra pas y accéder.

Le programme sera réparti en plusieurs modules : `main.py` pour le lancement de l'application, les menus et la saisie des informations ; `projets.py` pour la consultation des projets, de leurs équipes, de leurs partenaires et de leurs contreparties ; `contributions.py` pour l'enregistrement des contributions ; `avis.py` pour le dépôt des avis ; et `requetes.py` pour les requêtes des besoins. Un module `base_donnees.py` centralisera la connexion à la base, l'exécution des requêtes SQL paramétrées et la gestion des transactions. Les paramètres de connexion seront séparés du code et les identifiants de connexion ne seront pas enregistrés dans les fichiers partagés du projet.

Une authentification sera prévue à l'ouverture de l'application afin d'identifier le compte connecté et de déterminer son niveau d'accès. Le choix d'un menu ou la seule saisie d'un pseudo ne suffira donc pas à obtenir les droits administrateur. Les autorisations seront vérifiées avant chaque opération réservée, et les contributions et avis seront rattachés au compte utilisateur connecté. Les informations d'authentification et le rôle du compte devront être précisés lors de l'implémentation et pris en compte dans le modèle de données s'ils sont stockés dans la base ; les mots de passe ne seront pas conservés en clair. L'application contrôlera les saisies et les règles de gestion avant l'enregistrement : montant strictement positif, contrepartie appartenant au projet choisi, note comprise entre 1 et 5, contribution préalable et absence d'avis existant pour le même utilisateur et le même projet. Les contraintes définies dans la base compléteront ces vérifications afin de préserver la cohérence des données. Une opération ne sera confirmée qu'après validation de la transaction ; en cas d'erreur, elle sera annulée et un message sera affiché. Le montant collecté sera calculé à partir des contributions lors de la consultation du projet.

Cette organisation constitue une proposition pour le développement à venir ; l'application Python n'est pas encore réalisée.

### 1. Clarifications conceptuelles et prises de décision concernant les règles de gestion

Le projet s'articule autour de plusieurs entités principales : les projets, les membres d'équipe, les utilisateurs, ainsi que des partenaires externes (ONG, incubateurs, transporteurs).

- Distinction des soutiens : le terme « soutien » de l'énoncé recouvre deux notions que nous ne fusionnons pas.
  - Le soutien financier représente uniquement les contributions financières apportées par les utilisateurs sur les différents projets de CrowdFundr.
  - Le soutien moral / institutionnel désigne l'appui officiel des ONG à des projets à caractère social.
- Incubateurs : les incubateurs sont des structures d'accompagnement indépendantes possédant leur propre budget. Un projet est accompagné par 0 ou 1 incubateur, et un incubateur peut accompagner 0, 1 ou plusieurs projets. Un incubateur n'est pas un contributeur financier.
- Transporteurs partenaires : l'énoncé précise que chaque contrepartie physique est expédiée par un unique transporteur partenaire. Nous l'interprétons comme une association de cardinalité 1 côté transporteur : une contrepartie physique a exactement un transporteur, et un transporteur peut expédier 0, 1 ou plusieurs contreparties physiques. La requête 3 cite Chronopost, ce qui suppose que plusieurs transporteurs coexistent dans la base.
- Projets et contreparties : une contrepartie est définie par un projet et rattachée à lui. Une contribution financière sur un projet ne peut donc sélectionner qu'une contrepartie proposée par ce même projet.
- Contributions : un utilisateur peut contribuer plusieurs fois au même projet. Deux contributions du même utilisateur sur le même projet sont distinguées par leur date et heure.
- Avis : un utilisateur ne peut évaluer un projet (note de 1 à 5, avis textuel, date de l'avis) que s'il y a contribué financièrement au moins une fois. Il n'y a qu'un seul avis par utilisateur et par projet.
- Rôle au sein d'un projet : un membre d'équipe occupe un unique rôle sur un projet donné, parmi : chef de projet, développeur, designer, community manager.
- Attribut dérivé : le montant collecté d'un projet (/montant_collecte) est calculé comme la somme des montants de ses contributions financières. Il n'est pas stocké. Un projet dépasse son objectif lorsque /montant_collecte > objectif_financier.
- Partitions : un projet est exactement l'un des trois types suivants : technologique, artistique ou social (exclusion mutuelle et complétude). Une contrepartie est exactement l'une des deux suivantes : numérique ou physique (exclusion mutuelle et complétude).
- Choix de clés :
  - Utilisateur : le pseudo, unique d'après l'énoncé, est retenu comme clé naturelle. L'adresse mail est également unique.
  - Transporteur : le nom est retenu comme clé, avec l'hypothèse que deux transporteurs partenaires n'ont pas le même nom.
  - ONG : le numéro d'enregistrement est la clé, comme le précise l'énoncé.
- Identification dans les requêtes des besoins : les membres d'équipe (Hideo Kojima, Yoji Shinkawa) sont retrouvés par leur nom et leur prénom, l'ONG (Amnesty International) par son nom, et le transporteur (Chronopost) par son nom.


### 2. Classe / Entités et Associations

| Classe / Entité | Attributs | Contraintes / Associations |
| :--- | :--- | :--- |
| Projet (abstraite) | - titre<br>- description<br>- objectif_financier (€)<br>- date_lancement<br>- /montant_collecte (€) {dérivé : somme des contributions} | - Héritage par partition (exclusion mutuelle et complétude) vers Projet technologique, Projet artistique et Projet social.<br>- Accompagné par 0 ou 1 Incubateur.<br>- Porté par 1 ou plusieurs Membres d'équipe (via classe-association Participation).<br>- Propose 0, 1 ou plusieurs Contreparties.<br>- Reçoit 0, 1 ou plusieurs Contributions financières.<br>- Reçoit 0, 1 ou plusieurs Avis. |
| Projet technologique | - type_innovation | - Héritage de Projet. |
| Projet artistique | - medium_principal | - Héritage de Projet. |
| Projet social | - region_cible | - Héritage de Projet.<br>- Soutenu officiellement par 0, 1 ou plusieurs ONG. |
| Incubateur | - nom<br>- annee_creation<br>- budget_accompagnement | - Accompagne 0, 1 ou plusieurs Projets. |
| ONG | - numero_enregistrement {clé}<br>- nom<br>- pays_origine | - Soutient 0, 1 ou plusieurs Projets sociaux. |
| Membre d'équipe | - nom<br>- prenom<br>- pays_residence<br>- date_naissance | - Participe à 0, 1 ou plusieurs Projets via la classe-association Participation. |
| Utilisateur | - pseudo {clé}<br>- email {unique}<br>- nom<br>- date_naissance | - Effectue 0, 1 ou plusieurs Contributions financières.<br>- Dépose 0, 1 ou plusieurs Avis (sous condition de contribution préalable). |
| Contribution financière | - date_heure (DATETIME)<br>- montant (€) | - Réalisée par 1 Utilisateur sur 1 Projet.<br>- Plusieurs contributions possibles du même utilisateur sur le même projet (distinguées par date_heure).<br>- Liée à 0 ou 1 Contrepartie (qui doit appartenir au projet concerné).<br>- Contrainte : montant > 0. |
| Contrepartie (abstraite) | - libelle | - Proposée par exactement 1 Projet (Projet 1 — 0..* Contrepartie).<br>- Héritage par partition (exclusion mutuelle et complétude) vers Contrepartie numérique et Contrepartie physique.<br>- Peut être choisie dans 0, 1 ou plusieurs Contributions financières. |
| Contrepartie numérique | - format_fichier<br>- taille_mo | - Héritage de Contrepartie. |
| Contrepartie physique | - poids_estime<br>- frais_livraison | - Héritage de Contrepartie.<br>- Expédiée par exactement 1 Transporteur partenaire. |
| Transporteur | - nom {clé}<br>- delai_livraison_moyen (jours) | - Expédie 0, 1 ou plusieurs Contreparties physiques. |


### 3. Classes-association / Relations speciales

| Association / Classe-association | Entités reliées | Attributs et Règles de gestion |
| :--- | :--- | :--- |
| Participation | Membre d'équipe (0..\*) et Projet (1..\*) | - Attribut : role (énumération : chefDeProjet, developpeur, designer, communityManager).<br>- Contrainte : un membre a un rôle unique sur un projet donné (unicité du couple membre / projet).<br>- Un projet a au moins un membre. |
| Avis | Utilisateur (0..\*) et Projet (0..\*) | - Attributs : note (entier de 1 à 5), avis_textuel, date_avis.<br>- Contraintes :<br>&nbsp;&nbsp;1. Au plus un avis par utilisateur et par projet (unicité du couple utilisateur / projet).<br>&nbsp;&nbsp;2. note comprise entre 1 et 5. |
