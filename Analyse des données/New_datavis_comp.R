new_dataviz_comp(all_stat,"Commençons par la protection de la vie privée. Considérez-vous que votre structure est en conformité avec le RGPD ?",
             "Commençons par la protection de la vie privée. Considérez-vous que votre collectivité est en conformité avec le RGPD ?")
saving_newplot(graph, "Commençons par la protection de la vie privée. Considérez-vous que votre structure est en conformité avec le RGPD ?")

new_dataviz_comp(all_stat, "Avez-vous nommé un(e) Délégué(e) à la Protection des Données (DPO) ?",
             "Avez-vous nommé un(e) Délégué(e) à la Protection des Données (DPO) ?")
saving_newplot(graph, "Avez-vous nommé un(e) Délégué(e) à la Protection des Données (DPO) ?")

new_dataviz_comp(all_stat, "Afin de respecter le RGPD, avez-vous modifié des processus de gestion des données au sein de la collectivité ?",
             "Afin de respecter le RGPD, avez-vous modifié des processus de gestion des données au sein de l'organisation ?")
saving_newplot(graph, "Afin de respecter le RGPD, avez-vous modifié des processus de gestion des données au sein de l'organisation ?")

new_dataviz_comp(all_stat, "De manière générale, avez-vous mis en place des clauses juridiques sur la gestion des données dans les contrats de délégation et dans les marchés publics ?",
             "De manière générale, avez-vous mis en place des clauses juridiques sur la gestion des données dans les contrats de délégation et dans les marchés publics ?")
saving_newplot(graph, "De manière générale, avez-vous mis en place des clauses juridiques sur la gestion des données dans les contrats de délégation et dans les marchés publics ?")

new_dataviz_comp(all_stat, "Quels sont le ou les domaines concernés par ces clauses ?",
             "Quels sont le ou les domaines concernés par ces clauses ?")
saving_newplot(graph, "Quels sont le ou les domaines concernés par ces clauses ?")

new_dataviz_comp(all_stat, "La question de la souveraineté numérique préoccupe de plus en plus d'acteurs publics : choix des éditeurs de logiciels, hébergement des données en Europe ou en France, maîtrise des données par la collectivité... Votre collectivité a-t-elle défini une politique en matière de souveraineté publique sur les données ?",
             "La question de la souveraineté numérique préoccupe de plus en plus d'acteurs publics : choix des éditeurs de logiciels, hébergement des données en Europe ou en France, maîtrise des données par la collectivité... Votre organisation a-t-elle défini une politique en matière de souveraineté publique sur les données ?")
saving_newplot(graph, "Votre organisation a-t-elle défini une politique en matière de souveraineté publique sur les données ?")

new_dataviz_comp(all_stat, "Votre structure a-t-elle défini des règles de gouvernance de la donnée (internes ou externes) ? ",
             "Votre collectivité a-t-elle défini des règles de gouvernance de la donnée (internes ou externes) ? ")
saving_newplot(graph, "Votre structure a-t-elle défini des règles de gouvernance de la donnée (internes ou externes) ?")

new_dataviz_comp(all_stat, "Votre structure a-t-elle adopté une charte éthique de la donnée ?",
             "Votre collectivité a-t-elle élaboré une charte éthique de la donnée ?")
saving_newplot(graph, "Votre structure a-t-elle adopté une charte éthique de la donnée ?")

all_stat |> 
  mutate(Réponses = str_replace_all(Réponses, "collectivité", "structure")) |> 
  new_dataviz_comp("Comment estimez-vous le niveau d’acculturation de votre collectivité aux enjeux des données ?",
             "Comment estimez-vous le niveau d’acculturation de votre structure aux enjeux des données ?")
saving_newplot(graph, "Comment estimez-vous le niveau d’acculturation de votre structure aux enjeux des données ?")

new_dataviz_comp(all_stat, "Quels sont, selon vous, les principaux obstacles à la diffusion d’outils innovants en matière de gestion des données ?",
             "Quels sont, selon vous, les principaux obstacles à la diffusion d’outils innovants en matière de gestion des données ?")
saving_newplot(graph, "Quels sont, selon vous, les principaux obstacles à la diffusion d’outils innovants en matière de gestion des données ?")

