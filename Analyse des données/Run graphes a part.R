# Données et librairies
# Import de données
library(tidyverse)
data <- read_csv("./Data/results-survey396597.csv") |> select(1:220)
CT_enrichies <- read_csv("./Data/interim_data.csv")
data_2022 <- readxl::read_xlsx("./Data/data_enquete_2022.xlsx", "Resultats Bruts")

# Jointure questionnaire + type de structure récupéré en pre-processing
data <- data |> 
    left_join(CT_enrichies |> select(-2), by = "ID de la réponse") |> 
    mutate(Catégorie = case_when(Catégorie == "Commune" ~ "Une commune",
                                 Catégorie == "Metropole" ~ "Une métropole",
                                 Catégorie == "Departement" ~ "Un département",
                                 Catégorie == "Region" ~ "Une région",
                                 Catégorie == "EPCI" ~ "Un EPCI (hors métropole)"),
           Catégorie2 = case_when(Catégorie == "Une commune" & `Population totale` < 3500 ~ "Communes de moins de 3 500 hab.",
                               Catégorie == "Une commune" & `Population totale` >= 3500 & `Population totale` < 10000 ~ "Communes de 3 500 à 10 000 hab.",
                               Catégorie == "Une commune" & `Population totale` >= 10000 & `Population totale` < 100000 ~ "Communes de 10 000 à 100 000 hab.",
                               Catégorie == "Une commune" & `Population totale` >= 100000 ~ "Communes de plus de 100 000 hab.",
                               is.na(Catégorie) ~ "Autre",
                               .default = Catégorie),
           Catégorie = case_when(is.na(Catégorie) ~ "Autre", .default = Catégorie))

# Données complètes
data_clean <- data |> 
    filter(!is.na(`Votre structure a-t-elle engagé une réflexion sur les enjeux du numérique responsable ?`))
data_clean_unique <- data_clean |> 
    mutate(nb_na = rowSums(is.na(data_clean))) |> 
    mutate(n = n(), .by = nom) |> 
    group_by(nom) |> slice(which.min(nb_na)) |> ungroup()
# data_clean_unique |> 
#     rename(structure = Catégorie, structure_pop = Catégorie2) |> 
#     select(-c(2:10, SIREN, COG, nb_na, n)) |> 
#     rio::export("./Data/process_data.csv")

# Liste des régions
library(tools)
reg <- data_clean_unique |> filter(Catégorie == "Une région") |> 
    mutate(nom = toTitleCase(tolower(nom))) |> distinct(nom) |> t()

# Import des données des stats rassemblés
  # 2023
all_stat_2023 <- read_csv("./Data/All_statistics_2023.csv") |> 
  mutate(Edition = "2023")
# rassemble EPCI (hors métropoles) et métropoles pour correspondre à édition 2022
epci_met <- all_stat_2023 |> 
  filter(Structure == "Un EPCI (hors métropole)" | Structure == "Une métropole") |> 
  pivot_wider(names_from = Structure, values_from = c(Occurrences, `Nombre de réponses`)) |> 
  mutate(Occurrences = sum(`Occurrences_Un EPCI (hors métropole)`, `Occurrences_Une métropole`, na.rm = T), 
         `Nombre de réponses` = sum(`Nombre de réponses_Un EPCI (hors métropole)`, `Nombre de réponses_Une métropole`, na.rm = T), 
         .by = c(Question, Réponses)) |> 
  distinct(Question, Réponses, Occurrences, `Nombre de réponses`, Edition) |> 
  mutate(`Effectifs par structure` = 69+36, #EPCI (hors métropoles) + métropoles
         `Structure` = "Un EPCI",
         Pourcentage = round(Occurrences/105 *100, 0))
all_stat_2023_comp <- rbind(all_stat_2023, epci_met) |> 
  arrange(Question, Structure) |> 
  filter(Structure != "Un EPCI (hors métropole)", Structure != "Une métropole")
  # 2022
all_stat_2022 <- read_csv("./Data/All_statistics_2022.csv") |> ungroup() |> 
                    mutate(Structure = str_replace_all(Structure, c("Moins de 3 500 habitants" = "Communes de moins de 3 500 hab.",
                                                                    "Entre 3 500 et 10 000 habitants" = "Communes de 3 500 à 10 000 hab.",
                                                                    "Entre 10 000 et 100 000 habitants" = "Communes de 10 000 à 100 000 hab.",
                                                                    "Plus de 100 000 habitants" = "Communes de plus de 100 000 hab.")),
                           Question = str_extract(Question, "\\s+(.*)"), #remove first word ~ question id
                           Question = substr(Question, 2, nchar(Question)), #remove white space before question
                           Réponses = case_when(grepl("\\[", Réponses) == TRUE ~ str_extract(Réponses, "(?<=\\[).*"),
                                                .default = Réponses)) 
# Jointure des stats des 2 éditions
all_stat <- rbind(all_stat_2022, all_stat_2023_comp) |> 
  mutate(Question = str_replace_all(Question, " ", " ")) |> 
  arrange(Question)


# Données répartition des structures par type à échelle nationale
prop_nationales <- data.frame(Structure = c("Une commune",
                                            "Une région",
                                            "Un département",
                                            "Un EPCI (hors métropole)",
                                            "Une métropole",
                                            "Communes de 3 500 à 10 000 hab.",
                                            "Communes de 10 000 à 100 000 hab.",
                                            "Communes de plus de 100 000 hab."),
                              Nombre_nat = c(34945,
                                         18,
                                         101,
                                         1233,
                                         21,
                                         2160,
                                         981,
                                         42)) |> 
    mutate(percent_nat = Nombre_nat / 36318 * 100)
prop_echantillon <- data.frame(Structure = c("Une commune",
                                            "Une région",
                                            "Un département",
                                            "Un EPCI (hors métropole)",
                                            "Une métropole",
                                            "Communes de 3 500 à 10 000 hab.",
                                            "Communes de 10 000 à 100 000 hab.",
                                            "Communes de plus de 100 000 hab."),
                              Nombre_ech = c(data_clean_unique |> filter(Catégorie == "Une commune") |> nrow(),
                                         data_clean_unique |> filter(Catégorie2 == "Une région") |> nrow(),
                                         data_clean_unique |> filter(Catégorie2 == "Un département") |> nrow(),
                                         data_clean_unique |> filter(Catégorie2 == "Un EPCI (hors métropole)") |> nrow(),
                                         data_clean_unique |> filter(Catégorie2 == "Une métropole") |> nrow(),
                                         data_clean_unique |> filter(Catégorie2 == "Communes de 3 500 à 10 000 hab.") |> nrow(),
                                         data_clean_unique |> filter(Catégorie2 == "Communes de 10 000 à 100 000 hab.") |> nrow(),
                                         data_clean_unique |> filter(Catégorie2 == "Communes de plus de 100 000 hab.") |> nrow())) |> 
    mutate(percent_ech = Nombre_ech / nrow(data_clean_unique) * 100)
prop_all <- prop_nationales |> 
    left_join(prop_echantillon, by = "Structure") |> 
    mutate(poids = percent_nat / percent_ech)


