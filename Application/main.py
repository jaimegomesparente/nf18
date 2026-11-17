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
        elif choix in ("1", "2", "3", "4"):
            print("A RAJOUTER")
        else:
            print("Invalide")

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
        elif choix in ("1", "2", "3", "4", "5"):
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