# BDD
# Préparation des données 
## Prétraitements sous OpenRefine
## Prétraitements sous R
 - Ouvrez le logiciel R, importez votre fichier CSV prétraiter par OpenRefine (File -> Import Dataset -> From Text (base)... ->  Cochez YES dans la partie Heading puis cliquez sur Import).
 ![Import sous R](https://user-images.githubusercontent.com/43194428/76044371-6e460780-5f5a-11ea-833d-9c5d8d8d6de7.png)
 - De la même façon, importez le dataset departements-region.csv,
 - La première étape consiste à changer le séparateur de décimals de chaque valeurs figurant dans la colone Salaire. Exécutez le script suivant en ligne de commande R:
 ```R
  DATA$Salaire <- as.numeric(gsub(",",".",DATA$Salaire))
 ```
 - La seconde étapes consiste à rajouter deux nouvelles colonnes: Régions et departements en utilisant le dataset departements.region importé auparavant. Pour cela, Exécutez les deux scripts en ligne de commande R:
  ```R
  DATA$Région <- departements.region[as.character(match(substr(DATA$Code.Postal,1,2),departement.region$num_dep)),3]
  DATA$Département <- departements.region[as.character(match(substr(DATA$Code.Postal,1,2),departement.region$num_dep)),2]
 ```
 - Comme remarqué, quelques lignes contiennent la valeur NA. Cela est dû au fait que le code précédent effectue des match sur uniquement les deux premier chiffres de chaques code postal appartenant au dataset DATA. Afin d'initialiser les valeurs NA avec les nouvelles données, tapez en ligne de commande le script suivant:
 ```R
 levels(DATA$Départements) <- c(levels(DATA$Départements), c("Guadeloupe", "Martinique", "Guyane", "La Réunion", "Mayotte"))
 ```
 - Le code ci-dessus permet de rajouter un niveau de facteurs afin d'initialiser les valeurs NA avec de nouvelles données (les dataFrame en R utilisent les facteurs qui sont des structures de données utiliser pour des valeurs de type catégories)
 - Ensuite, copier/coller le code suivant en ligne de commande et éxecutez le:
 ```R
 for(i in min(which(is.na(SALAIRE$Départements))):dim(SALAIRE)[1]){
    if(substr(as.character(SALAIRE$Code.Postal[i]),1,3)==971){
      SALAIRE$Départements[i] <- "Guadeloupe"
      SALAIRE$Région[i] <- "Guadeloupe"
    }
    else if(substr(as.character(SALAIRE$Code.Postal[i]),1,3)==972){
      SALAIRE$Départements[i] <- "Martinique"
      SALAIRE$Région[i] <- "Martinique"
      
    }
    else if(substr(as.character(SALAIRE$Code.Postal[i]),1,3)==973){
      SALAIRE$Départements[i] <- "Guyane"
      SALAIRE$Région[i] <- "Guyane"
      
    }
    else if(substr(as.character(SALAIRE$Code.Postal[i]),1,3)==974){
      SALAIRE$Départements[i] <- "La Réunion"
      SALAIRE$Région[i] <- "La Réunion"
    }
    else if(substr(as.character(SALAIRE$Code.Postal[i]),1,3)==976){
      SALAIRE$Départements[i] <- "Mayotte"
      SALAIRE$Région[i] <- "Mayotte"
    }
  }
 ```
 - La troisième étapes consiste à rajouter des codes de départements afin de faciliter le requêtage du future dataset. Executez en ligne de commande le script suivant:
 ```R
 SALAIRE$CodeDép <- departements.region[match(SALAIRE$Départements,departements.region$dep_name),1]  #Rajout de code de département
 ```
 - Une fois les étapes précédantes achevés, exportez le dataset en fichier CSV grâce à la commande suivante:
 ```R
 write.csv(SALAIRE,"~/<Chemin>/<nom_dataset_ANNEE>.csv")
 ```
 