# Thème ggplot customisé
font <- "Helvetica"
custom_theme <- function (){
    font <- "Helvetica"
    ggplot2::theme(plot.title = ggplot2::element_text(family = font,size = 25, face = "bold", color = "#222222"), 
        plot.subtitle = ggplot2::element_text(family = font,size = 20, face = "italic", margin = ggplot2::margin(0, 0, 9, 0)), 
        plot.caption = ggplot2::element_text(family = font,size = 15, margin = ggplot2::margin(9, 0, 9, 0)), 
        legend.title = ggplot2::element_text(family = font, size = 15, color = "#222222"), 
        legend.position = "top", 
        legend.text.align = 0, 
        legend.background = ggplot2::element_blank(),
        legend.key = ggplot2::element_blank(),
        legend.text = ggplot2::element_text(family = font, size = 20,color = "#222222"), 
        axis.text = ggplot2::element_text(family = font, size = 20,color = "#222222"), 
        axis.text.x = ggplot2::element_text(margin = ggplot2::margin(5,b = 10)), 
        axis.title = ggplot2::element_text(family = font, size = 22,color = "#222222"),
        axis.ticks = ggplot2::element_blank(),
        axis.line = ggplot2::element_blank(), 
        panel.grid.minor = ggplot2::element_blank(),
        panel.grid.major.y = ggplot2::element_line(color = "#cbcbcb"),
        panel.grid.major.x = ggplot2::element_blank(), 
        panel.background = ggplot2::element_blank(),
        strip.background = ggplot2::element_rect(fill = "white"),
        strip.text = ggplot2::element_text(size = 22, hjust = 0, face = "bold"))
}
# couleurs data publica
    ## Vieille pres
    # bleu foncé : 273768
    # cyan fluo : 3de5fc
    # jaune fluo : ffcd1c

    ## Site Observatoire
    # bleu foncé : 323465
    # cyan plus foncé : 33bbc9
    # jaune / orange : e1b44d

# Librairies et fonction d'export des graphs
library(cowplot)
library(gridExtra)
library(glue)
saving_plot <- function(graph, name) {
  ggsave(file = glue("./Graphiques/PNG/{name}.png"), plot = graph, width = 20, height = 15)
  ggsave(file = glue("./Graphiques/SVG/{name}.svg"), plot = graph, width = 20, height = 15)
}
saving_plot_comp <- function(graph, name) {
  ggsave(file = glue("./Graphiques/PNG/Comparaison 2022-2023 : {name}.png"), plot = graph, width = 25, height = 15)
  ggsave(file = glue("./Graphiques/SVG/Comparaison 2022-2023 : {name}.svg"), plot = graph, width = 25, height = 15)
}
saving_newplot <- function(graph, name) {
  ggsave(file = glue("./Graphiques/PNG/Comparaison 2022-2023 CT et EPCI hors com<3500 hab : {name}.png"), plot = graph, width = 13, height = 7)
  #ggsave(file = glue("./Graphiques/SVG/Comparaison 2022-2023 CT et EPCI hors com<3500 hab : {name}.svg"), plot = graph, width = 12, height = 7)
}


# Données pour les dataviz
ref_nb_structures <- rbind(data_clean_unique |> summarise(n_total = n(), .by = Catégorie2),
                  data_clean_unique |> filter(Catégorie == "Une commune") |> summarise(n_total = n(), .by = Catégorie) |> rename(Catégorie2 = 1)) |>
    add_row(Catégorie2 = "Total", n_total = nrow(data_clean_unique))
nb_commune <- (ref_nb_structures |> filter(Catégorie2 == "Une commune") |> select(n_total))$n_total




#----------------------------------------------------


# Fonctions

dataviz <- function(nom_col){
    # Fonction graph ensemble
    dat <- all_stat_2023 |> 
        filter(Question == nom_col & Structure == "Total",
               Réponses != "Sans réponse")
    p0 <- dat |> 
        ggplot(aes(y=Occurrences, x=Réponses, fill = Réponses)) + 
            geom_bar(position="dodge", stat="identity", width=.6, size = 1, alpha = .9) +
            labs(x = "", y = "Nombre de réponses", 
                 title = paste("Toutes les collectivités,", dat$`Nombre de réponses`, "réponses")) +
            geom_label(aes(x = Réponses, y = Occurrences+1, label = paste0(Pourcentage, "%")), 
                       size = 8, fill = "white", label.size = NA, hjust = 0) +
            scale_fill_manual(values = c("grey", "#bf0001", "#e1b44d", "#33bbc9", "#323465", "#616165", "#0a0a14")) +
            scale_x_discrete(labels = function(x) stringr::str_wrap(x, width = 30)) +
            ylim(0, max(dat$Occurrences)+14) +
            coord_flip() +
            theme_classic() +
            custom_theme() +
            theme(legend.position = "none",
                  plot.title = element_text(hjust = 1),
                  panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb"),
                  panel.grid.major.y = ggplot2::element_blank())
    # Fonction graph total pondéré
    dat <- all_stat_2023 |> 
        filter(Question == nom_col & Structure == "Total pondéré",
               Réponses != "Sans réponse")
    p0_pond <- dat |> 
        ggplot(aes(y=Pourcentage, x=Réponses, fill = Réponses)) + 
            geom_bar(position="dodge", stat="identity", width=.6, size = 1, alpha = .9) +
            labs(x = "", y = "Pourcentage de réponses", 
                 title = "Total pondéré") +
            geom_label(aes(x = Réponses, y = Pourcentage+1, label = paste0(Pourcentage, "%")), 
                       size = 8, fill = "white", label.size = NA, hjust = 0) +
            scale_fill_manual(values = c("grey", "#bf0001", "#e1b44d", "#33bbc9", "#323465", "#616165", "#0a0a14")) +
            scale_x_discrete(labels = function(x) stringr::str_wrap(x, width = 30)) +
            ylim(0, max(dat$Pourcentage)+14) +
            coord_flip() +
            theme_classic() +
            custom_theme() +
            theme(legend.position = "none",
                  panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb"),
                  panel.grid.major.y = ggplot2::element_blank())+
            guides(fill = guide_legend(title = "Légende", ncol = 1))
    # Fonction type de collectivité
    dat <- all_stat_2023 |> 
        filter(Question == nom_col & (Structure == "Une commune" | Structure == "Un EPCI (hors métropole)" | Structure == "Une métropole" | Structure == "Un département" | Structure == "Une région" | Structure == "Autre"),
               Réponses != "Sans réponse") |> 
        mutate(Pourcentage = as.numeric(Pourcentage)/100,
               Structure = factor(Structure, levels = c("Autre","Une région","Un département","Une métropole","Un EPCI (hors métropole)","Une commune")))
    p1 <- dat |> 
        ggplot(aes(fill=Réponses, y=Pourcentage, x=Structure)) + 
        geom_bar(position="fill", color = "white", stat="identity", alpha = .9) +
        labs(x = "", y = "Pourcentage de réponses", title = "Par type de collectivité") +
        scale_y_continuous(labels = scales::percent, limits = c(0,1)) +
        scale_fill_manual(values = c("grey", "#bf0001", "#e1b44d", "#33bbc9", "#323465", "#616165", "#0a0a14")) +
        coord_flip() +
        theme_classic() +
        custom_theme() +
        guides(fill = guide_legend(nrow = 3, title = "", reverse = T)) +
            theme(legend.position = "none",
                  panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb"),
                  panel.grid.major.y = ggplot2::element_blank())
    # Fonction taille de commune
    dat <- all_stat_2023 |> 
        filter(Question == nom_col & grepl("Communes de", Structure) == TRUE,
               Réponses != "Sans réponse") |> 
        mutate(Pourcentage = as.numeric(Pourcentage)/100,
               Structure = str_replace_all(Structure, c("Communes de " = "", "p" = "P", "m" = "M")),
               Structure = factor(Structure, levels = c("Plus de 100 000 hab.","10 000 à 100 000 hab.","3 500 à 10 000 hab.","Moins de 3 500 hab.")))
    p2 <- dat |> 
        ggplot(aes(fill=Réponses, y=Pourcentage, x=Structure)) + 
        geom_bar(position="fill", color = "white", stat="identity", alpha = .9) +
        labs(x = "", y = "Pourcentage de réponses", title = "Par taille de commune") +
        scale_y_continuous(labels = scales::percent, limits = c(0,1)) +
        scale_fill_manual(values = c("grey", "#bf0001", "#e1b44d", "#33bbc9", "#323465", "#616165", "#0a0a14")) +
        coord_flip() +
        theme_classic() +
        custom_theme() +
        guides(fill = guide_legend(nrow = 3, title = "", reverse = T)) +
        theme(legend.position = "none",
              panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb"),
              panel.grid.major.y = ggplot2::element_blank())
    # Légende
    p3 <- dat |> 
        ggplot(aes(fill=Réponses, y=Pourcentage, x=Structure)) + 
        geom_bar(position="fill", color = "white", stat="identity", alpha = .9) +
        labs(x = "", y = "Pourcentage de réponses", title = "Par taille de commune", fill = "légende") +
        scale_y_continuous(labels = scales::percent, limits = c(0,1)) +
        scale_fill_manual(values = c("grey", "#bf0001", "#e1b44d", "#33bbc9", "#323465", "#616165", "#0a0a14")) +
        coord_flip() +
        theme_classic() +
        custom_theme() +
        guides(fill = guide_legend(ncol = 1, title = "", reverse = T)) +
        theme(legend.position = "top",
              panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb"),
              panel.grid.major.y = ggplot2::element_blank())
     legend <- get_legend(p3 + theme(legend.box.margin = margin(0, 0, 10, 12)))
    # All
    left_part <- plot_grid(p0, p0_pond, ncol = 1)
    right_part <- plot_grid(p1, p2, ncol = 1)
    all_plots <- plot_grid(left_part, right_part, ncol = 2)
    graph <- plot_grid(all_plots, legend, nrow = 2, rel_heights = c(.9, .1))
    assign("graph", graph, envir = .GlobalEnv)
    #grid::grid.draw(graph)
}



