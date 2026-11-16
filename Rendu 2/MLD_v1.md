# Modèle logique de données (MLD)

**Auteurs :** Alexandre JEFFERY, Hugo GOSSE, Rafael REIS, Jaime GOMES-PARENTE

### 1. Relations

**Notation :** `#` précède chaque attribut appartenant à la clé primaire. Lorsqu'une relation comporte plusieurs attributs marqués `#`, ils forment ensemble une seule clé primaire composée ; ils ne sont pas uniques individuellement. `=> TABLE(attribut)` indique une clé étrangère vers l'attribut de la table référencée. `UNIQUE` indique une unicité supplémentaire et `NULL autorisé` une association facultative.

```text
INCUBATEUR(
  #id_incubateur,
  nom,
  annee_creation,
  budget_accompagnement
)

PROJET(
  #id_projet,
  titre,
  description,
  objectif_financier,
  date_lancement,
  id_incubateur => INCUBATEUR(id_incubateur) {NULL autorisé}
)

PROJET_TECHNOLOGIQUE(
  #id_projet => PROJET(id_projet),
  type_innovation
)

PROJET_ARTISTIQUE(
  #id_projet => PROJET(id_projet),
  medium_principal
)

PROJET_SOCIAL(
  #id_projet => PROJET(id_projet),
  region_cible
)

ONG(
  #numero_enregistrement,
  nom,
  pays_origine
)

SOUTIEN(
  #id_projet => PROJET_SOCIAL(id_projet),
  #numero_enregistrement => ONG(numero_enregistrement)
)

MEMBRE_EQUIPE(
  #id_membre,
  nom,
  prenom,
  pays_residence,
  date_naissance
)

PARTICIPATION(
  #id_projet => PROJET(id_projet),
  #id_membre => MEMBRE_EQUIPE(id_membre),
  role
)

UTILISATEUR(
  #pseudo,
  email,
  nom,
  date_naissance
)
  UNIQUE : email

TRANSPORTEUR(
  #nom,
  delai_livraison_moyen
)

CONTREPARTIE(
  #id_contrepartie,
  libelle,
  id_projet => PROJET(id_projet)
)

CONTREPARTIE_NUMERIQUE(
  #id_contrepartie => CONTREPARTIE(id_contrepartie),
  format_fichier,
  taille_mo
)

CONTREPARTIE_PHYSIQUE(
  #id_contrepartie => CONTREPARTIE(id_contrepartie),
  poids_estime,
  frais_livraison,
  nom_transporteur => TRANSPORTEUR(nom)
)

CONTRIBUTION(
  #pseudo => UTILISATEUR(pseudo),
  #id_projet => PROJET(id_projet),
  #date_heure,
  montant,
  id_contrepartie => CONTREPARTIE(id_contrepartie) {NULL autorisé}
)

AVIS(
  #pseudo => UTILISATEUR(pseudo),
  #id_projet => PROJET(id_projet),
  note,
  avis_textuel,
  date_avis
)
```

Les associations plusieurs-à-plusieurs deviennent les relations SOUTIEN, PARTICIPATION et AVIS. Les associations un-à-plusieurs sont traduites par une clé étrangère du côté « * ». La classe-association Participation conserve son attribut `role`, et la classe-association Avis conserve ses trois attributs.

L'attribut dérivé `/montant_collecte` ne figure pas dans la relation PROJET : sa valeur est calculée à partir des contributions.

### 2. Contraintes

#### 2.1. Clés, références et domaines

- Clés primaires : chaque clé primaire est unique et non nulle. La clé de PARTICIPATION impose un seul rôle par couple membre / projet. Celle d'AVIS impose un seul avis par couple utilisateur / projet.
- Contributions : la clé composée permet plusieurs contributions du même utilisateur au même projet à des dates et heures différentes. Elle exclut deux contributions ayant exactement le même triplet `(pseudo, id_projet, date_heure)`, selon l'hypothèse retenue dans la NDC.
- Utilisateurs : l'adresse mail est unique et obligatoire dans cette version.
- Références : chaque clé étrangère renseignée doit correspondre à une ligne existante dans la relation référencée. Les clés étrangères sont obligatoires, sauf `PROJET.id_incubateur` et `CONTRIBUTION.id_contrepartie`, qui peuvent être nulles.
- Montant : le montant d'une contribution est obligatoire et strictement supérieur à 0.
- Note : la note d'un avis est obligatoire, entière et comprise entre 1 et 5.
- Rôle : le rôle d'une participation est obligatoire et appartient à l'ensemble `{chefDeProjet, developpeur, designer, communityManager}`.
- Types : les dates utilisent le domaine DATE, la date et heure d'une contribution le domaine DATETIME, les montants le domaine DECIMAL et les attributs entiers le domaine INT. Les attributs textuels conservent les domaines VARCHAR ou TEXT indiqués dans l'UML. Les identifiants ajoutés sont de type INT. Une clé étrangère possède le même domaine que la clé référencée.

#### 2.2. Associations et règles de gestion

