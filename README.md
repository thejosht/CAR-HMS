# CAR-HMS

CAR-HMS est un système de gestion des randonnées du club Cairn. Il permet de gérer les profils des randonneurs, les activités, les inscriptions et les listes d’attente.

Ce dépôt contient le travail du projet pour le cours SEG 3502. Le premier livrable porte sur la structure du domaine, les interfaces des cas d’utilisation, les DTO de requête et les contrats Cucumber. Le code est écrit en Kotlin.

## État du projet

La structure du domaine se trouve dans [`src/main/kotlin/domain`](src/main/kotlin/domain). Chaque sous-domaine a son propre README. Les interfaces des cas d’utilisation, les DTO de requête et les contrats seront ajoutés dans les prochains commits.

## Travail dans le dépôt

La branche `main` contient la version commune du projet. Les changements sont préparés sur des branches séparées, puis vérifiés avant d’être fusionnés.

Pour récupérer le projet :

```sh
git clone https://github.com/thejosht/CAR-HMS.git
cd CAR-HMS
```

Le projet ne contient pas encore de configuration de compilation ni d’application à exécuter.
