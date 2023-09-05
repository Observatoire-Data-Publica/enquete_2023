# Pre-processing data


library(tidyverse)
data <- read_csv("Data/results-survey396597.csv")
communes <- read_delim("https://data.ofgl.fr/api/explore/v2.1/catalog/datasets/ofgl-base-communes-consolidee/exports/csv?lang=fr&facet=facet(name%3D%22reg_name%22%2C%20disjunctive%3Dtrue)&facet=facet(name%3D%22dep_name%22%2C%20disjunctive%3Dtrue)&facet=facet(name%3D%22epci_name%22%2C%20disjunctive%3Dtrue)&facet=facet(name%3D%22tranche_population%22%2C%20disjunctive%3Dtrue)&facet=facet(name%3D%22tranche_revenu_imposable_par_habitant%22%2C%20disjunctive%3Dtrue)&facet=facet(name%3D%22com_name%22%2C%20disjunctive%3Dtrue)&facet=facet(name%3D%22agregat%22%2C%20disjunctive%3Dtrue)&refine=exer%3A%222022%22&refine=agregat%3A%22Achats%20et%20charges%20externes%22&timezone=Europe%2FBerlin&use_labels=true&delimiter=%3B", ";") |> 
    select(`Code Siren Collectivité`, `Code Insee Collectivité`, `Nom 2022 Commune`, `Population totale`, `Catégorie`) |> 
    rename(COG = `Code Insee Collectivité`,
           nom = `Nom 2022 Commune`,
           SIREN = `Code Siren Collectivité`) |> 
    mutate(SIREN = as.character(SIREN),
           COG = as.character(COG)) |> 
    arrange(COG)
regions <- read_delim("https://data.ofgl.fr/api/explore/v2.1/catalog/datasets/ofgl-base-regions-consolidee/exports/csv?lang=fr&facet=facet(name%3D%22reg_name%22%2C%20disjunctive%3Dtrue)&facet=facet(name%3D%22agregat%22%2C%20disjunctive%3Dtrue)&refine=exer%3A%222022%22&refine=agregat%3A%22Achats%20et%20charges%20externes%22&timezone=Europe%2FBerlin&use_labels=true&delimiter=%3B", ";") |> 
    select(`Code Siren Collectivité`, `Code Insee 2022 Région`, `Nom 2022 Région`, `Population totale`, `Catégorie`) |> 
    rename(COG = `Code Insee 2022 Région`,
           nom = `Nom 2022 Région`,
           SIREN = `Code Siren Collectivité`) |> 
    mutate(SIREN = as.character(SIREN),
           COG = as.character(COG)) |> 
    arrange(COG)
departements <- read_delim("https://data.ofgl.fr/api/explore/v2.1/catalog/datasets/ofgl-base-departements-consolidee/exports/csv?lang=fr&facet=facet(name%3D%22reg_name%22%2C%20disjunctive%3Dtrue)&facet=facet(name%3D%22dep_tranche_population%22%2C%20disjunctive%3Dtrue)&facet=facet(name%3D%22dep_name%22%2C%20disjunctive%3Dtrue)&facet=facet(name%3D%22agregat%22%2C%20disjunctive%3Dtrue)&refine=exer%3A%222022%22&refine=agregat%3A%22D%C3%A9penses%20totales%22&timezone=Europe%2FBerlin&use_labels=true&delimiter=%3B", ";") |> 
    select(`Code Siren Collectivité`, `Code Insee 2022 Département`, `Nom 2022 Département`, `Population totale`, `Catégorie`) |> 
    rename(COG = `Code Insee 2022 Département`,
           nom = `Nom 2022 Département`,
           SIREN = `Code Siren Collectivité`) |> 
    mutate(SIREN = as.character(SIREN),
           COG = as.character(COG)) |> 
    arrange(COG)
epci <- read_delim("https://data.ofgl.fr/api/explore/v2.1/catalog/datasets/ofgl-base-ei/exports/csv?lang=fr&facet=facet(name%3D%22libelle_categ%22%2C%20disjunctive%3Dtrue)&facet=facet(name%3D%22dep_name%22%2C%20disjunctive%3Dtrue)&facet=facet(name%3D%22gfp_tranche_population%22%2C%20disjunctive%3Dtrue)&facet=facet(name%3D%22nat_juridique%22%2C%20disjunctive%3Dtrue)&facet=facet(name%3D%22mode_financement%22%2C%20disjunctive%3Dtrue)&facet=facet(name%3D%22gfp_tranche_revenu_imposable_par_habitant%22%2C%20disjunctive%3Dtrue)&facet=facet(name%3D%22epci_name%22%2C%20disjunctive%3Dtrue)&facet=facet(name%3D%22agregat%22%2C%20disjunctive%3Dtrue)&refine=exer%3A%222022%22&refine=agregat%3A%22Achats%20et%20charges%20externes%22&timezone=Europe%2FBerlin&use_labels=true&delimiter=%3B", ";") |> 
    select(`Code Siren 2022 EI`, `Nom 2022 EI`, `Population totale`, `Catégorie`) |> 
    rename(nom = `Nom 2022 EI`,
           SIREN = `Code Siren 2022 EI`) |> 
    mutate(SIREN = as.character(SIREN),
           COG = NA_character_) |> 
    arrange(COG)
coll_ter <- rbind(regions, departements, communes, epci)


# Join data, recup catégorie, population des CT
test <- data |> 
    mutate(nom = toupper(str_replace_all(`Quel est le nom de votre structure ?`, "[^[:alnum:]]", " ")), #remove special char
           nom = str_replace_all(nom, "[0-9]", ""), # remove digits
           nom = trimws(nom, which = "both"), #remove white space end of string
           nom = stringi::stri_trans_general(str = nom, id = "Latin-ASCII"), #remove accents
           nom = str_replace_all(nom, c("DEPARTEMENT D " = "", "DEPARTEMENT DE " = "", 
                                        "DEPARTEMENT DE LA " = "", "DEPARTEMENT " = "", 
                                        "DEPARTEMENT DU " = "", "COMMUNE DE " = "", 
                                        "COMMUNE DE LA " = "", "MAIRIE DE " = "",
                                        "MAIRIE D " = "", "CONSEIL DEPARTEMENTAL DE L " = "",
                                        "CONSEIL DEPARTEMENTAL DE LA " = "",
                                        "CONSEIL DEPARTEMENTAL DES " = "",
                                        "CONSEIL DEPARTEMENTAL DE " = "",
                                        "CONSEIL DEPARTEMENTAL DU " = "",
                                        "CONSEIL REGIONAL " = "",
                                        "CONSEIL REGIONAL D " = "",
                                        "CONSEIL REGIONAL DES " = "",
                                        "COMMUNAUTE DE COMMUNES" = "CC",
                                        "COMMUNAUTE D AGGLOMERATION" = "CA"
                                        ))) |>  
    left_join(coll_ter |> mutate(nom = toupper(nom),
                                 nom = toupper(str_replace_all(nom, "[^[:alnum:]]", " ")), #remove special char
                                 nom = str_replace_all(nom, "[0-9]", ""), # remove digits
                                 nom = trimws(nom, which = "both"),
                                 nom = stringi::stri_trans_general(str = nom, id = "Latin-ASCII")), by = "nom") |> 
    select(`ID de la réponse`, `Quel est le nom de votre structure ?`, 303:307)
rio::export(test, "Data/dernieres_responses.csv")


