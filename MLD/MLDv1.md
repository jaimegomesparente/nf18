# Modèle logique de données (MLD)

**Auteurs :** Alexandre JEFFERY, Hugo GOSSE, Rafael REIS, Jaime GOMES-PARENTE

### 1. Relations

**Notation :** `#` précède chaque attribut appartenant à la clé primaire. Lorsqu'une relation comporte plusieurs attributs marqués `#`, ils forment ensemble une seule clé primaire composée ; ils ne sont pas uniques individuellement. `=> TABLE(attribut)` indique une clé étrangère vers l'attribut de la table référencée. `UNIQUE` indique une unicité supplémentaire et `NULL autorisé` une association facultative. `attribut : TYPE` indique le domaine de chaque attribut ; une clé étrangère a le même type que la clé qu'elle référence.

**Types utilisés :** `INT` (entier), `DECIMAL(p,s)` (nombre décimal à `p` chiffres dont `s` après la virgule), `VARCHAR(n)` (chaîne d'au plus `n` caractères), `TEXT` (texte long), `DATE`, `TIMESTAMP` (date et heure, équivalent PostgreSQL du `DATETIME` de l'UML).

```text
INCUBATEUR(
  #id_incubateur : INT,
  nom : VARCHAR(100),
  annee_creation : INT,
  budget_accompagnement : DECIMAL(12,2)
)

PROJET(
  #id_projet : INT,
  titre : VARCHAR(150),
  description : TEXT,
  objectif_financier : DECIMAL(12,2),
  date_lancement : DATE,
  id_incubateur : INT => INCUBATEUR(id_incubateur) {NULL autorisé}
)

PROJET_TECHNOLOGIQUE(
  #id_projet : INT => PROJET(id_projet),
  type_innovation : VARCHAR(100)
)

PROJET_ARTISTIQUE(
  #id_projet : INT => PROJET(id_projet),
  medium_principal : VARCHAR(100)
)

PROJET_SOCIAL(
  #id_projet : INT => PROJET(id_projet),
  region_cible : VARCHAR(100)
)

ONG(
  #numero_enregistrement : VARCHAR(30),
  nom : VARCHAR(100),
  pays_origine : VARCHAR(60)
)

SOUTIEN(
  #id_projet : INT => PROJET_SOCIAL(id_projet),
  #numero_enregistrement : VARCHAR(30) => ONG(numero_enregistrement)
)

MEMBRE_EQUIPE(
  #id_membre : INT,
  nom : VARCHAR(60),
  prenom : VARCHAR(60),
  pays_residence : VARCHAR(60),
  date_naissance : DATE
)

PARTICIPATION(
  #id_projet : INT => PROJET(id_projet),
  #id_membre : INT => MEMBRE_EQUIPE(id_membre),
  role : VARCHAR(20)
)

UTILISATEUR(
  #pseudo : VARCHAR(30),
  email : VARCHAR(255),
  nom : VARCHAR(60),
  date_naissance : DATE
)
  UNIQUE : email

TRANSPORTEUR(
  #nom : VARCHAR(60),
  delai_livraison_moyen : INT
)

CONTREPARTIE(
  #id_contrepartie : INT,
  libelle : VARCHAR(100)
)

CONTREPARTIE_NUMERIQUE(
  #id_contrepartie : INT => CONTREPARTIE(id_contrepartie),
  format_fichier : VARCHAR(20),
  taille_mo : DECIMAL(10,2)
)

CONTREPARTIE_PHYSIQUE(
  #id_contrepartie : INT => CONTREPARTIE(id_contrepartie),
  poids_estime : DECIMAL(8,2),
  frais_livraison : DECIMAL(8,2),
  nom_transporteur : VARCHAR(60) => TRANSPORTEUR(nom)
)

CONTRIBUTION(
  #pseudo : VARCHAR(30) => UTILISATEUR(pseudo),
  #id_projet : INT => PROJET(id_projet),
  #date_heure : TIMESTAMP,
  montant : DECIMAL(12,2),
  id_contrepartie : INT => CONTREPARTIE(id_contrepartie) {NULL autorisé}
)

AVIS(
  #pseudo : VARCHAR(30) => UTILISATEUR(pseudo),
  #id_projet : INT => PROJET(id_projet),
  note : INT,
  avis_textuel : TEXT,
  date_avis : DATE
)
```

Les associations plusieurs-à-plusieurs deviennent les relations SOUTIEN, PARTICIPATION et AVIS. Les associations un-à-plusieurs sont traduites par une clé étrangère du côté « * ». La classe-association Participation conserve son attribut `role`, et la classe-association Avis conserve ses trois attributs.

L'attribut dérivé `/montant_collecte` ne figure pas dans la relation PROJET : sa valeur est calculée à partir des contributions.

2. Contraintes

