# Projet NF18 - CrowdFundr (Groupe G4)

## Contexte 
Ce dépôt GitLab contient notre travail pour le projet de base de données (Dossier 2) réalisé dans le cadre de l'UV NF18.

L'objectif de ce projet est de concevoir, modéliser et implémenter la base de données de CrowdFundr, une plateforme de financement participatif fictive. Le cycle de développement couvre toutes les étapes : de l'analyse des besoins (Note de Clarification, MCD, MLD) jusqu'à la création concrète de la base et son exploitation (SQL, NoSQL, et logique applicative).

## Membres du groupe
Ce projet a été réalisé par :
- Alexandre JEFFERY
- Hugo GOSSE
- Jaime GOMES-PARENTE
- Rafael REIS

## Organisation du dépôt
Le projet est organisé selon l'arborescence suivante afin de séparer les différents types de rendus :

-  `README.md` : Page d'accueil présentant le contexte et l'équipe (ce fichier).
-  `NDC.md` : Note de Clarification détaillant les choix conceptuels et les règles de gestion.
-  `repartition.md` : Document précisant la répartition des tâches entre les membres du groupe.
-  `MCD/` : Modèle Conceptuel de Données (fichiers PlantUML et export PNG).
-  `MLD/` : Modèle Logique de Données.
-  `SQL/` : Scripts de création des tables, d'insertion et requêtes SQL.
-  `Application/` : Fichiers et scripts relatifs au développement de l'application cliente.
-  `NoSQL/` : Modélisation et requêtes pour la partie base de données orientée documents/graphes.

## Note sur l'utilisation de l'IA.
Lors de la réalisation du projet, nous avons utilisé l'IA à plusieurs reprises, pour simplifier les tâches répétitives:
- Ecriture d'insert sql à partir d'un exemple écrit à la main : " A partir de cet exemple d'insert, donne nous en d'autres afin de compléter notre base de données"
- Recherche d'erreurs de syntaxe ou d'orthographe dans nos différents fichiers : " Recherche et liste nous les éventuelles erreurs de syntaxe ou d'orthographe qui pourraient rendre difficile la compréhension, l'utilisation ou le fonctionnement de l'application."
- Aide pour se connecter à la base de données dans le terminal. " J'ai utilisé la commande sql -h tuxa.sme.utc -u nf18a037 -d dbnf18a037 et voilà ce que j'ai obtenu comme message d'erreur C:\Program Files\PostgreSQL\18\bin\psql.exe: illegal option -- u
psql: astuce :  Essayez « psql --help » pour plus d'informations."