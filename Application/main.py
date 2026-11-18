from getpass import getpass
from base_donnees import connecter, charger_comptes

ROLES = ("admin", "utilisateur")

def pseudo_existe(conn, pseudo):
    cur = conn.cursor()
    cur.execute("SELECT 1 FROM UTILISATEUR WHERE pseudo = %s", (pseudo,))
    existe = cur.fetchone() is not None
    cur.close()
    return existe

def se_connecter(conn, comptes):
    while True:
        identifiant = input("Identifiant (Entrée pour quitter) : ").strip()
        if not identifiant:
            return None
        mot_de_passe = getpass("Mot de passe : ")
        compte = comptes.get(identifiant)

        if not compte or compte["mot_de_passe"] != mot_de_passe:
            print("Identifiant ou mot de passe incorrect.")
            continue
        if compte["role"] not in ROLES:
            print("Rôle du compte invalide dans config.ini.")
            continue
        if compte["role"] == "utilisateur" and not pseudo_existe(conn, compte["pseudo"]):
            print("Le pseudo associé à ce compte n'existe pas dans la base.")
            continue

        print(f"Connexion en tant que : {identifiant} ({compte['role']}) !")
        return {"identifiant": identifiant, **compte}

def voir_projets(conn):
    cur = conn.cursor()
    cur.execute("""SELECT p.id_projet, p.titre, p.objectif_financier, v.montant_collecte FROM PROJET p JOIN V_MONTANT_COLLECTE v ON v.id_projet = p.id_projet ORDER BY p.id_projet""")
    lignes = cur.fetchall()
    cur.close()
    print("\nId | Titre | Objectif | Collecté")
    for id_projet, titre, objectif, collecte in lignes:
        print(f"{id_projet} | {titre} | {objectif} € | {collecte} €")

def contribuer(conn, pseudo):
    voir_projets(conn)
    id_projet = int(input("Id du projet : "))
    montant = float(input("Montant (€) : "))
    contrepartie = input("Id de la contrepartie (Entrée pour aucune) : ").strip()
    id_contrepartie = int(contrepartie) if contrepartie else None
    cur = conn.cursor()
    cur.execute("""INSERT INTO CONTRIBUTION (pseudo, id_projet, date_heure, montant, id_contrepartie) VALUES (%s, %s, NOW(), %s, %s)""", (pseudo, id_projet, montant, id_contrepartie))
    conn.commit()
    cur.close()
    print("Contribution enregistrée.")

def menu_utilisateur(conn, compte):
    while True:
        print(f"\n===== CrowdFundr - {compte['pseudo']} =====")
        print("1. Voir les projets")
        print("2. Voir les contreparties")
        print("3. Contribuer à un projet")
        print("4. Déposer un avis")
        print("0. Quitter")
        choix = input("Choix : ").strip()

        if choix == "0":
            return
        elif choix == "1":
            voir_projets(conn)
        elif choix == "3":
            contribuer(conn, compte["pseudo"])
        elif choix in ("2", "4"):
            print("A RAJOUTER")
        else:
            print("Invalide")

def supprimer_projet(conn):
    voir_projets(conn)
    id_projet = int(input("Id du projet à supprimer : "))
    cur = conn.cursor()
    cur.execute("DELETE FROM PROJET WHERE id_projet = %s", (id_projet,))
    conn.commit()
    cur.close()
    print("Projet supprimé.")

def ajouter_membre(conn):
    nom = input("Nom : ")
    prenom = input("Prénom : ")
    pays = input("Pays de résidence : ")
    date_naissance = input("Date de naissance (AAAA-MM-JJ) : ")
    cur = conn.cursor()
    cur.execute("INSERT INTO MEMBRE_EQUIPE (nom, prenom, pays_residence, date_naissance) VALUES (%s, %s, %s, %s)", (nom, prenom, pays, date_naissance))
    conn.commit()
    cur.close()
    print("Membre ajouté.")

def menu_admin(conn):
    while True:
        print("\n===== CrowdFundr - Administration =====")
        print("1. Gérer les projets")
        print("2. Gérer les membres d'équipe")
        print("3. Gérer les partenaires")
        print("4. Gérer les contreparties")
        print("5. Exécuter les requêtes voulues")
        print("0. Quitter")
        choix = input("Choix : ").strip()

        if choix == "0":
            return
        elif choix == "1":
            supprimer_projet(conn)
        elif choix == "2":
            ajouter_membre(conn)
        elif choix in ("3", "4", "5"):
            print("A RAJOUTER")
        else:
            print("Invalide")

def main():
    print("===== CrowdFundr =====")
    comptes = charger_comptes()
    conn = connecter()
    try:
        compte = se_connecter(conn, comptes)
        if compte:
            if compte["role"] == "admin":
                menu_admin(conn)
            else:
                menu_utilisateur(conn, compte)
            print("Deconnexion")
    finally:
        conn.close()

if __name__ == "__main__":
    main()
