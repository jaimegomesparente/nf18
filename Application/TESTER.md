# Crowdfundr – Comment tester l'application

*Jaime Gomes Parente*

## 1. Prérequis

- Installer le pilote PostgreSQL :

  ```bash
  pip install psycopg2-binary
  ```

- Se connecter au VPN.

## 2. Configuration

1. Copier `config.example.ini` et renommer la copie en `config.ini`.
2. Dans `config.ini`, remplacer les 3 variables par vos informations.

## 3. Créer et remplir les tables

```bash
psql -h tuxa.sme.utc -U votre_login -d votre_base -f SQL/CREATE.sql
psql -h tuxa.sme.utc -U votre_login -d votre_base -f SQL/INSERT.sql
```

## 4. Lancer l'application

Depuis le dossier `Application` :

```bash
python main.py
```
