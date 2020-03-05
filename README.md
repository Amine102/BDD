# BDD
# Préparation des données 
## Prétraitements sous OpenRefine
## Prétraitements sous R
 - Ouvrez le logiciel R, importez votre fichier CSV prétraiter par OpenRefine (File -> Import Dataset -> From Text (base)... ->  Cochez YES dans la partie Heading puis cliquez sur Import).
 - De la même façon, importez le dataset departements-region.csv,
 - La première étape consiste à changer le séparateur de décimals de chaque valeurs figurant dans la colone Salaire. Exécuter le script suivant en ligne de commande:
 ```R
  DATA$Salaire <- as.numeric(gsub(",",".",DATA$Salaire))
 ```
 
 