library(ggtext)
library(plotly)
library(ggiraph)

dataviz_comp <- function(all_stat, nom_col22, nom_col23){
  # Stats pour graphique
  table_all <- all_stat |> 
    filter((Question == nom_col22 | Question == nom_col23) & Réponses != "Sans réponse") |> 
    arrange(Structure, Réponses, Edition) |> 
    group_by(Structure, Réponses) |> 
    mutate(ecart = Pourcentage - lag(Pourcentage),
           Pourcentage = Pourcentage /100) |> 
    mutate(pos_ecart = case_when(!is.na(ecart) ~ max(Pourcentage) + .02, .default = NA_real_)) |> 
    mutate(ecart = case_when(ecart >= 0 ~ paste0("+", ecart), .default = as.character(ecart)))
    
  
  # Graphique Total
    # data
  table_total <- table_all |> 
    filter(Structure == "Total")
    # viz
  graph_total <- table_total |> 
    ggplot(aes(x = Réponses, y = Pourcentage, fill = Edition, group = Edition,
               tooltip = paste0(Pourcentage*100, "% en ", Edition))) +
      geom_bar_interactive(stat="identity", width=.6, size = 2, alpha = .9, position = position_dodge2(preserve = "single", padding = 0)) +
      coord_flip() +
      labs(x = "", y = "Pourcentage des répondants", 
           subtitle = "Comparaison des éditions <span style='color: #33bbc9; font-size: 23pt;'>2022</span> et <span style='color: #323465; font-size: 23pt;'>2023</span>",
           title = "Toutes les collectivités") +
      scale_x_discrete(labels = function(x) stringr::str_wrap(x, width = 40)) + 
      scale_y_continuous(labels = scales::percent, limits = c(0, max(table_total$Pourcentage)+.5*max(table_total$Pourcentage))) + # pourcentages
      scale_fill_manual(values = c("2022" = "#33bbc9", "2023" = "#323465")) +
      theme_classic() +
      custom_theme() +
      theme(legend.position = "none",
            panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb"),
            panel.grid.major.y = ggplot2::element_blank(),
            plot.subtitle = element_markdown()) +
      geom_text(aes(y = pos_ecart, x = Réponses, label = ifelse(is.na(ecart), NA, ifelse((ecart == "+1" | ecart == "-1" | ecart == "+0"), 
                                                                                         paste0(ecart, " point de \npourcentage"), 
                                                                                         paste0(ecart, " points de \npourcentage")))), 
                color = "#333333", size = 5, fill = "white", label.size = NA, 
                hjust = 0)
  #girafe(print(graph_total), width_svg = 11, height_svg = 7)
  graph_total
  
  
  # Graphique Total hors communes < 3500 hab.
    # data
  table_total_plus3500 <- table_all |> 
    filter(Structure == "Total hors communes < 3500 habitants")
    # viz
  graph_total_plus3500 <- table_total_plus3500 |> 
    ggplot(aes(x = Réponses, y = Pourcentage, fill = Edition, group = Edition,
               tooltip = paste0(Pourcentage*100, "% en ", Edition))) +
      geom_bar_interactive(stat="identity", width=.6, size = 2, alpha = .9, position = position_dodge2(preserve = "single", padding = 0)) +
      coord_flip() +
      labs(x = "", y = "Pourcentage des répondants", 
           subtitle = "Comparaison des éditions <span style='color: #33bbc9; font-size: 23pt;'>2022</span> et <span style='color: #323465; font-size: 23pt;'>2023</span>",
           title = "Total hors communes de moins \nde 3500 habitants") +
      scale_x_discrete(labels = function(x) stringr::str_wrap(x, width = 40)) + 
      scale_y_continuous(labels = scales::percent, limits = c(0, max(table_total$Pourcentage)+.5*max(table_total$Pourcentage))) + # pourcentages
      scale_fill_manual(values = c("2022" = "#33bbc9", "2023" = "#323465")) +
      theme_classic() +
      custom_theme() +
      theme(legend.position = "none",
            panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb"),
            panel.grid.major.y = ggplot2::element_blank(),
            plot.subtitle = element_markdown()) +
      geom_text(aes(y = pos_ecart, x = Réponses, label = ifelse(is.na(ecart), NA, ifelse((ecart == "+1" | ecart == "-1" | ecart == "+0"), 
                                                                                         paste0(ecart, " point de \npourcentage"), 
                                                                                         paste0(ecart, " points de \npourcentage")))), 
                color = "#333333", size = 5, fill = "white", label.size = NA, 
                hjust = 0)
  #girafe(print(graph_total), width_svg = 11, height_svg = 7)
  graph_total_plus3500

  # Graphique Collectivités
  graph_coll <- table_all |> 
    filter(Structure == "Une commune" | Structure == "Un EPCI" | Structure == "Un département" | 
             Structure == "Une région" | Structure == "Autre") |> 
    mutate(Structure = factor(Structure, levels = c("Autre","Une région","Un département","Un EPCI","Une commune"))) |> 
      ggplot(aes(x = Structure, y = Pourcentage, fill = Réponses,
                 text = paste0(Pourcentage*100, "% de réponses '", Réponses, "'"))) + 
        geom_bar(position = "fill", color = "white", stat="identity", alpha = .9) +
        labs(x = "", y = "Pourcentage de réponses", title = "Par type de collectivité") +
        scale_y_continuous(labels = scales::percent, limits = c(0,1)) +
        scale_fill_manual(values = c("grey", "#bf0001", "#e1b44d", "#33bbc9", "#323465", "#616165", "#0a0a14")) +
        facet_wrap(~Edition) +
        coord_flip() +
        theme_classic() +
        custom_theme() +
        guides(fill = guide_legend(nrow = 3, title = "", reverse = F)) +
            theme(legend.position = "none",
                  panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb"),
                  panel.grid.major.y = ggplot2::element_blank())
  #ggplotly(graph_coll, tooltip = "text")
  graph_coll
    
    # Graphique communes
  graph_comm <- table_all |> 
    filter(grepl("Communes de", Structure) == TRUE) |> 
    mutate(Structure = str_replace_all(Structure, c("Communes de " = "", "p" = "P", "m" = "M")),
           Structure = factor(Structure, levels = c("Plus de 100 000 hab.","10 000 à 100 000 hab.","3 500 à 10 000 hab.","Moins de 3 500 hab."))) |> 
      ggplot(aes(x = Structure, y = Pourcentage, fill = Réponses,
                 text = paste0(Pourcentage*100, "% de réponses '", Réponses, "'"))) + 
        geom_bar(position = "fill", color = "white", stat="identity", alpha = .9) +
        labs(x = "", y = "Pourcentage de réponses", title = "Par taille de commune") +
        scale_y_continuous(labels = scales::percent, limits = c(0,1)) +
        scale_fill_manual(values = c("grey", "#bf0001", "#e1b44d", "#33bbc9", "#323465", "#616165", "#0a0a14")) +
        facet_wrap(~Edition) +
        coord_flip() +
        theme_classic() +
        custom_theme() +
        guides(fill = guide_legend(nrow = 3, title = "", reverse = F)) +
            theme(legend.position = "none",
                  panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb"),
                  panel.grid.major.y = ggplot2::element_blank(),
                  axis.text.x = ggplot2::element_text(size = 18))
  #ggplotly(graph_comm, tooltip = "text")
  graph_comm

  # Légende
  graph_leg <- table_all |> 
  filter(Structure == "Une commune" | Structure == "Un EPCI" | Structure == "Un département" | 
           Structure == "Une région" | Structure == "Autre") |> 
  mutate(Structure = factor(Structure, levels = c("Autre","Une région","Un département","Un EPCI","Une commune"))) |> 
    ggplot(aes(x = Structure, y = Pourcentage, fill = Réponses,
               text = paste0(Pourcentage*100, "% de réponses '", Réponses, "'"))) + 
      geom_bar(position = "fill", color = "white", stat="identity", alpha = .9) +
      labs(x = "", y = "Pourcentage de réponses", title = "Par type de collectivité") +
      scale_y_continuous(labels = scales::percent, limits = c(0,1)) +
      scale_fill_manual(values = c("grey", "#bf0001", "#e1b44d", "#33bbc9", "#323465", "#616165", "#0a0a14")) +
      facet_wrap(~Edition) +
      coord_flip() +
      theme_classic() +
      custom_theme() +
      guides(fill = guide_legend(ncol = 1, title = "", reverse = T)) +
      theme(legend.position = "top",
                panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb"),
                panel.grid.major.y = ggplot2::element_blank())
   legend <- get_legend(graph_leg + theme(legend.box.margin = margin(0, 0, 10, 12)))

     
    # Tous ensemble
  left_part <- plot_grid(graph_total, graph_total_plus3500, ncol = 2)
  right_part <- plot_grid(graph_coll, graph_comm, ncol = 2)
  all <- plot_grid(left_part, right_part, ncol = 1)
  graph <- plot_grid(all, legend, nrow = 2, rel_heights = c(.9, .1))
  #grid::grid.draw(graph)
  
  #girafe(print(graph_total))
  #right_part <- subplot(G1, G2, nrows = 2)
  #right_part
    # Save graphe
  assign("graph", graph, envir = .GlobalEnv)
}


