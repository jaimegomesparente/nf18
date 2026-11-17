import configparser
import os
import psycopg2

config = configparser.ConfigParser(interpolation=None)
config.read(os.path.join(os.path.dirname(__file__), "config.ini"), encoding="utf-8")

def connecter():
    p = config["postgresql"]
    return psycopg2.connect(host=p["host"], port=p["port"], dbname=p["dbname"], user=p["user"], password=p["password"])

def charger_comptes():
    comptes = {}
    for section in config.sections():
        if section.startswith("compte:"):
            identifiant = section.removeprefix("compte:")
            comptes[identifiant] = {
                "mot_de_passe": config[section]["mot_de_passe"],
                "role": config[section]["role"],
                "pseudo": config[section].get("pseudo", ""),
            }
    return comptes