new_dataviz_comp(all_stat, "En matière de formation sur la gestion des données, quels sont, selon vous, les besoins prioritaires pour votre collectivité ?",
             "En matière de formation sur la gestion des données, quels sont, selon vous, les besoins prioritaires pour votre structure ?")
ggsave(file = glue("../Graphiques/PNG/Comparaison 2022-2023 CT et EPCI hors com<3500 hab : En matière de formation sur la gestion des données, quels sont, selon vous, les besoins prioritaires pour votre structure ?.png"), plot = graph, width = 13, height = 8)

all_stat |> 
  mutate(Réponses = str_replace_all(Réponses, "Cette direction n'existe pas dans ma collectivité", "Cette direction n'existe pas dans ma structure")) |> 
new_dataviz_comp("Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est :  [Direction générale]",
             "Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est : [Direction générale]")
ggsave(file = glue("../Graphiques/PNG/Comparaison 2022-2023 CT et EPCI hors com<3500 hab : Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est : [Direction générale].png"), plot = graph, width = 25, height = 18)
ggsave(file = glue("../Graphiques/SVG/Comparaison 2022-2023 CT et EPCI hors com<3500 hab : Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est : [Direction générale].svg"), plot = graph, width = 25, height = 18)

all_stat |> 
  mutate(Réponses = str_replace_all(Réponses, "Cette direction n'existe pas dans ma collectivité", "Cette direction n'existe pas dans ma structure")) |> 
new_dataviz_comp("Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est :  [Direction Informatique]",
             "Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est : [Direction Informatique]")
ggsave(file = glue("../Graphiques/PNG/Comparaison 2022-2023 CT et EPCI hors com<3500 hab : Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est : [Direction Informatique].png"), plot = graph, width = 25, height = 18)
ggsave(file = glue("../Graphiques/SVG/Comparaison 2022-2023 CT et EPCI hors com<3500 hab : Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est : [Direction Informatique].svg"), plot = graph, width = 25, height = 18)

all_stat |> 
  mutate(Réponses = str_replace_all(Réponses, "Cette direction n'existe pas dans ma collectivité", "Cette direction n'existe pas dans ma structure")) |> 
new_dataviz_comp("Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est :  [Service d’information géographique (SIG)]",
             "Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est : [Service d’information géographique (SIG)]")
ggsave(file = glue("../Graphiques/PNG/Comparaison 2022-2023 CT et EPCI hors com<3500 hab : Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est : [Service d’information géographique (SIG)].png"), plot = graph, width = 25, height = 18)
ggsave(file = glue("../Graphiques/SVG/Comparaison 2022-2023 CT et EPCI hors com<3500 hab : Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est : [Service d’information géographique (SIG)].svg"), plot = graph, width = 25, height = 18)

all_stat |> 
  mutate(Réponses = str_replace_all(Réponses, "Cette direction n'existe pas dans ma collectivité", "Cette direction n'existe pas dans ma structure")) |> 
new_dataviz_comp("Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est :  [Archives]",
             "Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est : [Archives]")
ggsave(file = glue("../Graphiques/PNG/Comparaison 2022-2023 CT et EPCI hors com<3500 hab : Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est : [Archives].png"), plot = graph, width = 25, height = 18)
ggsave(file = glue("../Graphiques/SVG/Comparaison 2022-2023 CT et EPCI hors com<3500 hab : Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est : [Archives].svg"), plot = graph, width = 25, height = 18)

all_stat |> 
  mutate(Réponses = str_replace_all(Réponses, "Cette direction n'existe pas dans ma collectivité", "Cette direction n'existe pas dans ma structure")) |> 
new_dataviz_comp("Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est :  [Communication]",
             "Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est : [Communication]")
ggsave(file = glue("../Graphiques/PNG/Comparaison 2022-2023 CT et EPCI hors com<3500 hab : Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est : [Communication].png"), plot = graph, width = 25, height = 18)
ggsave(file = glue("../Graphiques/SVG/Comparaison 2022-2023 CT et EPCI hors com<3500 hab : Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est : [Communication].svg"), plot = graph, width = 25, height = 18)

all_stat |> 
  mutate(Réponses = str_replace_all(Réponses, "Cette direction n'existe pas dans ma collectivité", "Cette direction n'existe pas dans ma structure")) |> 
