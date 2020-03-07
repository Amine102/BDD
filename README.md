# BDD
# Préparation des données 
## Prétraitements sous OpenRefine
> :warning: **On suppose qu'OpenRefine est  déjà installé**
- **Phase de nettoyage des données :**

 1. *Suppression des colonnes inutiles*
   - Cliquez sur la colonne que vous voulez supprimer
   - Choisissez *Edit Column*
   - Choisissez *Remove this column*

![ETAPE1_DELETECOLUMNS](https://user-images.githubusercontent.com/34581620/76152986-38259680-60c6-11ea-8929-78f52f9d183a.jpg)

2. *Renommer les colonnes*
  - Cliquez sur la colonne que vous voulez renommer
  - Choisissez *Edit column*
  - Choisissez *Rename this column*
  - Entrez le nouveau nom dans la fenêtre qui apprarait et validez

![ETAPE2_RENAMECOLUMN](https://user-images.githubusercontent.com/34581620/76153307-7a50d700-60ca-11ea-9f7e-6ffd9e8c2b74.jpg)

- **Phase de transformation**

*Transformation matricielle des colonnes en lignes*


## Prétraitements sous R
 - Ouvrez le logiciel R, importez votre fichier CSV prétraiter par OpenRefine 
 ``` Bash
 (File -> Import Dataset -> From Text (base)...).
 ``` 
 ![Import sous R](https://user-images.githubusercontent.com/43194428/76044371-6e460780-5f5a-11ea-833d-9c5d8d8d6de7.png)
 - Après sélection du fichier, une fenêtre d'options apparaîtra; Cochez YES dans la partie Heading puis cliquez sur Import
 
 ![head](https://user-images.githubusercontent.com/43194428/76151958-9187c880-60ba-11ea-85a2-45e79196fbe5.png)
 - De la même façon, importez le dataset departements-region.csv,
 - Avant de commencer les prétraitements, utiliser une variable d'environnement afin de ne pas modifier le fichier importé (dans notre cas, nous l'appellerons DATA):
 ```R
 DATA <- <Nom_fichier_importé>
 ```
 - La première étape consiste à changer le séparateur de décimals de chaque valeurs figurant dans la colone Salaire. Exécutez le script suivant en console R:
 ```R
  DATA$Salaire <- as.numeric(gsub(",",".",DATA$Salaire))
 ```
 - La seconde étapes consiste à rajouter deux nouvelles colonnes: Régions et departements en utilisant le dataset departements.region importé auparavant. Pour cela, Exécutez les deux scripts en console R:
  ```R
  DATA$Région <- departements.region[as.character(match(substr(DATA$Code.Postal,1,2),departement.region$num_dep)),3]
  DATA$Département <- departements.region[as.character(match(substr(DATA$Code.Postal,1,2),departement.region$num_dep)),2]
 ```
 - Comme remarqué, quelques lignes contiennent la valeur NA. Cela est dû au fait que le code précédent effectue des match sur uniquement les deux premier chiffres de chaques code postal appartenant au dataset DATA. Afin d'initialiser les valeurs NA avec les nouvelles données, tapez en console le script suivant:
 ```R
 levels(DATA$Départements) <- c(levels(DATA$Départements), c("Guadeloupe", "Martinique", "Guyane", "La Réunion", "Mayotte"))
 ```
 - Le code ci-dessus permet de rajouter un niveau de facteurs afin d'initialiser les valeurs NA avec de nouvelles données (les dataFrame en R utilisent les facteurs qui sont des structures de données utiliser pour des valeurs de type catégories)
 - Ensuite, copier/coller le code suivant en console et éxecutez le:
 ```R
 for(i in min(which(is.na(DATA$Départements))):dim(DATA)[1]){
    if(substr(as.character(DATA$Code.Postal[i]),1,3)==971){
      DATA$Départements[i] <- "Guadeloupe"
      DATA$Région[i] <- "Guadeloupe"
    }
    else if(substr(as.character(DATA$Code.Postal[i]),1,3)==972){
      DATA$Départements[i] <- "Martinique"
      DATA$Région[i] <- "Martinique"
      
    }
    else if(substr(as.character(DATA$Code.Postal[i]),1,3)==973){
      DATA$Départements[i] <- "Guyane"
      DATA$Région[i] <- "Guyane"
      
    }
    else if(substr(as.character(DATA$Code.Postal[i]),1,3)==974){
      DATA$Départements[i] <- "La Réunion"
      DATA$Région[i] <- "La Réunion"
    }
    else if(substr(as.character(DATA$Code.Postal[i]),1,3)==976){
      DATA$Départements[i] <- "Mayotte"
      DATA$Région[i] <- "Mayotte"
    }
  }
 ```
 - La troisième étapes consiste à rajouter des codes de départements afin de faciliter le requêtage du future dataset. Executez en console le script suivant:
 ```R
 DATA$CodeDép <- departements.region[match(DATA$Départements,departements.region$dep_name),1]  #Rajout de code de département
 ```
 - Une fois les étapes précédantes achevés, exportez le dataset en fichier CSV grâce à la commande suivante:
 ```R
 write.csv(DATA,"~/<Chemin>/<nom_dataset_ANNEE>.csv")
 ```
 - Refaites les même étapes pour chaque datasets. Une fois les datasets prêt, faites un merge par ligne en éxecutant le script suivant dans la console R:
 ```R
 FINAL_DATA <- rbind(<Nom_DATASET_1>,<Nom_DATASET_2>,<Nom_DATASET_3>, <Nom_DATASET_4>, <Nom_DATASET_5>) #merge des datasets
 ```
 - Enfin, Faite l'exportation en utilisant la même commande evoqué auparavant:
 ```R
  write.csv(FINAL_DATA,"~/<Chemin>/<nom_dataset_ANNEE>.csv")
 ```
 
