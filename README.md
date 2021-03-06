# Base de données évoluées
# Contenu
1. [Prérequis](#Prérequis)
2. [Préparation des données](#Préparation-des-données)
	1. [Prétraitements sous OpenRefine](#Prétraitements-sous-OpenRefine)
	2. [Prétraitements sous R](#Prétraitements-sous-R)
3. [Construction de l'entrepôt de données](#construction-de-lentrepôt-de-données)
	1. [Création de la DTD](#Création-de-la-DTD)
	2. [Conversion du fichier csv au format xml ](#conversion-du-fichier-csv-au-format-xml)
4. [Requêtes en XSLT 2.0](#requêtes-en-xslt-20)
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
 - Ouvrez le logiciel R, importez votre fichier CSV prétraité par OpenRefine 
 ``` Bash
 (File -> Import Dataset -> From Text (base)...).
 ``` 
 ![Import sous R](https://user-images.githubusercontent.com/43194428/76044371-6e460780-5f5a-11ea-833d-9c5d8d8d6de7.png)
 - Après sélection du fichier, une fenêtre d'options apparaîtra; Cochez YES dans la partie Heading puis cliquez sur Import
 
 ![head](https://user-images.githubusercontent.com/43194428/76151958-9187c880-60ba-11ea-85a2-45e79196fbe5.png)
 - De la même façon, importez le dataset departements-region.csv,
 - Avant de commencer les prétraitements, utilisez une variable d'environnement afin de ne pas modifier le fichier importé (dans notre cas, nous l'appellerons DATA):
 ```R
 DATA <- <Nom_fichier_importé>
 ```
 - La première étape consiste à changer le séparateur de décimals de chaque valeurs figurant dans la colone Salaire. Exécutez le script suivant en console R:
 ```R
  DATA$Salaire <- as.numeric(gsub(",",".",DATA$Salaire))
 ```
 - La seconde étape consiste à rajouter deux nouvelles colonnes: Régions et departements en utilisant le dataset departements.region importé auparavant. Pour cela, Exécutez les deux scripts en console R:
  ```R
  DATA$Région <- departements.region[as.character(match(substr(DATA$Code.Postal,1,2),departement.region$num_dep)),3]
  DATA$Département <- departements.region[as.character(match(substr(DATA$Code.Postal,1,2),departement.region$num_dep)),2]
 ```
 - Comme on peut le remarquer, quelques lignes contiennent la valeur NA. Cela est dû au fait que le code précédent effectue des match sur uniquement les deux premier chiffres de chaque code postal appartenant au dataset DATA. Afin d'initialiser les valeurs NA avec les nouvelles données, tapez en console le script suivant:
 ```R
 levels(DATA$Départements) <- c(levels(DATA$Départements), c("Guadeloupe", "Martinique", "Guyane", "La Réunion", "Mayotte"))
 ```
 - Le code ci-dessus permet de rajouter un niveau de facteurs afin d'initialiser les valeurs NA avec de nouvelles données (les dataFrame en R utilisent les facteurs qui sont des structures de données utilisées pour des valeurs de type catégories)
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
 - La troisième étape consiste à rajouter des codes de départements afin de faciliter le requêtage du future dataset. Executez en console le script suivant:
 ```R
 DATA$CodeDép <- departements.region[match(DATA$Départements,departements.region$dep_name),1]  #Rajout de code de département
 ```
 - Une fois les étapes précédentes achevées, exportez le dataset en fichier CSV grâce à la commande suivante:
 ```R
 write.csv(DATA,"~/<Chemin>/<nom_dataset_ANNEE>.csv")
 ```
 - Refaites les même étapes pour chaque dataset. Une fois les datasets prêts, faites un merge par ligne en éxecutant le script suivant dans la console R:
 ```R
 FINAL_DATA <- rbind(<Nom_DATASET_1>,<Nom_DATASET_2>,<Nom_DATASET_3>, <Nom_DATASET_4>, <Nom_DATASET_5>) #merge des datasets
 ```
 - Enfin, faites l'exportation en utilisant la même commande evoquée auparavant:
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


![image](https://user-images.githubusercontent.com/34581620/78177837-07cfde80-745f-11ea-9bf6-5da07570ad24.png)

### Représentation graphique

Ci-dessous une capture d'écran de la représentation graphique du résultat de la requête. Comme le résultat est trop grand pour s'afficher entièrement sur cette image, vous pouvez aller voir l'ensemble du graphique sur le lien suivant :
https://public.tableau.com/profile/boulahmel#!/vizhome/Diffrencedesalaireenpourcentageentreleshommesetlesfemmespourchaquevilleen2016/Sheet1?publish=yes

![image](https://user-images.githubusercontent.com/34581620/78178125-714fed00-745f-11ea-807d-f691bba8460e.png)

## Requête n°3 :

L'objectif de cette requête est de montrer le salaire moyen des hommes et des femms pour chaque année entre 2012 et 2016. Voici le résultat sous forme de table HTML.

### Résultat html

![image](https://user-images.githubusercontent.com/34581620/77686866-dad28600-6f9d-11ea-8da1-18f542fff69a.png)

### Représentation graphique

Voici la représentation graphique du résultat :

![image](https://user-images.githubusercontent.com/34581620/77690257-4b2fd600-6fa3-11ea-8dbd-b1309863e088.png)

## Requête n°4 :

L'objectif de cette requête est de montrer les salaires moyens par région et catégorie socio-professionnelle entre 2012 et 2016. La requête est similaire à la requête 1, à ceci près que cette fois nous avons les données pour **chaque** année. Voici un extrait du résultat HTML.

### Extrait html

![image](https://user-images.githubusercontent.com/34581620/77691580-79aeb080-6fa5-11ea-9d6b-c5df2622e165.png)

### Représentation graphique

Voici la représentation graphique du résultat. Vous trouverez le document complet sur le lien suivant :
https://public.tableau.com/profile/boulahmel#!/vizhome/Salairesmoyensparrgionsetcatgoriessocio-professionnellesentre2012et2016/Sheet1?publish=yes

![image](https://user-images.githubusercontent.com/34581620/77691701-ad89d600-6fa5-11ea-931d-020fce9d2d49.png)

## Requête n°5 :

L'objectif de cette requête est de montrer le salaire moyen par ville en 2016. Voici un extrait du résultat sous frome de table HTML.

### Extrait html

![image](https://user-images.githubusercontent.com/34581620/77708147-85ab6a00-6fc7-11ea-8599-9219d97b64f1.png)

### Représentation graphique

Voici la représentation graphique du résultat. Vous trouverez le lien vers le document complet sur le lien suivant : 
https://public.tableau.com/profile/boulahmel#!/vizhome/Salairesmoyensparvilletoutecatgoriesocio-professionnelleetgenreconfondusen2016/Sheet1?publish=yes

![image](https://user-images.githubusercontent.com/34581620/77709036-13885480-6fca-11ea-8e84-e690d1c90963.png)

## Requête n°6 :

L'objectif de cette requête est de montrer l'évolution globale de salaire (en %), par genre, entre 2012 et 2016. Le code *.xsl* se trouve dans le dossier **QUERIES**. Voici le résultat obtenu sous forme de table HTML.

### Résultat html

![image](https://user-images.githubusercontent.com/34581620/78177686-c93a2400-745e-11ea-8f81-4771c80a7943.png)

### Représentation graphique

Voici les courbes d'évolution des salaires entre 2012 et 2016. La courbe en bleu correspond à l'évolution de l'augmentation du salaire des femmes. L'autre courbe correspond à l'évolution de l'augmentation du salaire des hommes. Vous pourrez retrouver le graphique sur ce lien :
https://public.tableau.com/profile/boulahmel#!/vizhome/Evolutiondesdiffrencesdesalairesentreleshommesetlesfemmes2012-2016/Sheet1?publish=yes

![image](https://user-images.githubusercontent.com/34581620/78178340-c429a480-745f-11ea-83ac-d0e86b65607d.png)


## Requête n°7 :

L'objectif de cette requête est de donner, pour chaque catégorie socio-professionnelle, la ville la plus *intéressante* en terme de salaire (en 2016). Voici le résultat sous forme de table HTML.

### Résultat html

![image](https://user-images.githubusercontent.com/34581620/77948233-62cdce00-72c5-11ea-8d55-f13f96c486e4.png)

### Représentation graphique

Voici une représentation graphique du résultat. Vous pouvez également trouver le graphique sur ce lien : 
https://public.tableau.com/profile/boulahmel#!/vizhome/Lavillelaplusintressanteentermedesalairepourchaquecatgoriesocio-professionnelleen2016/Sheet1?publish=yes

![image](https://user-images.githubusercontent.com/34581620/77948500-cbb54600-72c5-11ea-96e5-a829834faff4.png)

## Requête n°8 :

L'objectif de cette requête est de tenter de prévoir, en utilisant les données des salaires de 2012 à 2016, la valeur du salaire moyen en 2020, 2025 et 2030. Voic le résultat sous la forme d'une table HTML.

### Extrait html

![image](https://user-images.githubusercontent.com/34581620/77950862-79762400-72c9-11ea-88fb-23e6fd9dc68d.png)

### Représentation graphique

Voici une réprésentation graphique du résultat. Vous pouvez également trouver le graphique en suivant ce lien :
https://public.tableau.com/profile/boulahmel#!/vizhome/volutiondesalairemoyenpourchaquecategoriesocio-professionnelleentre2012et2016/Sheet1?publish=yes

![image](https://user-images.githubusercontent.com/34581620/77952018-49c81b80-72cb-11ea-8e8a-fabc2d1d9774.png)

## Requête n°9 :

L'objectif de cette requête est de montrer quelle est la ville la plus *intéressante* en terme de salaire (en 2016), et ce pour chaque département et chaque catégorie socio-professionnelle. Voici un extrait du résultat sous forme de table HTML.

### Extrait html

![image](https://user-images.githubusercontent.com/34581620/77952280-adeadf80-72cb-11ea-98fb-8f875d708069.png)

### Représentation graphique

Voici un extrait de la représentation graphique du résultat. Vous pourrez trouver le document complet en suivant le lien suivant :
https://public.tableau.com/profile/boulahmel#!/vizhome/Dterminerpourchaquergionetchaquedpartementquelleestlavillelaplusintressanteentermedesalairepourchaquecatgoriesocio-propfessionnelleen2016/Sheet1?publish=yes

![image](https://user-images.githubusercontent.com/34581620/77952445-f7d3c580-72cb-11ea-81d0-c857f54de7f2.png)

## Requête n°10 :

L'objectif de cette requête est de déterminer quelle est la ville qui propose le meilleur salaire en 2016, toute catégorie et genre confondus. Voici le résultat sous la forme d'une table HTML.

### Résultat html

![image](https://user-images.githubusercontent.com/34581620/77954918-aa595780-72cf-11ea-98ad-a10e02f30817.png)

### Représentation graphique

Voici la représentation graphique du résultat.

![image](https://user-images.githubusercontent.com/34581620/77955747-02dd2480-72d1-11ea-87c6-2b7922a8581d.png)


 # Contributors
 - Amine Boulahmel amine.boulahmel@etu.univ-nantes.fr
 - Matthieu Juzdzewski matthieu.juzdzewski@etu.univ-nantes.fr
 - Harry Jandu harry.jandu@etu.univ-nantes.fr
 # License & copyright
 - Copyright © 2020 [Amine Boulahmel](https://github.com/Amine102),  [Matthieu Juzdzewski](https://github.com/juzdzewski), [Harry Jandu](https://github.com/hushee69).
 - Licensed under the [MIT License](LICENSE).