new_dataviz_comp("Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est :  [Services techniques]",
             "Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est : [Services techniques]")
ggsave(file = glue("../Graphiques/PNG/Comparaison 2022-2023 CT et EPCI hors com<3500 hab : Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est : [Services techniques].png"), plot = graph, width = 25, height = 18)
ggsave(file = glue("../Graphiques/SVG/Comparaison 2022-2023 CT et EPCI hors com<3500 hab : Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est : [Services techniques].svg"), plot = graph, width = 25, height = 18)

all_stat |> 
  mutate(Réponses = str_replace_all(Réponses, "Cette direction n'existe pas dans ma collectivité", "Cette direction n'existe pas dans ma structure")) |> 
new_dataviz_comp("Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est :  [Ressources humaines]",
             "Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est : [Ressources humaines]")
ggsave(file = glue("../Graphiques/PNG/Comparaison 2022-2023 CT et EPCI hors com<3500 hab : Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est : [Ressources humaines].png"), plot = graph, width = 25, height = 18)
ggsave(file = glue("../Graphiques/SVG/Comparaison 2022-2023 CT et EPCI hors com<3500 hab : Pour chacune des directions suivantes, pouvez-vous nous dire si leur implication en matière de gestion des données est : [Ressources humaines].svg"), plot = graph, width = 25, height = 18)

all_stat |> 
  mutate(Réponses = str_replace_all(Réponses, "Ma collectivité n’est pas concernée par cette obligation", "Ma structure n’est pas concernée par cette obligation")) |> 
  new_dataviz_comp("Pensez-vous que les services de votre collectivité sont bien informés des obligations d’open data applicables depuis 2018 à toutes les collectivités de plus de 3 500 habitants ?",
             "Pensez-vous que les services de votre structure sont bien informés des obligations d’open data applicables depuis 2018 à toutes les administrations publiques de plus de 50 ETP, et notamment les collectivités de plus de 3 500 habitants ?")
ggsave(file = glue("../Graphiques/PNG/Comparaison 2022-2023 CT et EPCI hors com<3500 hab : Pensez-vous que les services de votre structure sont bien informés des obligations d’open data applicables depuis 2018.png"), plot = graph, width = 25, height = 15)

new_dataviz_comp(all_stat, "Depuis le 1er juillet 2020, les collectivités sont également soumises à une obligation de « transparence algorithmique ». Pensez-vous que les services de votre collectivité sont bien informés de cette obligation légale ?",
             "Depuis le 1er juillet 2020, les collectivités sont également soumises à une obligation de « transparence algorithmique ». Pensez-vous que les services de votre structure sont bien informés de cette obligation légale ?")
saving_newplot(graph, "Pensez-vous que les services de votre structure sont bien informés de cette obligation légale ?")

new_dataviz_comp(all_stat, "Votre collectivité a-t-elle conduit des actions pour mettre en œuvre les obligations de transparence algorithmique ?",
             "Votre structure a-t-elle conduit des actions pour mettre en œuvre les obligations de transparence algorithmique ?")
saving_newplot(graph, "Votre structure a-t-elle conduit des actions pour mettre en œuvre les obligations de transparence algorithmique ?")

new_dataviz_comp(all_stat, "Votre collectivité a-t-elle déjà mis en place des expérimentations ayant recours à l’intelligence artificielle ? ",
             "Votre structure a-t-elle déjà mis en place des projets ou expérimentations ayant recours à l’intelligence artificielle ?")
saving_newplot(graph, "Votre structure a-t-elle déjà mis en place des projets ou expérimentations ayant recours à l’intelligence artificielle ?")

new_dataviz_comp(all_stat, "Aujourd’hui, les données de votre collectivité sont majoritairement hébergées :",
             "Aujourd’hui, les données de votre structure sont majoritairement hébergées :")
saving_newplot(graph, "Aujourd’hui, les données de votre structure sont majoritairement hébergées")