#### 2.1. Clés, références et domaines

- Clés primaires : chaque clé primaire est unique et non nulle. La clé de PARTICIPATION impose un seul rôle par couple membre / projet. Celle d'AVIS impose un seul avis par couple utilisateur / projet.
- Contributions : la clé composée permet plusieurs contributions du même utilisateur au même projet à des dates et heures différentes. Elle exclut deux contributions ayant exactement le même triplet `(pseudo, id_projet, date_heure)`, selon l'hypothèse retenue dans la NDC.
- Utilisateurs : l'adresse mail est unique et obligatoire dans cette version.
- Références : chaque clé étrangère renseignée doit correspondre à une ligne existante dans la relation référencée. Les clés étrangères sont obligatoires, sauf `PROJET.id_incubateur` et `CONTRIBUTION.id_contrepartie`, qui peuvent être nulles.
- Montant : le montant d'une contribution est obligatoire et strictement supérieur à 0.
- Note : la note d'un avis est obligatoire, entière et comprise entre 1 et 5.
- Rôle : le rôle d'une participation est obligatoire et appartient à l'ensemble `{chefDeProjet, developpeur, designer, communityManager}`.
- Types : le type de chaque attribut est indiqué dans la relation (section 1). Les identifiants ajoutés sont de type INT. Une clé étrangère possède le même type que la clé référencée.

#### 2.2. Associations et règles de gestion

- Accompagnement : un projet possède au plus un incubateur. Un incubateur peut accompagner plusieurs projets ou n'en accompagner aucun.
- Équipe : chaque projet doit posséder au moins une ligne dans PARTICIPATION. Un membre peut participer à plusieurs projets ou à aucun. Le rôle dépend du couple membre / projet ; il n'est donc pas placé dans MEMBRE_EQUIPE.
- Soutien institutionnel : une ONG peut soutenir plusieurs projets sociaux, et un projet social peut être soutenu par plusieurs ONG. La référence de SOUTIEN vers PROJET_SOCIAL exclut les projets technologiques et artistiques de cette association.
- Contreparties : depuis la correction du MCD, une contrepartie n'est plus reliée directement à un projet. Le lien passe par les contributions qui la choisissent. Chaque contrepartie physique possède exactement un transporteur partenaire ; un transporteur peut expédier plusieurs contreparties physiques ou aucune.
- Contributions : chaque contribution concerne exactement un utilisateur et un projet. Elle peut inclure au plus une contrepartie. Une même contrepartie peut être choisie dans plusieurs contributions.
- Avis : pour chaque ligne d'AVIS, il doit exister au moins une ligne de CONTRIBUTION ayant le même pseudo et le même projet. Cette contribution doit déjà exister au moment du dépôt de l'avis. L'utilisateur peut avoir contribué sans avoir choisi de contrepartie.
- Montant collecté : pour chaque projet, le montant collecté est la somme des montants de ses contributions. Il vaut 0 en l'absence de contribution. Un projet dépasse son objectif lorsque cette somme est strictement supérieure à son objectif financier.

Certaines contraintes portent sur plusieurs lignes ou plusieurs tables (au moins un membre par projet, contribution avant un avis, partitions d'héritage). Les clés et les contraintes de domaine ne suffisent pas pour les garantir, on les écrit donc en algèbre relationnelle dans la partie 2.3. Elles doivent rester vraies après chaque insertion, modification ou suppression, au plus tard à la validation de la transaction.

#### 2.3. Contraintes en algèbre relationnelle

On utilise les opérateurs vus en cours : PROJECTION, RESTRICTION, JOINTURE, UNION, INTERSECTION et DIFFERENCE. ∅ désigne une relation vide.

Héritage de Projet : un projet est d'au moins un type (complétude)

```text
PROJECTION(PROJET, id_projet) = PROJECTION(PROJET_TECHNOLOGIQUE, id_projet)
                                UNION PROJECTION(PROJET_ARTISTIQUE, id_projet)
                                UNION PROJECTION(PROJET_SOCIAL, id_projet)
```

et il ne peut pas être de deux types en même temps (exclusion mutuelle)

```text
INTERSECTION(PROJECTION(PROJET_TECHNOLOGIQUE, id_projet), PROJECTION(PROJET_ARTISTIQUE, id_projet)) = ∅
INTERSECTION(PROJECTION(PROJET_TECHNOLOGIQUE, id_projet), PROJECTION(PROJET_SOCIAL, id_projet)) = ∅
INTERSECTION(PROJECTION(PROJET_ARTISTIQUE, id_projet), PROJECTION(PROJET_SOCIAL, id_projet)) = ∅
```

Héritage de Contrepartie : même principe avec les deux types

```text
PROJECTION(CONTREPARTIE, id_contrepartie) = PROJECTION(CONTREPARTIE_NUMERIQUE, id_contrepartie)
                                            UNION PROJECTION(CONTREPARTIE_PHYSIQUE, id_contrepartie)

INTERSECTION(PROJECTION(CONTREPARTIE_NUMERIQUE, id_contrepartie), PROJECTION(CONTREPARTIE_PHYSIQUE, id_contrepartie)) = ∅
```

Chaque projet a au moins un membre d'équipe. L'inclusion dans l'autre sens est déjà assurée par la clé étrangère de PARTICIPATION.

```text
PROJECTION(PROJET, id_projet) = PROJECTION(PARTICIPATION, id_projet)
```

Un utilisateur ne peut laisser un avis que s'il a déjà contribué au projet, au plus tard le jour de l'avis.

```text
R1 = JOINTURE(AVIS, CONTRIBUTION, AVIS.pseudo = CONTRIBUTION.pseudo AND AVIS.id_projet = CONTRIBUTION.id_projet)
R2 = RESTRICTION(R1, DATE(CONTRIBUTION.date_heure) <= AVIS.date_avis)

PROJECTION(AVIS, pseudo, id_projet) ⊆ PROJECTION(R2, AVIS.pseudo, AVIS.id_projet)
```

Le montant collecté n'est pas stocké, on le calcule à partir des contributions (somme des montants par projet, 0 si le projet n'a reçu aucune contribution). Un projet a dépassé son objectif si ce montant est strictement supérieur à objectif_financier. Ce calcul sera fait avec une vue dans le SQL.

