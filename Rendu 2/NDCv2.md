# Notes de clarification (NDC)

**Auteurs :** Alexandre JEFFERY, Hugo GOSSE, Rafael REIS, Jaime GOMES-PARENTE

### Clarifications conceptuelles et prises de décision concernant les règles de gestion

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