new_dataviz_comp(all_stat, "Certaines collectivités locales attachent une importance particulière au caractère « souverain » des outils et des logiciels qu'elles utilisent. Ce caractère « souverain » peut se traduire par le choix prioritaire de logiciels français ou européens, ou encore par le recours à des solutions dites « open source » (c'est-à-dire dont le code informatique est libre de droits et géré par des communautés d'utilisateurs).  Pour le choix de ses outils et logiciels, votre collectivité :",
             "Certaines structures attachent une importance particulière au caractère « souverain » des outils et des logiciels qu'elles utilisent. Cela peut se traduire par le choix prioritaire de logiciels français ou européens, ou encore par le recours à des solutions dites « open source » (dont le code informatique est libre de droits et géré par des communautés d'utilisateurs).   Pour le choix de ses outils et logiciels, votre structure :")
saving_newplot(graph, "Certaines structures attachent une importance particulière au caractère « souverain » des outils et des logiciels qu'elles utilisent. Pour le choix de ses outils et logiciels, votre structure :")

all_stat |> 
  mutate(Réponses = str_replace_all(Réponses, "collectivité", "structure")) |> 
  new_dataviz_comp("Lorsqu'une alternative open source est identifiée :",
             "Lorsqu'une alternative open source est identifiée :")
saving_newplot(graph, "Lorsqu'une alternative open source est identifiée")

new_dataviz_comp(all_stat, "Votre collectivité a-t-elle déjà dû faire face à une cyberattaque importante ?",
               "Votre structure a-t-elle déjà dû faire face à une cyberattaque importante ?")
saving_newplot(graph, "Votre structure a-t-elle déjà dû faire face à une cyberattaque importante ?")

new_dataviz_comp(all_stat, "Pensez-vous que votre collectivité est exposée à des attaques cyber ?",
               "Pensez-vous que votre structure est exposée à des attaques cyber ?")
saving_newplot(graph, "Pensez-vous que votre structure est exposée à des attaques cyber ?")

new_dataviz_comp(all_stat, "Comment estimez-vous le niveau de prise en compte du risque cyber par votre collectivité ?",
               "Comment estimez-vous le niveau de prise en compte du risque cyber par votre structure ?")
saving_newplot(graph, "Comment estimez-vous le niveau de prise en compte du risque cyber par votre structure ?")

new_dataviz_comp(all_stat, "Quels sont, selon vous, les principaux obstacles à la diffusion d’outils de sécurité informatique dans votre collectivité ?",
               "Quels sont, selon vous, les principaux obstacles à la mise en place d’outils de sécurité informatique dans votre structure ?")
saving_newplot(graph, "Quels sont, selon vous, les principaux obstacles à la mise en place d’outils de sécurité informatique dans votre structure ?")

new_dataviz_comp(all_stat, "Parmi les mesures suivantes qui visent à réduire le risque de cybersécurité, est-ce que votre collectivité a mis en place :  [Une formation pour les agents et les élus ]",
               "Parmi les mesures suivantes, qui visent à réduire le risque de cybersécurité, est-ce que votre structure a mis en place : [Une formation pour les agents et les élus]")
saving_newplot(graph, "Parmi les mesures suivantes, qui visent à réduire le risque de cybersécurité, est-ce que votre structure a mis en place : [Une formation pour les agents et les élus]")

new_dataviz_comp(all_stat, "Parmi les mesures suivantes qui visent à réduire le risque de cybersécurité, est-ce que votre collectivité a mis en place :  [La désignation d’un responsable de sécurité informatique (RSSI ou autre)]",
               "Parmi les mesures suivantes, qui visent à réduire le risque de cybersécurité, est-ce que votre structure a mis en place : [La désignation d’un responsable de sécurité informatique (RSSI ou autre)]")
saving_newplot(graph, "Parmi les mesures suivantes est-ce que votre structure a mis en place : [La désignation d’un responsable de sécurité informatique]")

new_dataviz_comp(all_stat, "Parmi les mesures suivantes qui visent à réduire le risque de cybersécurité, est-ce que votre collectivité a mis en place :  [Une stratégie de sécurité informatique]",
               "Parmi les mesures suivantes, qui visent à réduire le risque de cybersécurité, est-ce que votre structure a mis en place : [Une stratégie de sécurité informatique]")
saving_newplot(graph, "Parmi les mesures suivantes, qui visent à réduire le risque de cybersécurité, est-ce que votre structure a mis en place : [Une stratégie de sécurité informatique]")