new_dataviz_comp <- function(all_stat, nom_col22, nom_col23){
  # Stats pour graphique
  table_all <- all_stat |> 
    filter((Question == nom_col22 | Question == nom_col23) & Réponses != "Sans réponse",
           Structure != "Total" & Structure != "Total pondéré"  & Structure != "Total hors communes < 3500 habitants" & Structure != "Une commune" & Structure != "Communes de moins de 3 500 hab." & Structure != "Autre") |> 
    mutate(occu_rep_quest = sum(Occurrences, na.rm = TRUE), .by = c(Réponses, Edition)) |> 
    distinct(Réponses, Edition, occu_rep_quest) |> 
    mutate(Pourcentage = case_when(Edition == "2022" ~ occu_rep_quest / 185, #297 total - 81 com moins de 3500 hab - 31 Autre
                                   Edition == "2023" ~ occu_rep_quest / 107)) |> #191 total - 9 com moins de 3500 hab - 75 Autre
    arrange(Réponses, Edition) |> 
    group_by(Réponses) |> 
    mutate(ecart = round((Pourcentage - lag(Pourcentage)) * 100, 0)) |> 
    mutate(pos_ecart = case_when(!is.na(ecart) ~ max(Pourcentage) + .02, .default = NA_real_)) |> 
    mutate(ecart = case_when(ecart >= 0 ~ paste0("+", ecart), .default = as.character(ecart)))

  # Graphique CT et EPCI sauf communes < 3500 hab.
  graph_hors3500 <- table_all |> 
    ggplot(aes(x = Réponses, y = Pourcentage, fill = Edition, group = Edition,
               tooltip = paste0(Pourcentage*100, "% en ", Edition))) +
      geom_bar_interactive(stat="identity", width=.6, size = 2, alpha = .9, position = position_dodge2(preserve = "single", padding = 0)) +
      coord_flip() +
      labs(x = "", y = "Pourcentage des répondants", 
           subtitle = "Comparaison des éditions <span style='color: #33bbc9; font-size: 23pt;'>2022</span> et <span style='color: #323465; font-size: 23pt;'>2023</span>",
           title = "Collectivités et EPCI sauf communes de \nmoins de 3500 habitants") +
      scale_x_discrete(labels = function(x) stringr::str_wrap(x, width = 40)) + 
      scale_y_continuous(labels = scales::percent, limits = c(0, max(table_all$Pourcentage)+.5*max(table_all$Pourcentage))) + # pourcentages
      scale_fill_manual(values = c("2022" = "#33bbc9", "2023" = "#323465")) +
      theme_classic() +
      custom_theme() +
      theme(legend.position = "none",
            panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb"),
            panel.grid.major.y = ggplot2::element_blank(),
            plot.subtitle = element_markdown()) +
      geom_text(aes(y = pos_ecart, x = Réponses, label = ifelse(is.na(ecart), NA, ifelse((ecart == "+1" | ecart == "-1" | ecart == "+0"), 
                                                                                         paste0(ecart, " point de \npourcentage"), 
                                                                                         paste0(ecart, " points de \npourcentage")))), 
                color = "#333333", size = 5, fill = "white", label.size = NA, 
                hjust = 0) +
      theme(plot.margin = margin(0, 1, 0, 0, "cm"))
  #girafe(print(graph_total), width_svg = 11, height_svg = 7)
  #graph_hors3500
  assign("graph", graph_hors3500, envir = .GlobalEnv)
}



