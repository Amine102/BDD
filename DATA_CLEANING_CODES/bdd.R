

#Après avoir importé votre fichier CSV, créer une variable sous le nom de SALAIRE  et initialisez la à votre import afin d'utiliser les codes ci_dessous.
SALAIRE$Salaire <-  as.numeric(gsub(",", ".", SALAIRE$Salaire))

SALAIRE$Région <- departements.region[as.character(match(substr(SALAIRE$Code.Postal,1,2),departements.region$num_dep)),3] #Commande d'insertion de région
SALAIRE$Départements <- departements.region[as.character(match(substr(SALAIRE$Code.Postal,1,2),departements.region$num_dep)),2] #initialiser les départements
levels(SALAIRE$Départements) <- c(levels(SALAIRE$Départements), c("Guadeloupe","Martinique","Guyane","La Réunion","Mayotte")) #Rajout de facteurs




NADepReg <- function(){                  #Pour les déparements de 3 chiffres (Departement vaut région)
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
  return(SALAIRE)
}


#rajout de code de départements
SALAIRE$CodeDép <- departements.region[match(SALAIRE$Départements,departements.region$dep_name),1]  #Rajout de code de département

SALAIRE_F <- rbind(SALAIRE2012,SALAIRE2013,SALAIRE2014, SALAIRE2015, SALAIRE2016) #merge des datasets

clean <- function(dataset){ #Fonction de cleaning (à utiliser uniquement à la fin !)
  dataset[dataset==0] <- NA
  dataset <- na.omit(dataset)
  return(dataset)
}

write.csv(SALAIRE,"~/<PATH>/SALAIRE2015.csv")





