Les comptes de connexion et les droits administrateur / utilisateur seront gérés par l'application Python dans un fichier de configuration local, conformément à l'organisation prévue. Ils n'ajoutent donc pas de relation au présent MLD. Le pseudo associé à chaque compte utilisateur devra correspondre à un utilisateur existant dans la base.

### 3. Héritage

#### 3.1. Choix de traduction

Nous avons choisi de conserver une table pour la classe mère et une table pour chaque classe fille. Les informations communes sont enregistrées dans la table mère, tandis que les informations propres à chaque type sont placées dans la table fille correspondante. Les deux tables sont reliées par le même identifiant, qui sert de clé primaire dans chacune d'elles et de clé étrangère dans la table fille.

Pour les projets, la table PROJET contient notamment le titre, la description et l'objectif financier. Les tables PROJET_TECHNOLOGIQUE, PROJET_ARTISTIQUE et PROJET_SOCIAL contiennent les informations propres à chaque type. Ce choix permet de rattacher les contributions, les avis et les membres d'équipe à une même table PROJET, quel que soit le type du projet. Le soutien des ONG est, lui, rattaché à PROJET_SOCIAL afin de respecter la règle selon laquelle seules les initiatives sociales peuvent en bénéficier.

Nous appliquons le même principe aux contreparties. La table CONTREPARTIE contient les informations communes. Les tables CONTREPARTIE_NUMERIQUE et CONTREPARTIE_PHYSIQUE contiennent respectivement les informations sur le fichier et celles sur la livraison. Les contributions peuvent ainsi faire référence à une même table CONTREPARTIE, qu'il s'agisse d'une contrepartie numérique ou physique.

Cette solution évite de répéter les informations communes dans les tables de chaque type. Elle évite aussi de regrouper dans une seule table des attributs qui ne concernent pas tous les types, comme les frais de livraison pour une contrepartie numérique. En contrepartie, il faut effectuer une jointure entre la table mère et la table fille pour obtenir toutes les informations d'un projet ou d'une contrepartie. Il faut également vérifier que chaque projet et chaque contrepartie appartiennent à un seul type, comme le précise la NDC.

#### 3.2. Contraintes de partition

Notre NDC précise une exclusion mutuelle et une complétude pour les deux héritages.

- Projets : chaque identifiant présent dans PROJET doit apparaître dans exactement une des relations PROJET_TECHNOLOGIQUE, PROJET_ARTISTIQUE ou PROJET_SOCIAL. Il ne peut être absent des trois relations ni présent dans plusieurs d'entre elles.
- Contreparties : chaque identifiant présent dans CONTREPARTIE doit apparaître dans exactement une des relations CONTREPARTIE_NUMERIQUE ou CONTREPARTIE_PHYSIQUE. Il ne peut être absent des deux relations ni présent dans les deux.

Les clés étrangères des relations filles garantissent l'existence de la ligne mère. Elles ne garantissent pas, à elles seules, l'exclusion mutuelle ni la complétude : ces deux propriétés restent des contraintes explicites du MLD.

Les classes mères sont abstraites dans l'UML. Leurs relations existent donc pour stocker les attributs communs, mais aucune ligne de PROJET ou de CONTREPARTIE ne peut représenter un objet sans type associé à l'issue d'une transaction.