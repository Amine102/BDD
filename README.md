# BDD
# Prérequis
- OpenRefine: https://openrefine.org/download.html
- Rstudio: https://rstudio.com/products/rstudio/download/
- XMLStarlet: http://xmlstar.sourceforge.net/download.php
- XSLT 2.0: https://sourceforge.net/projects/saxon/
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

1. *Transformation matricielle des colonnes en lignes*

L'objectif est de transposer les colonnes en lignes. Il va falloir choisir l'ensemble des colonnes à transposer.
   - Cliquer sur la première colonnes que vous souhaitez transposer
   - Choisissez *Transpose*
   - Dans la partie gauche de la fenêtre qui vient de s'ouvrir, choisissez l'ensemble des colonnes à transposer
   - Dans la partie droite, entrez le nom pour la nouvelle colonne qui contiendra les valeurs des anciennes colonnes et le nom pour la nouvelle colonne qui contiendra les valeur des cellules correspondantes (dans le cas de ce dataset, les salaires)

![ETAPE4_TranspoMatricielle](https://user-images.githubusercontent.com/34581620/76153801-b63b6a80-60d1-11ea-9fe0-eba264a958e7.jpg)

2. *Création de la colonne Categorie*

Il faut maintenant créer la colonne *Catégorie*. Pour cela, il va falloir utiliser le langage GREL :
   
   - Cliquez sur la colonne qui concentre les informations de genre et catégorie
   - Choisissez *add column based on this column*
   - Nommez la colonne *Catégorie*
   - Entrez le code GREL suivant : 
   ``` 
 if(contains(value,"C"), "Cadre",
 if(contains(value,"P"), "Profession",
 if(contains(value,"E"), "Employé", "Ouvrier")))
 ```
 
 3. *Création de la colonne Genre*
 
 Il faut maintenant créer la colonne *Genre*. Pour cela, il va falloir utiliser le langage GREL à nouveau. Le principe est le même que précédemment.
    - Cliquez sur la colonne qui concentre les informations de genre et catégorie
   - Choisissez *add column based on this column*
   - Nommez la colonne *Genre*
   - Entrez le code GREL suivant :
   ``` 
 if(contains(value,"MF"), "Femme", "Homme")
 ```
 
 C'est terminé, le nettoyage et la transformation sur OpenRefine devraient vous donner le dataset suivant : 
    
![ETAPE13_FINAL](https://user-images.githubusercontent.com/34581620/76154095-d588c680-60d6-11ea-892f-9e2a83544eda.jpg)

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
 # Construction de l'entrepôt de données
 Nous avons maintenant notre .csv correctement nettoyé et transformé selon nos besoins. Il va falloir à présent déterminer le format des données de notre entrepôt. Nous avons choisi le XML. La première étape consiste donc à écrire la Définition de Type de Document (ou DTD).
 ## Création de la DTD
 La DTD a été écrite selon les modèles et exercices vus en cours et TD. Elle correspond au schéma en étoile que nous avions déjà déterminé précédemment et dont voici la représentation : 
 
 ![image](https://user-images.githubusercontent.com/34581620/76370149-33ffb000-6336-11ea-9d92-a3ee6d5d5414.png)
 
 Voici le code de la DTD correspondante (ce code se trouve également dans le dossier **Code Source** de ce git) : 
 
 ```
 <!ELEMENT dataset (ligne*)>
    <!ELEMENT ligne (date,localisation,categorie,genre,salaire)>
    <!ATTLIST ligne id CDATA #REQUIRED> 
    <!ELEMENT localisation (codePostal,ville,departement,region,codeDep)>
    <!ELEMENT categorie EMPTY>
        <!ATTLIST categorie nom (Cadre|Profession|Employé|Ouvrier) #REQUIRED>
    <!ELEMENT genre EMPTY>
        <!ATTLIST genre nom (Femme|Homme) #REQUIRED>
    <!ELEMENT date EMPTY>
        <!ATTLIST date annee (2012|2013|2014|2015|2016) #REQUIRED>
    <!ELEMENT salaire (#PCDATA)>
    <!ELEMENT codePostal (#PCDATA)>
    <!ELEMENT ville (#PCDATA)>
    <!ELEMENT departement (#PCDATA)>
    <!ELEMENT region (#PCDATA)>
    <!ELEMENT codeDep (#PCDATA)>
 ```
 
 ## Conversion du fichier .csv au format .XML
 Maintenant que nous avons la DTD, nous savons quelle organisation nous souhaitons obtenir pour notre .xml. Il ne reste plus qu'à trouver un moyen de *mapper* les champs de notre .csv pour créer le fichier XML. Pour ce faire, nous avons écrit un programme Java spécifiquement destiné à faire ce travail. Ce programme va lire ligne par ligne le fichier .csv et créer le fichier XML section par section en utilisant le modèle suivant, qui correspont à la DTD : 
 
![image](https://user-images.githubusercontent.com/34581620/76177489-b2ccdf80-61b4-11ea-9af7-3fe489c794a2.png)

Voici le code Java correspondant (qui se trouve également dans le dossier **Code Source** de ce git). Ce code ne fait que retranscrire **exactement** le schéma précedent, mais de manière à être compréhensible par la JVM JAVA. Il s'agit simplement de lire le .csv d'un coté, ligne par ligne, et d'écrire dans le .xml selon le modèle ci-dessus :

``` java
// Ecrit par Juzdzewski Matthieu le 07/03/2020

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;

public class ParserCSVXML {

	static String path = "C:\\Users\\Matt\\Desktop\\FACM2Data\\BDD\\FINALCSV\\SALAIREFINAL.txt";
	static String outputFile = "C:\\\\Users\\\\Matt\\\\Desktop\\\\FACM2Data\\\\BDD\\\\FINALCSV\\XMLres.xml";
	
	public static void main(String[] args) {
		BufferedReader reader;
		try {
			reader = new BufferedReader(new FileReader(path));
			String line = reader.readLine();
			String[] headers = line.split(",");
			try
			{
				Files.write(Paths.get(outputFile), "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<dataset>\n".getBytes(), StandardOpenOption.APPEND);
			}
			catch(IOException e) {}
			line = reader.readLine();
			while(line != null)
			{
 			    String[] data = line.split(",");
				if(data.length > 1)
				{
					String section = "    <ligne id=\"" + data[0].replaceAll("\"", "") + "\">\n        <date annee=\""+ data[1].replaceAll("\"", "") +
							"\"></date>\n        <localisation>\n            <codePostal>"
							+ data[2].replaceAll("\"", "") + "</codePostal>\n            <ville>"+data[3].replaceAll("\"", "")
							+"</ville>\n            <departement>"+data[7].replaceAll("\"", "")+"</departement>\n            <region>"+data[8].replaceAll("\"", "")+"</region>\n            <codeDep>"
							+ data[9].replaceAll("\"", "")+"</codeDep>\n        </localisation>\n        <categorie nom=\""
							+data[5].replaceAll("\"", "")+"\"></categorie>\n        <genre nom=\""+data[4].replaceAll("\"", "")+"\"></genre>\n        <salaire>"+data[6].replaceAll("\"", "")+"</salaire>\n    </ligne>\n"; 

					try
					{
						Files.write(Paths.get(outputFile), section.getBytes(), StandardOpenOption.APPEND);
					}
					catch(IOException e) {}
				}				
				line = reader.readLine();
			}
			try
			{
				Files.write(Paths.get(outputFile), "</dataset>".getBytes(), StandardOpenOption.APPEND);
			}
			catch(IOException e) {}
		}
		catch(Exception e) {System.out.println("ERROR");}
	}
}
```
C'est terminé, le fichier XML et est prêt à être validé en utilisant le fichier dataValidator.xml générer à partir de la DTD.
Pour celà, nous utilsons l'invite de commande et exécutons le script suivant: (nécessite l'installation de xmlstarlet)

```Bash
xmllint --schema data.xsd XML_FINAL.xml
```
La commande devra retourner "XML_FINAL.xml validates" comme résultat.

# Requêtes en XSLT 2.0

Nous avons réalisé nos requêtes en **XSLT 2.0**. Cette version permet d'utiliser des fonctionalités comme le *group by* par exemple. Pour pouvoir l'utiliser, il faut télécharger le fichier .jar *SAXON* qui est disponible dans la partie **Prérequis** de cet article.
Toutes les requêtes suivantes sont disponibles sous forme **.xsl** dans le dossier **QUERIES** de ce git. Vous y trouverez également le résultat de la requête sous forme *HTML*, ainsi qu'une courte description de l'objectif de la requête.

## Requête n°1 : 

L'objectif de cette requête est de donner, pour chaque région, la moyenne des salaires pour chaque catégorie socio-professionnelle.
Le code *.xsl* se trouve dans le dossier **QUERIES**. Voici un extrait du résultat sous forme de table HTML.

### Extrait html

![image](https://user-images.githubusercontent.com/34581620/77568730-5dd5dc80-6ec9-11ea-8457-07588806c399.png)

### Représentation graphique

Ci-dessous une capture d'écran de la représentation graphique du résultat de la requête. Comme le résultat est trop grand pour s'afficher entièrement sur cette image, vous pouvez aller voir l'ensemble du graphique sur le lien suivant : https://public.tableau.com/profile/boulahmel#!/vizhome/salairemoyenparregionetcategoriesocio-professionnelleen2016/Sheet2?publish=yes

![image](https://user-images.githubusercontent.com/34581620/77576499-98457680-6ed5-11ea-8293-742f6478f2da.png)

On constate sans surprise que la région Île-de-France est la plus attractive en termes de salaire pour les cadres. Plus surprenant, notre région Pays de la Loire fait partie des régions où le salaire pour un cadre est le plus bas.

## Requête n°2 :

L'objectif de cette requête est de donner, pour chaque ville et chaque catégorie socio-professionnelle, la différence de salaire (en pourcentage) entre les hommes et les femmes. Le code *.xsl* se trouve dans le dossier **QUERIES**. Voici un extrait du résultat sous forme de table HTML.

### Extrait html

![image](https://user-images.githubusercontent.com/34581620/77597052-f8e8a980-6efd-11ea-94fc-ec27d5eb3402.png)

### Représentation graphique

Ci-dessous une capture d'écran de la représentation graphique du résultat de la requête. Comme le résultat est trop grand pour s'afficher entièrement sur cette image, vous pouvez aller voir l'ensemble du graphique sur les liens suivants :
https://public.tableau.com/profile/boulahmel#!/vizhome/Diffrencedesalaireentreunhommeetunefemmeparvillepourlescadresen2016/Sheet1
https://public.tableau.com/profile/boulahmel#!/vizhome/DiffrencedesalaireentreunhommeetunefemmeparvillepourlesEmploysesen2016/Sheet1
https://public.tableau.com/profile/boulahmel#!/vizhome/Diffrencedesalaireentreunhommeetunefemmeparvillepourlesouvriersesen2016/Sheet1?publish=yes
https://public.tableau.com/profile/boulahmel#!/vizhome/Diffrencedesalaireentreunhommeetunefemmeparvillepourlesprofessionsintermdiairesen2016/Sheet1?publish=yes

![image](https://user-images.githubusercontent.com/34581620/77597516-6c3eeb00-6eff-11ea-94c3-2ad6bbac587c.png)

## Requête n°3 :
## Requête n°4 :
## Requête n°5 :
## Requête n°6 :

L'objectif de cette requête est de montrer l'évolution globale de salaire (en %), par genre, entre 2012 et 2016. Le code *.xsl* se trouve dans le dossier **QUERIES**. Voici le résultat obtenu sous forme de table HTML.

### Résultat html

![image](https://user-images.githubusercontent.com/34581620/77672664-75749a00-6f89-11ea-82be-073bf1002cea.png)

### Représentation graphique

Voici les courbes d'évolution des salaires entre 2012 et 2016. La courbe en bleu correspond à l'évolution du salaire des femmes. L'autre courbe correspond à l'évolution du salaire des hommes. Vous pourrez retrouver le graphique sur ce lien :
https://public.tableau.com/profile/boulahmel#!/vizhome/Evolutiondesdiffrencesdesalairesentreleshommesetlesfemmes2012-2016/Sheet1?publish=yes

![image](https://user-images.githubusercontent.com/34581620/77675864-cd150480-6f8d-11ea-8e31-be0d7885a7eb.png)


## Requête n°7 :
## Requête n°8 :
## Requête n°9 :

 # Contributors
 - Amine Boulahmel amine.boulahmel@etu.univ-nantes.fr
 - Matthieu Juzdzewski matthieu.juzdzewski@etu.univ-nantes.fr
 - Harry Jandu harry.jandu@etu.univ-nantes.fr
 # License & copyright
 - Copyright © 2020 [Amine Boulahmel](https://github.com/Amine102),  [Matthieu Juzdzewski](https://github.com/juzdzewski), [Harry Jandu](https://github.com/hushee69).
 - Licensed under the [MIT License](LICENSE).