- Accompagnement : un projet possède au plus un incubateur. Un incubateur peut accompagner plusieurs projets ou n'en accompagner aucun.
- Équipe : chaque projet doit posséder au moins une ligne dans PARTICIPATION. Un membre peut participer à plusieurs projets ou à aucun. Le rôle dépend du couple membre / projet ; il n'est donc pas placé dans MEMBRE_EQUIPE.
- Soutien institutionnel : une ONG peut soutenir plusieurs projets sociaux, et un projet social peut être soutenu par plusieurs ONG. La référence de SOUTIEN vers PROJET_SOCIAL exclut les projets technologiques et artistiques de cette association.
- Contreparties : chaque contrepartie appartient à un unique projet. Un projet peut proposer plusieurs contreparties ou aucune. Chaque contrepartie physique possède exactement un transporteur partenaire ; un transporteur peut expédier plusieurs contreparties physiques ou aucune.
- Contributions : chaque contribution concerne exactement un utilisateur et un projet. Elle peut inclure au plus une contrepartie. Une même contrepartie peut être choisie dans plusieurs contributions.
- Cohérence de la contrepartie : si une contribution sélectionne une contrepartie, le projet de cette contrepartie doit être celui de la contribution. Formellement, pour toute contribution `c` dont `id_contrepartie` est renseigné, la contrepartie `r` référencée doit vérifier `c.id_projet = r.id_projet`. Les clés étrangères simples ne suffisent pas à imposer cette égalité ; elle constitue une contrainte supplémentaire.
- Avis : pour chaque ligne d'AVIS, il doit exister au moins une ligne de CONTRIBUTION ayant le même pseudo et le même projet. Cette contribution doit déjà exister au moment du dépôt de l'avis. L'utilisateur peut avoir contribué sans avoir choisi de contrepartie.
- Montant collecté : pour chaque projet, le montant collecté est la somme des montants de ses contributions. Il vaut 0 en l'absence de contribution. Un projet dépasse son objectif lorsque cette somme est strictement supérieure à son objectif financier.

Les contraintes portant sur plusieurs lignes ou plusieurs relations (présence d'au moins un membre, contribution préalable à un avis, cohérence de la contrepartie et partitions d'héritage) doivent être vérifiées en complément des clés et des contraintes de domaine. Leur réalisation sera précisée lors du développement du modèle physique. Elles doivent rester respectées après les insertions, modifications et suppressions, au plus tard à la validation de la transaction.

Les comptes de connexion et les droits administrateur / utilisateur seront gérés par l'application Python dans un fichier de configuration local. Ils n'ajoutent donc pas de relation au présent MLD. Le pseudo associé à chaque compte utilisateur devra correspondre à un utilisateur existant dans la base.

### 3. Héritage

#### 3.1. Choix de traduction

Nous avons choisi une traduction par référence, avec une relation pour la classe mère et une relation pour chaque classe fille. La clé primaire d'une relation fille est également une clé étrangère vers la relation mère. Une occurrence d'une classe fille est donc décrite par une ligne dans la relation mère et une ligne dans la relation fille correspondante.

Pour les projets, les attributs communs sont placés dans PROJET. Les attributs propres aux types sont placés dans PROJET_TECHNOLOGIQUE, PROJET_ARTISTIQUE et PROJET_SOCIAL. Cette organisation permet aux contributions, aux participations, aux avis et aux contreparties de référencer un projet indépendamment de son type. Elle permet aussi au soutien des ONG de référencer uniquement les projets sociaux.

Pour les contreparties, les attributs communs et le rattachement au projet sont placés dans CONTREPARTIE. Les informations de fichier sont placées dans CONTREPARTIE_NUMERIQUE, et les informations de livraison ainsi que la référence au transporteur dans CONTREPARTIE_PHYSIQUE. Une contribution peut ainsi référencer une contrepartie indépendamment de son type.

Nous retenons ce choix pour conserver les attributs communs dans une seule relation et séparer les attributs propres à chaque type. Une traduction par une relation unique imposerait des attributs non applicables à certains types, comme le transporteur pour une contrepartie numérique. Une traduction avec uniquement les relations filles répéterait les attributs communs et compliquerait les références vers l'ensemble des projets ou des contreparties. La traduction retenue nécessite en revanche des jointures pour retrouver toutes les informations d'un objet et des contraintes supplémentaires pour garantir les partitions.

#### 3.2. Contraintes de partition

La NDC précise une exclusion mutuelle et une complétude pour les deux héritages.

- Projets : chaque identifiant présent dans PROJET doit apparaître dans exactement une des relations PROJET_TECHNOLOGIQUE, PROJET_ARTISTIQUE ou PROJET_SOCIAL. Il ne peut être absent des trois relations ni présent dans plusieurs d'entre elles.
- Contreparties : chaque identifiant présent dans CONTREPARTIE doit apparaître dans exactement une des relations CONTREPARTIE_NUMERIQUE ou CONTREPARTIE_PHYSIQUE. Il ne peut être absent des deux relations ni présent dans les deux.

Les clés étrangères des relations filles garantissent l'existence de la ligne mère. Elles ne garantissent pas, à elles seules, l'exclusion mutuelle ni la complétude : ces deux propriétés restent des contraintes explicites du MLD.

Les classes mères sont abstraites dans l'UML. Leurs relations existent donc pour stocker les attributs communs, mais aucune ligne de PROJET ou de CONTREPARTIE ne peut représenter un objet sans type associé à l'issue d'une transaction.
