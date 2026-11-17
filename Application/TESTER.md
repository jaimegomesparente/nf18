# Crowdfundr – Comment tester l'application

*Jaime Gomes Parente*

## 1. Prérequis

  pip install psycopg2-binary et se connecter au VPN.

## 2. Configuration

Copier `config.example.ini` et renommer la copie en `config.ini`. Dans `config.ini`, remplacer les 3 variables par vos informations.

## 3. Créer et remplir les tables

psql -h tuxa.sme.utc -U votre_login -d votre_base -f SQL/CREATE.sql
psql -h tuxa.sme.utc -U votre_login -d votre_base -f SQL/INSERT.sql

## 4. Lancer l'application

Depuis le dossier `Application` : python main.py