dataviz_sansSR <- function(nom_col){
    # Fonction graph ensemble
    dat <- all_stat_2023 |> 
        filter(Question == nom_col & Structure == "Total",
               Réponses != "Sans réponse") |> 
      mutate(Pourcentage = round(Occurrences / `Nombre de réponses`* 100, 0))
    p0 <- dat |> 
        ggplot(aes(y=Occurrences, x=Réponses, fill = Réponses)) + 
            geom_bar(position="dodge", stat="identity", width=.6, size = 1, alpha = .9) +
            labs(x = "", y = "Nombre de réponses", 
                 title = paste("Toutes les collectivités,", dat$`Nombre de réponses`, "réponses")) +
            geom_label(aes(x = Réponses, y = Occurrences+1, label = paste0(Pourcentage, "%")), 
                       size = 8, fill = "white", label.size = NA, hjust = 0) +
            scale_fill_manual(values = c("grey", "#bf0001", "#e1b44d", "#33bbc9", "#323465", "#616165", "#0a0a14")) +
            scale_x_discrete(labels = function(x) stringr::str_wrap(x, width = 30)) +
            ylim(0, max(dat$Occurrences)+14) +
            coord_flip() +
            theme_classic() +
            custom_theme() +
            theme(legend.position = "none",
                  plot.title = element_text(hjust = 1),
                  panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb"),
                  panel.grid.major.y = ggplot2::element_blank())
    # Fonction graph total pondéré
    dat <- data_clean_unique |> 
        select(nom_col, Catégorie2) |> 
        summarise(n = n(), .by = c(Catégorie2, 1)) |> 
        pivot_wider(names_from = 2, values_from = 3) |>
        pivot_longer(cols = -Catégorie2, names_to = "cat", values_to = "n") |> 
        mutate_all(replace_na, replace = 0) |>
        filter(cat != "NA") |> 
        left_join(prop_all |> select(1, 6), by = c("Catégorie2" = "Structure")) |> 
        mutate(poids = case_when(is.na(poids) ~ 0, .default = poids),
               percent_normal = paste0(round(n / sum(n) *100, 0), "%"),
               .by = Catégorie2) |> 
        mutate(poids_CT = n * poids) |> 
        group_by(cat) |> 
        summarise(p=sum(poids_CT)) |> ungroup() |> 
        mutate(`Total pondéré`= round(p/sum(p)*100, 0)) |> 
        select(-p) |> 
        pivot_wider(names_from = 1, values_from = 2) |> 
        mutate(Catégorie = "Total pondéré", .before = 1) |> 
        pivot_longer(cols = -Catégorie, names_to = "Réponses", values_to = "Pourcentage")
    p0_pond <- dat |> 
        ggplot(aes(y=Pourcentage, x=Réponses, fill = Réponses)) + 
            geom_bar(position="dodge", stat="identity", width=.6, size = 1, alpha = .9) +
            labs(x = "", y = "Pourcentage de réponses", 
                 title = "Total pondéré") +
            geom_label(aes(x = Réponses, y = Pourcentage+1, label = paste0(Pourcentage, "%")), 
                       size = 8, fill = "white", label.size = NA, hjust = 0) +
            scale_fill_manual(values = c("grey", "#bf0001", "#e1b44d", "#33bbc9", "#323465", "#616165", "#0a0a14")) +
            scale_x_discrete(labels = function(x) stringr::str_wrap(x, width = 30)) +
            ylim(0, max(dat$Pourcentage)+14) +
            coord_flip() +
            theme_classic() +
            custom_theme() +
            theme(legend.position = "none",
                  panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb"),
                  panel.grid.major.y = ggplot2::element_blank())+
            guides(fill = guide_legend(title = "Légende", ncol = 1))
    # Fonction type de collectivité
    dat <- all_stat_2023 |> 
        filter(Question == nom_col & (Structure == "Une commune" | Structure == "Un EPCI (hors métropole)" | Structure == "Une métropole" | Structure == "Un département" | Structure == "Une région" | Structure == "Autre"),
               Réponses != "Sans réponse") |> 
        mutate(Pourcentage = round(Occurrences / `Nombre de réponses`* 100, 0)) |> 
        mutate(Pourcentage = as.numeric(Pourcentage)/100,
               Structure = factor(Structure, levels = c("Autre","Une région","Un département","Une métropole","Un EPCI (hors métropole)","Une commune")))
    p1 <- dat |> 
        ggplot(aes(fill=Réponses, y=Pourcentage, x=Structure)) + 
        geom_bar(position="fill", color = "white", stat="identity", alpha = .9) +
        labs(x = "", y = "Pourcentage de réponses", title = "Par type de collectivité") +
        scale_y_continuous(labels = scales::percent, limits = c(0,1)) +
        scale_fill_manual(values = c("grey", "#bf0001", "#e1b44d", "#33bbc9", "#323465", "#616165", "#0a0a14")) +
        coord_flip() +
        theme_classic() +
        custom_theme() +
        guides(fill = guide_legend(nrow = 3, title = "", reverse = T)) +
            theme(legend.position = "none",
                  panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb"),
                  panel.grid.major.y = ggplot2::element_blank())
    # Fonction taille de commune
    dat <- all_stat_2023 |> 
        filter(Question == nom_col & grepl("Communes de", Structure) == TRUE,
               Réponses != "Sans réponse") |> 
        mutate(Pourcentage = round(Occurrences / `Nombre de réponses`* 100, 0)) |> 
        mutate(Pourcentage = as.numeric(Pourcentage)/100,
               Structure = str_replace_all(Structure, c("Communes de " = "", "p" = "P", "m" = "M")),
               Structure = factor(Structure, levels = c("Plus de 100 000 hab.","10 000 à 100 000 hab.","3 500 à 10 000 hab.","Moins de 3 500 hab.")))
    p2 <- dat |> 
        ggplot(aes(fill=Réponses, y=Pourcentage, x=Structure)) + 
        geom_bar(position="fill", color = "white", stat="identity", alpha = .9) +
        labs(x = "", y = "Pourcentage de réponses", title = "Par taille de commune") +
        scale_y_continuous(labels = scales::percent, limits = c(0,1)) +
        scale_fill_manual(values = c("grey", "#bf0001", "#e1b44d", "#33bbc9", "#323465", "#616165", "#0a0a14")) +
        coord_flip() +
        theme_classic() +
        custom_theme() +
        guides(fill = guide_legend(nrow = 3, title = "", reverse = T)) +
        theme(legend.position = "none",
              panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb"),
              panel.grid.major.y = ggplot2::element_blank())
    # Légende
    p3 <- dat |> 
        ggplot(aes(fill=Réponses, y=Pourcentage, x=Structure)) + 
        geom_bar(position="fill", color = "white", stat="identity", alpha = .9) +
        labs(x = "", y = "Pourcentage de réponses", title = "Par taille de commune", fill = "légende") +
        scale_y_continuous(labels = scales::percent, limits = c(0,1)) +
        scale_fill_manual(values = c("grey", "#bf0001", "#e1b44d", "#33bbc9", "#323465", "#616165", "#0a0a14")) +
        coord_flip() +
        theme_classic() +
        custom_theme() +
        guides(fill = guide_legend(ncol = 1, title = "", reverse = T)) +
        theme(legend.position = "top",
              panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb"),
              panel.grid.major.y = ggplot2::element_blank())
     legend <- get_legend(p3 + theme(legend.box.margin = margin(0, 0, 10, 12)))
    # All
    left_part <- plot_grid(p0, p0_pond, ncol = 1)
    right_part <- plot_grid(p1, p2, ncol = 1)
    all_plots <- plot_grid(left_part, right_part, ncol = 2)
    graph <- plot_grid(all_plots, legend, nrow = 2, rel_heights = c(.9, .1))
    assign("graph", graph, envir = .GlobalEnv)
    #grid::grid.draw(graph)
}