new_dataviz_comp(all_stat, "Parmi les mesures suivantes qui visent à réduire le risque de cybersécurité, est-ce que votre collectivité a mis en place :  [Un processus de certification (ISO 27001)]",
               "Parmi les mesures suivantes, qui visent à réduire le risque de cybersécurité, est-ce que votre structure a mis en place : [Un processus de certification (ISO 27001)]")
saving_newplot(graph, "Parmi les mesures suivantes, qui visent à réduire le risque de cybersécurité, est-ce que votre structure a mis en place : [Un processus de certification (ISO 27001)]")

new_dataviz_comp(all_stat, "Parmi les mesures suivantes qui visent à réduire le risque de cybersécurité, est-ce que votre collectivité a mis en place :  [Une obligation d’hébergement souverain (français ou européen)]",
               "Parmi les mesures suivantes, qui visent à réduire le risque de cybersécurité, est-ce que votre structure a mis en place : [Une obligation d’hébergement souverain (français ou européen)]")
saving_newplot(graph, "Parmi les mesures suivantes, qui visent à réduire le risque de cybersécurité, est-ce que votre structure a mis en place : [Une obligation d’hébergement souverain (français ou européen)]")

new_dataviz_comp(all_stat, "Parmi les mesures suivantes qui visent à réduire le risque de cybersécurité, est-ce que votre collectivité a mis en place :  [Des clauses de sécurité dans les contrats informatiques]",
               "Parmi les mesures suivantes, qui visent à réduire le risque de cybersécurité, est-ce que votre structure a mis en place : [Des clauses de sécurité dans les contrats informatiques]")
saving_newplot(graph, "Parmi les mesures suivantes, qui visent à réduire le risque de cybersécurité, est-ce que votre structure a mis en place : [Des clauses de sécurité dans les contrats informatiques]")

new_dataviz_comp(all_stat, "Parmi les mesures suivantes qui visent à réduire le risque de cybersécurité, est-ce que votre collectivité a mis en place :  [Des clauses de sécurité pour les délégations de service public]",
               "Parmi les mesures suivantes, qui visent à réduire le risque de cybersécurité, est-ce que votre structure a mis en place : [Des clauses de sécurité pour les délégations de service public]")
saving_newplot(graph, "Parmi les mesures suivantes, qui visent à réduire le risque de cybersécurité, est-ce que votre structure a mis en place : [Des clauses de sécurité pour les délégations de service public]")

new_dataviz_comp(all_stat, "Parmi les mesures suivantes qui visent à réduire le risque de cybersécurité, est-ce que votre collectivité a mis en place :  [Une coopération avec l’Agence nationale de la sécurité des systèmes d’information (ANSSI) ou avec un cyber campus régional]",
               "Parmi les mesures suivantes, qui visent à réduire le risque de cybersécurité, est-ce que votre structure a mis en place : [Une coopération avec l’Agence nationale de la sécurité des systèmes d’information (ANSSI) ou avec un cyber campus régional]")
ggsave(file = glue("../Graphiques/PNG/Comparaison 2022-2023 CT et EPCI hors com<3500 hab : Parmi les mesures suivantes, qui visent à réduire le risque de cybersécurité, est-ce que votre structure a mis en place : [Une coopération avec l’ANSSI ou avec un cyber campus régional].png"), plot = graph, width = 25, height = 15)

new_dataviz_comp(all_stat, "Parmi les mesures suivantes qui visent à réduire le risque de cybersécurité, est-ce que votre collectivité a mis en place :  [Le déploiement d’outils techniques de sécurisation des réseaux informatiques]",
               "Parmi les mesures suivantes, qui visent à réduire le risque de cybersécurité, est-ce que votre structure a mis en place : [Le déploiement d’outils techniques de sécurisation des réseaux informatiques]")
saving_newplot(graph, "armi les mesures suivantes, qui visent à réduire le risque de cybersécurité, est-ce que votre structure a mis en place : [Le déploiement d’outils techniques de sécurisation des réseaux informatiques]")

new_dataviz_comp(all_stat, "Votre collectivité a-t-elle engagé une réflexion sur les enjeux du numérique responsable ?",
               "Votre structure a-t-elle engagé une réflexion sur les enjeux du numérique responsable ?")
saving_newplot(graph, "Votre structure a-t-elle engagé une réflexion sur les enjeux du numérique responsable ?")