dataviz_comp_sansSR <- function(all_stat, nom_col22, nom_col23){
  # Stats pour graphique
  table_all <- all_stat |> 
    filter((Question == nom_col22 | Question == nom_col23) & Réponses != "Sans réponse") |> 
    arrange(Structure, Réponses, Edition) |> 
    group_by(Structure, Réponses) |> 
    mutate(Pourcentage = Occurrences / `Nombre de réponses` * 100,
           ecart = round(Pourcentage - lag(Pourcentage),0),
           Pourcentage = round(Pourcentage /100, 2)) |> 
    mutate(pos_ecart = case_when(!is.na(ecart) ~ max(Pourcentage) + .02, .default = NA_real_)) |> 
    mutate(ecart = case_when(ecart >= 0 ~ paste0("+", ecart), .default = as.character(ecart)))
    
  
  # Graphique Total
    # data
  table_total <- table_all |> 
    filter(Structure == "Total")
    # viz
  graph_total <- table_total |> 
    ggplot(aes(x = Réponses, y = Pourcentage, fill = Edition, group = Edition,
               tooltip = paste0(Pourcentage*100, "% en ", Edition))) +
      geom_bar_interactive(stat="identity", width=.6, size = 2, alpha = .9, position = position_dodge2(preserve = "single", padding = 0)) +
      coord_flip() +
      labs(x = "", y = "Pourcentage des répondants", 
           subtitle = "Comparaison des éditions <span style='color: #33bbc9; font-size: 23pt;'>2022</span> et <span style='color: #323465; font-size: 23pt;'>2023</span>",
           title = "Toutes les collectivités") +
      scale_x_discrete(labels = function(x) stringr::str_wrap(x, width = 40)) + 
      scale_y_continuous(labels = scales::percent, limits = c(0, max(table_total$Pourcentage)+.5*max(table_total$Pourcentage))) + # pourcentages
      scale_fill_manual(values = c("2022" = "#33bbc9", "2023" = "#323465")) +
      theme_classic() +
      custom_theme() +
      theme(legend.position = "none",
            panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb"),
            panel.grid.major.y = ggplot2::element_blank(),
            plot.subtitle = element_markdown()) +
      geom_text(aes(y = pos_ecart, x = Réponses, label = ifelse(is.na(ecart), NA, ifelse((ecart == "+1" | ecart == "-1" | ecart == "+0"), 
                                                                                         paste0(ecart, " point de \npourcentage"), 
                                                                                         paste0(ecart, " points de \npourcentage")))), 
                color = "#333333", size = 5, fill = "white", label.size = NA, 
                hjust = 0)
  #girafe(print(graph_total), width_svg = 11, height_svg = 7)
  graph_total
  
  
  # Graphique Total hors communes < 3500 hab.
    # data
  table_total_plus3500 <- table_all |> 
    filter(Structure == "Total hors communes < 3500 habitants")
    # viz
  graph_total_plus3500 <- table_total_plus3500 |> 
    ggplot(aes(x = Réponses, y = Pourcentage, fill = Edition, group = Edition,
               tooltip = paste0(Pourcentage*100, "% en ", Edition))) +
      geom_bar_interactive(stat="identity", width=.6, size = 2, alpha = .9, position = position_dodge2(preserve = "single", padding = 0)) +
      coord_flip() +
      labs(x = "", y = "Pourcentage des répondants", 
           subtitle = "Comparaison des éditions <span style='color: #33bbc9; font-size: 23pt;'>2022</span> et <span style='color: #323465; font-size: 23pt;'>2023</span>",
           title = "Total hors communes de moins \nde 3500 habitants") +
      scale_x_discrete(labels = function(x) stringr::str_wrap(x, width = 40)) + 
      scale_y_continuous(labels = scales::percent, limits = c(0, max(table_total$Pourcentage)+.5*max(table_total$Pourcentage))) + # pourcentages
      scale_fill_manual(values = c("2022" = "#33bbc9", "2023" = "#323465")) +
      theme_classic() +
      custom_theme() +
      theme(legend.position = "none",
            panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb"),
            panel.grid.major.y = ggplot2::element_blank(),
            plot.subtitle = element_markdown()) +
      geom_text(aes(y = pos_ecart, x = Réponses, label = ifelse(is.na(ecart), NA, ifelse((ecart == "+1" | ecart == "-1" | ecart == "+0"), 
                                                                                         paste0(ecart, " point de \npourcentage"), 
                                                                                         paste0(ecart, " points de \npourcentage")))), 
                color = "#333333", size = 5, fill = "white", label.size = NA, 
                hjust = 0)
  #girafe(print(graph_total), width_svg = 11, height_svg = 7)
  graph_total_plus3500

  # Graphique Collectivités
  graph_coll <- table_all |> 
    filter(Structure == "Une commune" | Structure == "Un EPCI" | Structure == "Un département" | 
             Structure == "Une région" | Structure == "Autre") |> 
    mutate(Structure = factor(Structure, levels = c("Autre","Une région","Un département","Un EPCI","Une commune"))) |> 
      ggplot(aes(x = Structure, y = Pourcentage, fill = Réponses,
                 text = paste0(Pourcentage*100, "% de réponses '", Réponses, "'"))) + 
        geom_bar(position = "fill", color = "white", stat="identity", alpha = .9) +
        labs(x = "", y = "Pourcentage de réponses", title = "Par type de collectivité") +
        scale_y_continuous(labels = scales::percent, limits = c(0,1)) +
        scale_fill_manual(values = c("grey", "#bf0001", "#e1b44d", "#33bbc9", "#323465", "#616165", "#0a0a14")) +
        facet_wrap(~Edition) +
        coord_flip() +
        theme_classic() +
        custom_theme() +
        guides(fill = guide_legend(nrow = 3, title = "", reverse = F)) +
            theme(legend.position = "none",
                  panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb"),
                  panel.grid.major.y = ggplot2::element_blank())
  #ggplotly(graph_coll, tooltip = "text")
  graph_coll
    
    # Graphique communes
  graph_comm <- table_all |> 
    filter(grepl("Communes de", Structure) == TRUE) |> 
    mutate(Structure = str_replace_all(Structure, c("Communes de " = "", "p" = "P", "m" = "M")),
           Structure = factor(Structure, levels = c("Plus de 100 000 hab.","10 000 à 100 000 hab.","3 500 à 10 000 hab.","Moins de 3 500 hab."))) |> 
      ggplot(aes(x = Structure, y = Pourcentage, fill = Réponses,
                 text = paste0(Pourcentage*100, "% de réponses '", Réponses, "'"))) + 
        geom_bar(position = "fill", color = "white", stat="identity", alpha = .9) +
        labs(x = "", y = "Pourcentage de réponses", title = "Par taille de commune") +
        scale_y_continuous(labels = scales::percent, limits = c(0,1)) +
        scale_fill_manual(values = c("grey", "#bf0001", "#e1b44d", "#33bbc9", "#323465", "#616165", "#0a0a14")) +
        facet_wrap(~Edition) +
        coord_flip() +
        theme_classic() +
        custom_theme() +
        guides(fill = guide_legend(nrow = 3, title = "", reverse = F)) +
            theme(legend.position = "none",
                  panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb"),
                  panel.grid.major.y = ggplot2::element_blank(),
                  axis.text.x = ggplot2::element_text(size = 18))
  #ggplotly(graph_comm, tooltip = "text")
  graph_comm

  # Légende
  graph_leg <- table_all |> 
  filter(Structure == "Une commune" | Structure == "Un EPCI" | Structure == "Un département" | 
           Structure == "Une région" | Structure == "Autre") |> 
  mutate(Structure = factor(Structure, levels = c("Autre","Une région","Un département","Un EPCI","Une commune"))) |> 
    ggplot(aes(x = Structure, y = Pourcentage, fill = Réponses,
               text = paste0(Pourcentage*100, "% de réponses '", Réponses, "'"))) + 
      geom_bar(position = "fill", color = "white", stat="identity", alpha = .9) +
      labs(x = "", y = "Pourcentage de réponses", title = "Par type de collectivité") +
      scale_y_continuous(labels = scales::percent, limits = c(0,1)) +
      scale_fill_manual(values = c("grey", "#bf0001", "#e1b44d", "#33bbc9", "#323465", "#616165", "#0a0a14")) +
      facet_wrap(~Edition) +
      coord_flip() +
      theme_classic() +
      custom_theme() +
      guides(fill = guide_legend(ncol = 1, title = "", reverse = T)) +
      theme(legend.position = "top",
                panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb"),
                panel.grid.major.y = ggplot2::element_blank())
   legend <- get_legend(graph_leg + theme(legend.box.margin = margin(0, 0, 10, 12)))

     
    # Tous ensemble
  left_part <- plot_grid(graph_total, graph_total_plus3500, ncol = 2)
  right_part <- plot_grid(graph_coll, graph_comm, ncol = 2)
  all <- plot_grid(left_part, right_part, ncol = 1)
  graph <- plot_grid(all, legend, nrow = 2, rel_heights = c(.9, .1))
  #grid::grid.draw(graph)
  
  #girafe(print(graph_total))
  #right_part <- subplot(G1, G2, nrows = 2)
  #right_part
    # Save graphe
  assign("graph", graph, envir = .GlobalEnv)
}


new_dataviz_comp_sansSR <- function(all_stat, nom_col22, nom_col23){
  # Stats pour graphique
  table_all <- all_stat |> 
    filter((Question == nom_col22 | Question == nom_col23) & Réponses != "Sans réponse",
           Structure != "Total" & Structure != "Total pondéré"  & Structure != "Total hors communes < 3500 habitants" & Structure != "Une commune" & Structure != "Communes de moins de 3 500 hab." & Structure != "Autre") |> 
    mutate(occu_rep_quest = sum(Occurrences, na.rm = TRUE),
           Pourcentage = occu_rep_quest / sum(`Nombre de réponses`, na.rm=T), .by = c(Réponses, Edition)) |> 
    distinct(Réponses, Edition, Pourcentage) |> 
    arrange(Réponses, Edition) |> 
    group_by(Réponses) |> 
    mutate(ecart = round((Pourcentage - lag(Pourcentage)) * 100, 0)) |> 
    mutate(pos_ecart = case_when(!is.na(ecart) ~ max(Pourcentage) + .02, .default = NA_real_)) |> 
    mutate(ecart = case_when(ecart >= 0 ~ paste0("+", ecart), .default = as.character(ecart)))

  # Graphique CT et EPCI sauf communes < 3500 hab.
  graph_hors3500 <- table_all |> 
    ggplot(aes(x = Réponses, y = Pourcentage, fill = Edition, group = Edition,
               tooltip = paste0(Pourcentage*100, "% en ", Edition))) +
      geom_bar_interactive(stat="identity", width=.6, size = 2, alpha = .9, position = position_dodge2(preserve = "single", padding = 0)) +
      coord_flip() +
      labs(x = "", y = "Pourcentage des répondants", 
           subtitle = "Comparaison des éditions <span style='color: #33bbc9; font-size: 23pt;'>2022</span> et <span style='color: #323465; font-size: 23pt;'>2023</span>",
           title = "Collectivités et EPCI sauf communes de \nmoins de 3500 habitants") +
      scale_x_discrete(labels = function(x) stringr::str_wrap(x, width = 40)) + 
      scale_y_continuous(labels = scales::percent, limits = c(0, max(table_all$Pourcentage)+.5*max(table_all$Pourcentage))) + # pourcentages
      scale_fill_manual(values = c("2022" = "#33bbc9", "2023" = "#323465")) +
      theme_classic() +
      custom_theme() +
      theme(legend.position = "none",
            panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb"),
            panel.grid.major.y = ggplot2::element_blank(),
            plot.subtitle = element_markdown()) +
      geom_text(aes(y = pos_ecart, x = Réponses, label = ifelse(is.na(ecart), NA, ifelse((ecart == "+1" | ecart == "-1" | ecart == "+0"), 
                                                                                         paste0(ecart, " point de \npourcentage"), 
                                                                                         paste0(ecart, " points de \npourcentage")))), 
                color = "#333333", size = 5, fill = "white", label.size = NA, 
                hjust = 0) +
      theme(plot.margin = margin(0, 1, 0, 0, "cm"))
  #girafe(print(graph_total), width_svg = 11, height_svg = 7)
  #graph_hors3500
  assign("graph", graph_hors3500, envir = .GlobalEnv)
}



#----------------------------------------------------

# Export des graphiques
dataviz_sansSR("De manière générale, avez-vous mis en place des clauses juridiques sur la gestion des données dans les contrats de délégation et dans les marchés publics ?")
saving_plot(graph, "De manière générale, avez-vous mis en place des clauses juridiques sur la gestion des données dans les contrats de délégation et dans les marchés publics ?")

dataviz_comp_sansSR(all_stat,"De manière générale, avez-vous mis en place des clauses juridiques sur la gestion des données dans les contrats de délégation et dans les marchés publics ?",
             "De manière générale, avez-vous mis en place des clauses juridiques sur la gestion des données dans les contrats de délégation et dans les marchés publics ?")
saving_plot_comp(graph, "De manière générale, avez-vous mis en place des clauses juridiques sur la gestion des données dans les contrats de délégation et dans les marchés publics ?")

new_dataviz_comp_sansSR(all_stat, "De manière générale, avez-vous mis en place des clauses juridiques sur la gestion des données dans les contrats de délégation et dans les marchés publics ?",
             "De manière générale, avez-vous mis en place des clauses juridiques sur la gestion des données dans les contrats de délégation et dans les marchés publics ?")
saving_newplot(graph, "De manière générale, avez-vous mis en place des clauses juridiques sur la gestion des données dans les contrats de délégation et dans les marchés publics ?")

dataviz_comp_sansSR(all_stat,"Quels sont le ou les domaines concernés par ces clauses ?",
             "Quels sont le ou les domaines concernés par ces clauses ?")
saving_plot_comp(graph, "Quels sont le ou les domaines concernés par ces clauses ?")

new_dataviz_comp_sansSR(all_stat, "Quels sont le ou les domaines concernés par ces clauses ?",
             "Quels sont le ou les domaines concernés par ces clauses ?")
saving_newplot(graph, "Quels sont le ou les domaines concernés par ces clauses ?")

dataviz_sansSR("La question de la souveraineté numérique préoccupe de plus en plus d'acteurs publics : choix des éditeurs de logiciels, hébergement des données en Europe ou en France, maîtrise des données par la collectivité... Votre organisation a-t-elle défini une politique en matière de souveraineté publique sur les données ?")
saving_plot(graph, "Votre organisation a-t-elle défini une politique en matière de souveraineté publique sur les données ?")

dataviz_comp_sansSR(all_stat,"La question de la souveraineté numérique préoccupe de plus en plus d'acteurs publics : choix des éditeurs de logiciels, hébergement des données en Europe ou en France, maîtrise des données par la collectivité... Votre collectivité a-t-elle défini une politique en matière de souveraineté publique sur les données ?",
             "La question de la souveraineté numérique préoccupe de plus en plus d'acteurs publics : choix des éditeurs de logiciels, hébergement des données en Europe ou en France, maîtrise des données par la collectivité... Votre organisation a-t-elle défini une politique en matière de souveraineté publique sur les données ?")
saving_plot_comp(graph, "Votre organisation a-t-elle défini une politique en matière de souveraineté publique sur les données ?")

new_dataviz_comp_sansSR(all_stat, "La question de la souveraineté numérique préoccupe de plus en plus d'acteurs publics : choix des éditeurs de logiciels, hébergement des données en Europe ou en France, maîtrise des données par la collectivité... Votre collectivité a-t-elle défini une politique en matière de souveraineté publique sur les données ?",
             "La question de la souveraineté numérique préoccupe de plus en plus d'acteurs publics : choix des éditeurs de logiciels, hébergement des données en Europe ou en France, maîtrise des données par la collectivité... Votre organisation a-t-elle défini une politique en matière de souveraineté publique sur les données ?")
saving_newplot(graph, "Votre organisation a-t-elle défini une politique en matière de souveraineté publique sur les données ?")

dataviz_sansSR("Pour chacun de ces domaines, pouvez-vous préciser si votre structure a engagé ces deux dernières années un ou plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Energie et éclairage]")
saving_plot(graph, "Pouvez-vous préciser si votre structure a engagé plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Energie et éclairage]")

dataviz_sansSR("Selon-vous, la maîtrise de la donnée constitue-t-elle un outil pertinent pour répondre aux enjeux environnementaux de votre territoire ?")
saving_plot(graph, "Selon-vous, la maîtrise de la donnée constitue-t-elle un outil pertinent pour répondre aux enjeux environnementaux de votre territoire ?")

dataviz_sansSR("Comment estimez-vous le niveau d’acculturation de votre structure aux enjeux des données ?")
saving_plot(graph, "Comment estimez-vous le niveau d’acculturation de votre structure aux enjeux des données ?")

all_stat |> 
  mutate(Réponses = str_replace_all(Réponses, "collectivité", "structure")) |> 
  dataviz_comp_sansSR("Comment estimez-vous le niveau d’acculturation de votre collectivité aux enjeux des données ?",
             "Comment estimez-vous le niveau d’acculturation de votre structure aux enjeux des données ?")
saving_plot_comp(graph, "Comment estimez-vous le niveau d’acculturation de votre structure aux enjeux des données ?")

all_stat |> 
  mutate(Réponses = str_replace_all(Réponses, "collectivité", "structure")) |> 
  new_dataviz_comp_sansSR("Comment estimez-vous le niveau d’acculturation de votre collectivité aux enjeux des données ?",
             "Comment estimez-vous le niveau d’acculturation de votre structure aux enjeux des données ?")
saving_newplot(graph, "Comment estimez-vous le niveau d’acculturation de votre structure aux enjeux des données ?")

dataviz_sansSR("Dans votre organisation, ces fonctions consacrées à la donnée existent-elles ou seront-elles créées dans les douze prochains mois ?  [Comité data]")
saving_plot(graph, "Dans votre organisation, ces fonctions consacrées à la donnée existent-elles ou seront-elles créées dans les douze prochains mois ?  [Comité data]")

dataviz_sansSR("Dans votre organisation, ces fonctions consacrées à la donnée existent-elles ou seront-elles créées dans les douze prochains mois ?  [Réseau de référent(e)s data]")
saving_plot(graph, "Dans votre organisation, ces fonctions consacrées à la donnée existent-elles ou seront-elles créées dans les douze prochains mois ?  [Réseau de référent(e)s data]")

dataviz_sansSR("Dans votre organisation, ces fonctions consacrées à la donnée existent-elles ou seront-elles créées dans les douze prochains mois ?  [Direction de la donnée]")
saving_plot(graph, "Dans votre organisation, ces fonctions consacrées à la donnée existent-elles ou seront-elles créées dans les douze prochains mois ?  [Direction de la donnée]")

dataviz_sansSR("Dans votre organisation, ces fonctions consacrées à la donnée existent-elles ou seront-elles créées dans les douze prochains mois ?  [Chief data officer / administrateur général des données]")
saving_plot(graph, "Dans votre organisation, ces fonctions consacrées à la donnée existent-elles ou seront-elles créées dans les douze prochains mois ?  [Chief data officer - administrateur général des données]")

dataviz_sansSR("Depuis le 1er juillet 2020, les collectivités sont également soumises à une obligation de « transparence algorithmique ». Pensez-vous que les services de votre structure sont bien informés de cette obligation légale ?")
saving_plot(graph, "Depuis le 1er juillet 2020, les collectivités sont également soumises à une obligation de « transparence algorithmique ». Pensez-vous que les services de votre structure sont bien informés de cette obligation légale ?")

all_stat |> 
  dataviz_comp_sansSR("Depuis le 1er juillet 2020, les collectivités sont également soumises à une obligation de « transparence algorithmique ». Pensez-vous que les services de votre collectivité sont bien informés de cette obligation légale ?",
             "Depuis le 1er juillet 2020, les collectivités sont également soumises à une obligation de « transparence algorithmique ». Pensez-vous que les services de votre structure sont bien informés de cette obligation légale ?")
saving_plot_comp(graph, "Depuis le 1er juillet 2020, les collectivités sont également soumises à une obligation de « transparence algorithmique ». Pensez-vous que les services de votre structure sont bien informés de cette obligation légale ?")

new_dataviz_comp_sansSR(all_stat, "Depuis le 1er juillet 2020, les collectivités sont également soumises à une obligation de « transparence algorithmique ». Pensez-vous que les services de votre collectivité sont bien informés de cette obligation légale ?",
             "Depuis le 1er juillet 2020, les collectivités sont également soumises à une obligation de « transparence algorithmique ». Pensez-vous que les services de votre structure sont bien informés de cette obligation légale ?")
saving_newplot(graph, "Pensez-vous que les services de votre structure sont bien informés de cette obligation légale ?")

dataviz_sansSR("Aujourd’hui, les données de votre structure sont majoritairement hébergées :")
saving_plot(graph, "Aujourd’hui, les données de votre structure sont majoritairement hébergées")

dataviz_comp_sansSR(all_stat,"Aujourd’hui, les données de votre collectivité sont majoritairement hébergées :",
             "Aujourd’hui, les données de votre structure sont majoritairement hébergées :")
saving_plot_comp(graph, "Aujourd’hui, les données de votre structure sont majoritairement hébergées")

new_dataviz_comp_sansSR(all_stat, "Aujourd’hui, les données de votre collectivité sont majoritairement hébergées :",
             "Aujourd’hui, les données de votre structure sont majoritairement hébergées :")
saving_newplot(graph, "Aujourd’hui, les données de votre structure sont majoritairement hébergées")


# 3.1

dataviz_sansSR("Pour chacun de ces domaines, pouvez-vous préciser si votre structure a engagé ces deux dernières années un ou plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Autre]")
saving_plot(graph, "Pouvez-vous préciser si votre structure a engagé plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Autre]")

dataviz_sansSR("Pour chacun de ces domaines, pouvez-vous préciser si votre structure a engagé ces deux dernières années un ou plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Environnement]")
saving_plot(graph, "Pouvez-vous préciser si votre structure a engagé plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Environnement]")

dataviz_sansSR("Pour chacun de ces domaines, pouvez-vous préciser si votre structure a engagé ces deux dernières années un ou plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Citoyenneté]")
saving_plot(graph, "Pouvez-vous préciser si votre structure a engagé plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Citoyenneté]")

dataviz_sansSR("Pour chacun de ces domaines, pouvez-vous préciser si votre structure a engagé ces deux dernières années un ou plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Tourisme]")
saving_plot(graph, "Pouvez-vous préciser si votre structure a engagé plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Tourisme]")

dataviz_sansSR("Pour chacun de ces domaines, pouvez-vous préciser si votre structure a engagé ces deux dernières années un ou plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Déchets]")
saving_plot(graph, "Pouvez-vous préciser si votre structure a engagé plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Déchets]")

dataviz_sansSR("Pour chacun de ces domaines, pouvez-vous préciser si votre structure a engagé ces deux dernières années un ou plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Patrimoine]")
saving_plot(graph, "Pouvez-vous préciser si votre structure a engagé plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Patrimoine]")

dataviz_sansSR("Pour chacun de ces domaines, pouvez-vous préciser si votre structure a engagé ces deux dernières années un ou plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Sécurité]")
saving_plot(graph, "Pouvez-vous préciser si votre structure a engagé plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Sécurité]")

dataviz_sansSR("Pour chacun de ces domaines, pouvez-vous préciser si votre structure a engagé ces deux dernières années un ou plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Gestion de l’espace public]")
saving_plot(graph, "Pouvez-vous préciser si votre structure a engagé plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Gestion de l’espace public]")

dataviz_sansSR("Pour chacun de ces domaines, pouvez-vous préciser si votre structure a engagé ces deux dernières années un ou plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Développement économique]")
saving_plot(graph, "Pouvez-vous préciser si votre structure a engagé plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Développement économique]")

dataviz_sansSR("Pour chacun de ces domaines, pouvez-vous préciser si votre structure a engagé ces deux dernières années un ou plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Administration]")
saving_plot(graph, "Pouvez-vous préciser si votre structure a engagé plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Administration]")

dataviz_sansSR("Pour chacun de ces domaines, pouvez-vous préciser si votre structure a engagé ces deux dernières années un ou plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Mobilité]")
saving_plot(graph, "Pouvez-vous préciser si votre structure a engagé plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Mobilité]")

dataviz_sansSR("Pour chacun de ces domaines, pouvez-vous préciser si votre structure a engagé ces deux dernières années un ou plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Aménagement du territoire]")
saving_plot(graph, "Pouvez-vous préciser si votre structure a engagé plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Aménagement du territoire]")

dataviz_sansSR("Afin de respecter le RGPD, avez-vous modifié des processus de gestion des données au sein de l'organisation ?")
saving_plot(graph, "Afin de respecter le RGPD, avez-vous modifié des processus de gestion des données au sein de l'organisation ?")












